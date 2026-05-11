import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../router/routes.dart';

class PBottomNav extends StatelessWidget {
  const PBottomNav({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: _PNavBar(currentIndex: currentIndex),
    );
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

class _PNavBar extends StatelessWidget {
  const _PNavBar({required this.currentIndex});
  final int currentIndex;

  static const _items = [
    (
      icon: Icons.home_outlined,
      activeIcon: Icons.home_outlined,
      label: 'Home',
      path: Routes.home
    ),
    (
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_outlined,
      label: 'Poise AI',
      path: Routes.ai
    ),
    (
      icon: Icons.show_chart_rounded,
      activeIcon: Icons.show_chart_rounded,
      label: 'Trades',
      path: Routes.orders
    ),
    (
      icon: Icons.account_circle_outlined,
      activeIcon: Icons.account_circle_outlined,
      label: 'Profile',
      path: Routes.profile
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(
              _items.length,
              (i) => Expanded(
                child: _NavItem(
                  item: _items[i],
                  isSelected: i == currentIndex,
                  onTap: () => context.go(_items[i].path),
                ),
              ),
            ),
          ),
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    widget.isSelected
                        ? widget.item.activeIcon
                        : widget.item.icon,
                    key: ValueKey(widget.isSelected),
                    color: color,
                    size: 23,
                  ),
                ),
              ],
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
