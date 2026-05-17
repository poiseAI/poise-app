import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ToastificationWrapper(
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => ref.read(authProvider.notifier).recordActivity(),
        onPointerMove: (_) => ref.read(authProvider.notifier).recordActivity(),
        onPointerSignal: (_) =>
            ref.read(authProvider.notifier).recordActivity(),
        child: MaterialApp.router(
          title: 'Poise AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          routerConfig: router,
          builder: (context, child) => _SessionInvalidationListener(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
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
