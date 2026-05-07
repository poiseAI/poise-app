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
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/onboarding/screens/set_risk_appetite_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/trade_entry/screens/trade_entry_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/ai_chat/screens/ai_chat_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/trade_validation/screens/exit_request_screen.dart';
import '../../features/trade_validation/screens/exit_otp_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/tpsl/screens/tpsl_screen.dart';
import '../widgets/p_bottom_nav.dart';
import '../widgets/ws_status_banner.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  ref.watch(authProvider); // triggers router rebuild on auth change

  return GoRouter(
    initialLocation: Routes.welcome,
    debugLogDiagnostics: true,
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
            path: Routes.ai,
            pageBuilder: (context, state) =>
                _fadeTransition(state, const AiChatScreen()),
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
      GoRoute(
        path: Routes.positionTpsl,
        pageBuilder: (context, state) => _sheetTransition(
          state,
          TpSlScreen(positionId: state.pathParameters['id']!),
        ),
      ),
    ],
  );
}

String? _redirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider).valueOrNull;
  final loc = state.matchedLocation;
  final isAuthRoute = loc.startsWith('/auth');

  if (auth == null) return null; // loading — no redirect

  return switch (auth) {
    AuthUnauthenticated() when !isAuthRoute => Routes.welcome,
    AuthAuthenticated(:final hasActiveStrategy)
        when !hasActiveStrategy =>
      Routes.riskAppetite,
    AuthAuthenticated() when isAuthRoute => Routes.home,
    _ => null,
  };
}

// ── Page transition helpers ──────────────────────────────────────────────────

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
