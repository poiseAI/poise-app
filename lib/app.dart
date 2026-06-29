import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _lastHandledBillingLink;

  @override
  void initState() {
    super.initState();
    _initBillingLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initBillingLinks() async {
    try {
      _handleBillingLink(await _appLinks.getInitialLink());
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _handleBillingLink,
        onError: (_) {},
      );
    } catch (_) {
      // Billing links are non-critical during normal app startup.
    }
  }

  void _handleBillingLink(Uri? uri) {
    final route = _billingRouteFor(uri);
    if (uri == null || route == null) return;
    if (!mounted) return;

    final link = uri.toString();
    if (_lastHandledBillingLink == link) return;
    _lastHandledBillingLink = link;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(appRouterProvider).go(route);
    });
  }

  String? _billingRouteFor(Uri? uri) {
    if (uri == null) return null;

    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    final isAppBillingLink = (scheme == 'poise' || scheme == 'poiseai') &&
        (host == 'billing' || path.startsWith('/billing'));
    final isWebBillingLink = scheme == 'https' &&
        (host == 'poise.brainpad.me' || host == 'poiseai.brainpad.me') &&
        path.startsWith('/billing');

    if (!isAppBillingLink && !isWebBillingLink) return null;

    final target = host == 'billing' ? path : path.replaceFirst('/billing', '');
    if (target.startsWith('/success')) return Routes.billingSuccess;
    return Routes.billing;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ToastificationWrapper(
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
