import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/websocket/ws_service.dart';
import '../../../core/utils/result.dart';
import '../../strategies/data/strategies_api.dart';
import '../data/auth_api.dart';
import '../data/models/auth_response.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  Timer? _refreshTimer;
  Timer? _inactivityTimer;
  static const inactivityTimeout = Duration(minutes: 15);

  @override
  Future<AuthState> build() async {
    // When interceptor bumps this counter (on 401), provider rebuilds → logout
    ref.watch(authInvalidatedProvider);

    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) {
      _cancelSessionTimers();
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
        _connectWs(token);
        _scheduleProactiveRefresh(token);

        // Check whether user already has an active strategy
        final strategiesResult =
            await ref.read(strategiesApiProvider).getActiveStrategies();
        final hasActiveStrategy =
            strategiesResult.valueOrNull?.isNotEmpty ?? false;
        _scheduleInactivityTimeout();

        return AuthState.authenticated(
          userId: userId,
          email: email,
          token: token,
          fullName: fullName,
          emailVerified: emailVerified,
          isAdmin: data['is_admin'] as bool? ?? false,
          totpEnabled: data['totp_enabled'] as bool? ?? false,
          hasActiveStrategy: hasActiveStrategy,
        );
      },
      onErr: (_) async {
        _cancelSessionTimers();
        return const AuthState.unauthenticated();
      },
    );
  }

  void recordActivity() {
    if (state.valueOrNull is AuthAuthenticated) {
      _scheduleInactivityTimeout();
    }
  }

  Future<Result<void, String>> login(
    String email,
    String password, {
    String? totpToken,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(authApiProvider).login(
          email: email,
          password: password,
          totpToken: totpToken,
        );

    return result.fold(
      onOk: (resp) async {
        await _persistAndActivate(resp);
        return const Ok(null);
      },
      onErr: (err) {
        state = const AsyncData(AuthState.unauthenticated());
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
    final result = await ref.read(authApiProvider).register(
          fullName: fullName,
          email: email,
          password: password,
        );

    return result.fold(
      onOk: (resp) async {
        await _persistAndActivate(resp, checkExistingStrategy: false);
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

    final result = await ref.read(authApiProvider).getMe();
    await result.fold(
      onOk: (data) async {
        final userId = (data['id'] ?? data['user_id']) as String? ?? '';
        final email = data['email'] as String? ?? '';
        final fullName = (data['full_name'] ?? data['name'] ?? data['fullName'])
                as String? ??
            '';
        final emailVerified = data['email_verified'] as bool? ?? true;
        final strategiesResult =
            await ref.read(strategiesApiProvider).getActiveStrategies();
        final hasActiveStrategy =
            strategiesResult.valueOrNull?.isNotEmpty ?? false;
        _scheduleInactivityTimeout();
        state = AsyncData(AuthState.authenticated(
          userId: userId,
          email: email,
          token: token,
          fullName: fullName,
          emailVerified: emailVerified,
          isAdmin: data['is_admin'] as bool? ?? false,
          totpEnabled: data['totp_enabled'] as bool? ?? false,
          hasActiveStrategy: hasActiveStrategy,
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
  }) async {
    await ref.read(secureStorageProvider).saveToken(resp.token);
    await ref.read(secureStorageProvider).saveUserId(resp.user.id);
    _connectWs(resp.token);
    _scheduleProactiveRefresh(resp.token);
    _scheduleInactivityTimeout();

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
    ));
  }

  void _connectWs(String token) {
    ref.read(wsServiceProvider).connect(token);
  }

  void _scheduleProactiveRefresh(String token) {
    // JWT is 24hr — schedule re-validate at 23hr mark
    _refreshTimer?.cancel();
    _refreshTimer = Timer(
      const Duration(hours: 23),
      () async {
        final result = await ref.read(authApiProvider).getMe();
        if (result.isErr) await logout();
      },
    );
  }

  void _scheduleInactivityTimeout() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, () async {
      await logout();
    });
  }

  void _cancelSessionTimers() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }
}
