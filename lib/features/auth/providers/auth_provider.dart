import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/websocket/ws_service.dart';
import '../../../core/utils/result.dart';
import '../../strategies/data/strategies_api.dart';
import '../../billing/data/billing_api.dart';
import '../data/auth_api.dart';
import '../data/models/auth_response.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  Timer? _refreshTimer;
  final Map<String, _LoginAttemptState> _loginAttempts = {};
  static const maxSessionAgeMonths = 30;
  static const maxFailedLoginAttempts = 5;
  static const loginLockoutDuration = Duration(minutes: 5);

  @override
  Future<AuthState> build() async {
    // When interceptor bumps this counter (on 401), provider rebuilds → logout
    ref.watch(authInvalidatedProvider);

    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) {
      _cancelSessionTimers();
      return const AuthState.unauthenticated();
    }
    if (await _localSessionExpired()) {
      _cancelSessionTimers();
      await ref.read(secureStorageProvider).clearSession();
      return const AuthState.unauthenticated();
    }

    final result = await ref.read(authApiProvider).getMe();
    return await result.fold(
      onOk: (data) async {
        final userId = (data['id'] ?? data['user_id']) as String? ?? '';
        final email = data['email'] as String? ?? '';
        final fullName = (data['full_name'] ?? data['name'] ?? data['fullName'])
                as String? ??
            '';
        final emailVerified = data['email_verified'] as bool? ?? true;
        final hasExchangeConnection =
            data['has_exchange_connection'] as bool? ??
                data['exchange_setup_complete'] as bool? ??
                false;
        final subscription = _subscriptionFromProfile(data);
        _connectWs(token);
        _scheduleProactiveRefresh(token);

        // Check whether user already has an active strategy
        final strategiesResult =
            await ref.read(strategiesApiProvider).getActiveStrategies();
        final hasActiveStrategy =
            strategiesResult.valueOrNull?.isNotEmpty ?? false;

        return AuthState.authenticated(
          userId: userId,
          email: email,
          token: token,
          fullName: fullName,
          emailVerified: emailVerified,
          isAdmin: data['is_admin'] as bool? ?? false,
          totpEnabled: data['totp_enabled'] as bool? ?? false,
          hasActiveStrategy: hasActiveStrategy,
          hasExchangeConnection: hasExchangeConnection,
          subscription: subscription,
        );
      },
      onErr: (_) async {
        _cancelSessionTimers();
        return const AuthState.unauthenticated();
      },
    );
  }

  Future<Result<void, String>> login(
    String email,
    String password, {
    String? totpToken,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final lockedMessage = _lockoutMessageFor(normalizedEmail);
    if (lockedMessage != null) return Err(lockedMessage);

    state = const AsyncLoading();
    final sessionId = _newSessionId();
    final result = await ref.read(authApiProvider).login(
          email: normalizedEmail,
          password: password,
          totpToken: totpToken,
          sessionId: sessionId,
        );

    return result.fold(
      onOk: (resp) async {
        _loginAttempts.remove(normalizedEmail);
        await _persistAndActivate(resp, sessionId: sessionId);
        return const Ok(null);
      },
      onErr: (err) {
        state = const AsyncData(AuthState.unauthenticated());
        if (err is InvalidCredentialsError) {
          final message = _recordFailedLogin(normalizedEmail);
          if (message != null) return Err(message);
        }
        return Err(err.userMessage);
      },
    );
  }

  Future<Result<void, String>> register(
    String fullName,
    String email,
    String password,
  ) async {
    state = const AsyncLoading();
    final sessionId = _newSessionId();
    final result = await ref.read(authApiProvider).register(
          fullName: fullName,
          email: email,
          password: password,
          sessionId: sessionId,
        );

    return result.fold(
      onOk: (resp) async {
        await _persistAndActivate(
          resp,
          checkExistingStrategy: false,
          sessionId: sessionId,
        );
        return const Ok(null);
      },
      onErr: (err) {
        state = const AsyncData(AuthState.unauthenticated());
        return Err(err.userMessage);
      },
    );
  }

  Future<void> logout() async {
    _cancelSessionTimers();
    ref.read(wsServiceProvider).disconnect();
    await ref.read(secureStorageProvider).clearAll();
    state = const AsyncData(AuthState.unauthenticated());
  }

  Future<Result<void, String>> verifyEmail(String otp) async {
    final result = await ref.read(authApiProvider).verifyEmail(otp);
    return result.fold(
      onOk: (_) async {
        await refreshSession();
        return const Ok(null);
      },
      onErr: (err) => Err(err.userMessage),
    );
  }

  Future<Result<void, String>> resendEmailVerification() async {
    final result = await ref.read(authApiProvider).resendEmailVerification();
    return result.fold(
      onOk: (_) => const Ok(null),
      onErr: (err) => Err(err.userMessage),
    );
  }

  Future<void> refreshSession() async {
    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) {
      state = const AsyncData(AuthState.unauthenticated());
      return;
    }
    if (await _localSessionExpired()) {
      await logout();
      return;
    }

    final result = await ref.read(authApiProvider).getMe();
    await result.fold(
      onOk: (data) async {
        final userId = (data['id'] ?? data['user_id']) as String? ?? '';
        final email = data['email'] as String? ?? '';
        final fullName = (data['full_name'] ?? data['name'] ?? data['fullName'])
                as String? ??
            '';
        final emailVerified = data['email_verified'] as bool? ?? true;
        final hasExchangeConnection =
            data['has_exchange_connection'] as bool? ??
                data['exchange_setup_complete'] as bool? ??
                false;
        final subscription = _subscriptionFromProfile(data);
        final strategiesResult =
            await ref.read(strategiesApiProvider).getActiveStrategies();
        final hasActiveStrategy =
            strategiesResult.valueOrNull?.isNotEmpty ?? false;
        state = AsyncData(AuthState.authenticated(
          userId: userId,
          email: email,
          token: token,
          fullName: fullName,
          emailVerified: emailVerified,
          isAdmin: data['is_admin'] as bool? ?? false,
          totpEnabled: data['totp_enabled'] as bool? ?? false,
          hasActiveStrategy: hasActiveStrategy,
          hasExchangeConnection: hasExchangeConnection,
          subscription: subscription,
        ));
      },
      onErr: (_) async => logout(),
    );
  }

  void markHasActiveStrategy() {
    final current = state.valueOrNull;
    if (current is AuthAuthenticated) {
      state = AsyncData(current.copyWith(hasActiveStrategy: true));
    }
  }

  void markHasExchangeConnection() {
    final current = state.valueOrNull;
    if (current is AuthAuthenticated) {
      state = AsyncData(current.copyWith(hasExchangeConnection: true));
    }
  }

  void markTotpEnabled() {
    final current = state.valueOrNull;
    if (current is AuthAuthenticated) {
      state = AsyncData(current.copyWith(totpEnabled: true));
    }
  }

  void markTotpDisabled() {
    final current = state.valueOrNull;
    if (current is AuthAuthenticated) {
      state = AsyncData(current.copyWith(totpEnabled: false));
    }
  }

  Future<void> _persistAndActivate(
    AuthResponse resp, {
    bool checkExistingStrategy = true,
    String? sessionId,
  }) async {
    await ref.read(secureStorageProvider).saveToken(resp.token);
    await ref
        .read(secureStorageProvider)
        .saveSessionExpiresAt(_sessionExpiresAtFrom(DateTime.now()));
    final activeSessionId = resp.sessionId ?? sessionId;
    if (activeSessionId != null) {
      await ref.read(secureStorageProvider).saveSessionId(activeSessionId);
    }
    await ref.read(secureStorageProvider).saveUserId(resp.user.id);
    _connectWs(resp.token);
    _scheduleProactiveRefresh(resp.token);

    // Compute strategy status BEFORE emitting state so the router only
    // fires once with the correct value — avoids a flash of the onboarding
    // screen for returning users who already have an active strategy.
    final bool hasActiveStrategy;
    if (checkExistingStrategy) {
      final result =
          await ref.read(strategiesApiProvider).getActiveStrategies();
      hasActiveStrategy = result.valueOrNull?.isNotEmpty ?? false;
    } else {
      hasActiveStrategy = false;
    }

    state = AsyncData(AuthState.authenticated(
      userId: resp.user.id,
      email: resp.user.email,
      token: resp.token,
      fullName: resp.user.fullName,
      emailVerified: resp.user.emailVerified,
      isAdmin: resp.user.isAdmin,
      totpEnabled: resp.user.totpEnabled,
      hasActiveStrategy: hasActiveStrategy,
      hasExchangeConnection: resp.user.hasExchangeConnection,
      subscription: resp.user.subscription,
    ));
  }

  void _connectWs(String token) {
    ref.read(wsServiceProvider).connect(token);
  }

  void _scheduleProactiveRefresh(String _) {
    // The backend owns JWT/session expiry; this timer is intentionally disabled.
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _cancelSessionTimers() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<bool> _localSessionExpired() async {
    final storage = ref.read(secureStorageProvider);
    final expiresAt = await storage.getSessionExpiresAt();
    if (expiresAt == null) {
      await storage.saveSessionExpiresAt(_sessionExpiresAtFrom(DateTime.now()));
      return false;
    }
    return !DateTime.now().isBefore(expiresAt);
  }

  DateTime _sessionExpiresAtFrom(DateTime from) {
    final targetMonth = from.month + maxSessionAgeMonths;
    final year = from.year + ((targetMonth - 1) ~/ 12);
    final month = ((targetMonth - 1) % 12) + 1;
    final day = min(from.day, _daysInMonth(year, month));
    return DateTime(
      year,
      month,
      day,
      from.hour,
      from.minute,
      from.second,
      from.millisecond,
      from.microsecond,
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  String? _lockoutMessageFor(String email) {
    final attempts = _loginAttempts[email];
    final lockedUntil = attempts?.lockedUntil;
    if (lockedUntil == null) return null;

    final now = DateTime.now();
    if (now.isAfter(lockedUntil)) {
      _loginAttempts.remove(email);
      return null;
    }

    return _lockoutMessage(lockedUntil);
  }

  String? _recordFailedLogin(String email) {
    final previous = _loginAttempts[email];
    final failedAttempts = (previous?.failedAttempts ?? 0) + 1;
    if (failedAttempts < maxFailedLoginAttempts) {
      _loginAttempts[email] = _LoginAttemptState(failedAttempts);
      return null;
    }

    final lockedUntil = DateTime.now().add(loginLockoutDuration);
    _loginAttempts[email] = _LoginAttemptState(
      failedAttempts,
      lockedUntil: lockedUntil,
    );
    return _lockoutMessage(lockedUntil);
  }

  String _lockoutMessage(DateTime lockedUntil) {
    final remaining = lockedUntil.difference(DateTime.now());
    final minutes =
        remaining.inMinutes + (remaining.inSeconds % 60 == 0 ? 0 : 1);
    return 'Account temporarily locked. Try again in $minutes minutes.';
  }

  String _newSessionId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

BillingSubscription _subscriptionFromProfile(Map<String, dynamic> data) {
  final raw = data['subscription'];
  if (raw is Map<String, dynamic>) {
    return BillingSubscription.fromJson(raw);
  }
  if (raw is Map) {
    return BillingSubscription.fromJson(Map<String, dynamic>.from(raw));
  }
  return BillingSubscription.none;
}

final class _LoginAttemptState {
  const _LoginAttemptState(this.failedAttempts, {this.lockedUntil});

  final int failedAttempts;
  final DateTime? lockedUntil;
}
