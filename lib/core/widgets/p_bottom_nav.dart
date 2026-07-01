import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/providers/auth_state.dart';
import 'buttons/p_primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../router/routes.dart';

class PBottomNav extends ConsumerWidget {
  const PBottomNav({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);
    final auth = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      body: child,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 20),
        child: _NavFab(onTap: () => _handleTradeTap(context, auth)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _PNavBar(currentIndex: currentIndex),
    );
  }

  void _handleTradeTap(BuildContext context, AuthState? auth) {
    if (auth is AuthAuthenticated && !auth.hasExchangeConnection) {
      _showConnectExchangeDialog(context);
      return;
    }
    context.go(Routes.trade);
  }

  int _indexForLocation(String location) {
    if (location.startsWith('/app/home')) return 0;
    if (location.startsWith('/app/ai')) return 1;
    if (location.startsWith('/app/orders') ||
        location.startsWith('/app/trade')) {
      return 2;
    }
    if (location.startsWith('/app/profile')) return 3;
    return 0;
  }
}

Future<void> _showConnectExchangeDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Connect exchange',
    barrierColor: const Color(0xAD121212),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, _, __) {
      return _ConnectExchangeRequiredDialog(
        onClose: () => Navigator.of(dialogContext).pop(),
        onConnect: () {
          Navigator.of(dialogContext).pop();
          context.go('${Routes.exchangeConnections}?from=onboarding');
        },
      );
    },
    transitionBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _ConnectExchangeRequiredDialog extends StatelessWidget {
  const _ConnectExchangeRequiredDialog({
    required this.onClose,
    required this.onConnect,
  });

  final VoidCallback onClose;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            key: const ValueKey('connect-exchange-required-card'),
            width: 362,
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 5),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Connect exchange',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textHeading,
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onClose,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.bgSecondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/empty-home-rocket.png',
                  key: const ValueKey('connect-exchange-rocket'),
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 342,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 282,
                          child: Text(
                            'Connect an exchange to trade',
                            textAlign: TextAlign.center,
                            style: AppTypography.display2.copyWith(
                              color: AppColors.textHeading,
                              fontSize: 24,
                              height: 32 / 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 266,
                          child: Text(
                            'Connect Binance or Bybit first, it takes about a minute.',
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textHeading,
                              fontSize: 14,
                              height: 20 / 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PPrimaryButton(
                  label: 'Connect exchange',
                  height: 44,
                  borderRadius: AppRadius.pillRadius,
                  textStyle: AppTypography.buttonLg.copyWith(
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                  onPressed: onConnect,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PNavBar extends StatelessWidget {
  const _PNavBar({required this.currentIndex});

  final int currentIndex;

  static const _leftItems = [
    (
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      path: Routes.home,
      index: 0,
    ),
    (
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome,
      label: 'Poise AI',
      path: Routes.ai,
      index: 1,
    ),
  ];

  static const _rightItems = [
    (
      icon: Icons.show_chart_outlined,
      activeIcon: Icons.show_chart_rounded,
      label: 'Trades',
      path: Routes.orders,
      index: 2,
    ),
    (
      icon: Icons.account_circle_outlined,
      activeIcon: Icons.account_circle,
      label: 'Profile',
      path: Routes.profile,
      index: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (final item in _leftItems)
                Expanded(
                  child: _NavItem(
                    item: (
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                      label: item.label,
                      path: item.path,
                    ),
                    isSelected: currentIndex == item.index,
                    onTap: () => context.go(item.path),
                  ),
                ),
              const SizedBox(width: 80),
              for (final item in _rightItems)
                Expanded(
                  child: _NavItem(
                    item: (
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                      label: item.label,
                      path: item.path,
                    ),
                    isSelected: currentIndex == item.index,
                    onTap: () => context.go(item.path),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavFab extends StatelessWidget {
  const _NavFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('bottom-nav-trade-fab'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.40),
              blurRadius: 16,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final ({IconData icon, IconData activeIcon, String label, String path}) item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isSelected ? 1.0 : 0.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isSelected != old.isSelected) {
      if (widget.isSelected) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isSelected ? AppColors.primary : AppColors.textTertiary;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Icon(
                widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                key: ValueKey(widget.isSelected),
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.item.label,
              style: AppTypography.labelSm.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
