import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/router/app_router.dart';
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
        ),
      ),
    );
  }
}
