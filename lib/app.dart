import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/providers/auth_state.dart';
import 'features/auth/providers/session_lock_provider.dart';
import 'features/auth/screens/app_lock_screen.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(sessionLockProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(lock.handleResumed());
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(lock.markInactive());
    }
  }

  void _recordActivity() {
    ref.read(sessionLockProvider.notifier).recordActivity();
    ref.read(authProvider.notifier).recordActivity();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ToastificationWrapper(
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _recordActivity(),
        onPointerMove: (_) => _recordActivity(),
        onPointerSignal: (_) => _recordActivity(),
        child: MaterialApp.router(
          title: 'Poise AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          routerConfig: router,
          builder: (context, child) => _SessionInvalidationListener(
            child: _SessionLockGate(child: child ?? const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }
}

class _SessionLockGate extends ConsumerWidget {
  const _SessionLockGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider).valueOrNull;
    final isAuthenticated = auth is AuthAuthenticated;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ref.read(sessionLockProvider.notifier).setAuthenticated(isAuthenticated);
    });

    final lock = ref.watch(sessionLockProvider);
    if (!lock.blocksApp) return child;

    return Stack(
      children: [
        child,
        const Positioned.fill(child: AppLockScreen()),
      ],
    );
  }
}

class _SessionInvalidationListener extends ConsumerWidget {
  const _SessionInvalidationListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(authInvalidationReasonProvider, (_, message) {
      if (message == null || message.isEmpty) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(authInvalidationReasonProvider.notifier).state = null;
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Signed out on this device'),
            content: Text(
              message,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    });
    return child;
  }
}
