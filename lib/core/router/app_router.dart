import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/providers/auth_state.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/onboarding/screens/set_risk_appetite_screen.dart';
import '../storage/preferences.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/trade_entry/screens/trade_entry_screen.dart';
import '../../features/trade_entry/screens/trade_validation_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/ai_chat/screens/ai_chat_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/trade_validation/screens/exit_request_screen.dart';
import '../../features/trade_validation/screens/exit_otp_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../widgets/p_bottom_nav.dart';
import '../widgets/ws_status_banner.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  ref.listen(authProvider, (_, __) => refreshNotifier.notify());
  ref.listen(appPreferencesProvider, (_, __) => refreshNotifier.notify());

  return GoRouter(
    initialLocation: Routes.welcome,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      // ── Auth (no shell) ─────────────────────────────────────────
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (context, state) =>
            _fadeTransition(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            _slideTransition(state, const LoginScreen()),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) =>
            _slideTransition(state, const RegisterScreen()),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        pageBuilder: (context, state) =>
            _slideTransition(state, const VerifyEmailScreen()),
      ),
      GoRoute(
        path: Routes.riskAppetite,
        pageBuilder: (context, state) =>
            _slideTransition(state, const SetRiskAppetiteScreen()),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) =>
            _slideTransition(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: Routes.resetPassword,
        pageBuilder: (context, state) => _slideTransition(
          state,
          ResetPasswordScreen(email: state.extra as String? ?? ''),
        ),
      ),

      // ── Main app shell ──────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => Column(
          children: [
            const WsStatusBanner(),
            Expanded(child: PBottomNav(child: child)),
          ],
        ),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) =>
                _fadeTransition(state, const HomeScreen()),
          ),
          GoRoute(
            path: Routes.trade,
            pageBuilder: (context, state) =>
                _fadeTransition(state, const TradeEntryScreen()),
          ),
          GoRoute(
            path: Routes.tradeValidation,
            pageBuilder: (context, state) =>
                _slideTransition(state, const TradeValidationScreen()),
          ),
          GoRoute(
            path: Routes.ai,
            pageBuilder: (context, state) => _fadeTransition(
              state,
              AiChatScreen(initialPrompt: state.extra as String?),
            ),
          ),
          GoRoute(
            path: Routes.notifications,
            pageBuilder: (context, state) =>
                _fadeTransition(state, const NotificationsScreen()),
          ),
          GoRoute(
            path: Routes.orders,
            pageBuilder: (context, state) =>
                _fadeTransition(state, const OrdersScreen()),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) =>
                _slideTransition(state, const ProfileScreen()),
          ),
        ],
      ),

      // ── Full-screen overlays (push over shell) ──────────────────
      GoRoute(
        path: Routes.positionExit,
        pageBuilder: (context, state) => _sheetTransition(
          state,
          ExitRequestScreen(positionId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.positionExitOtp,
        pageBuilder: (context, state) => _slideTransition(
          state,
          ExitOtpScreen(positionId: state.pathParameters['id']!),
        ),
      ),
    ],
  );
}

String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider).valueOrNull;
  if (auth == null) return null; // still loading

  final loc = state.matchedLocation;
  final onAuth = loc.startsWith('/auth');
  final onOnboarding = loc.startsWith('/onboarding');
  final hasSeenWelcome =
      ref.read(appPreferencesProvider).valueOrNull?.hasSeenWelcome ?? false;

  return switch (auth) {
    // Not logged in → must be on an auth route
    AuthUnauthenticated() when !onAuth => Routes.welcome,

    // Returning signed-out users should go straight to login after the first
    // welcome run, while fresh installs still see the onboarding carousel.
    AuthUnauthenticated() when hasSeenWelcome && loc == Routes.welcome =>
      Routes.login,

    // Logged in but onboarding incomplete → must be on onboarding route
    AuthAuthenticated(:final emailVerified)
        when !emailVerified && loc != Routes.verifyEmail =>
      Routes.verifyEmail,
    AuthAuthenticated(:final hasActiveStrategy, :final emailVerified)
        when emailVerified && !hasActiveStrategy && !onOnboarding =>
      Routes.riskAppetite,

    // Logged in and onboarding done → leave auth/onboarding routes
    AuthAuthenticated(:final hasActiveStrategy, :final emailVerified)
        when emailVerified && hasActiveStrategy && (onAuth || onOnboarding) =>
      Routes.home,
    _ => null,
  };
}

// ── Page transition helpers ──────────────────────────────────────────────────

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

CustomTransitionPage<void> _fadeTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

CustomTransitionPage<void> _slideTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(1.0, 0),
        end: Offset.zero,
      ).animate(curve);
      final secondarySlide = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.3, 0),
      ).animate(CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOutCubic,
      ));
      return SlideTransition(
        position: secondarySlide,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

CustomTransitionPage<void> _sheetTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, _, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final slide = Tween<Offset>(
        begin: const Offset(0, 1.0),
        end: Offset.zero,
      ).animate(curve);
      return SlideTransition(position: slide, child: child);
    },
  );
}
