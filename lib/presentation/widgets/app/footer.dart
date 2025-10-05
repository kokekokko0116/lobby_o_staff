import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/state/app_layout_state.dart';
import 'footer_item.dart';
import '../../../core/constants/app_colors.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({
    super.key,
    required this.items,
    required this.onTap,
    this.type = FooterType.custom,
    this.enableSwipeGestures = true,
  });

  final List<FooterItem> items;
  final ValueChanged<int> onTap;
  final FooterType type;
  final bool enableSwipeGestures;

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> with TickerProviderStateMixin {
  late AnimationController _visibilityController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _visibilityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _visibilityController,
            curve: Curves.easeInOut,
          ),
        );

    _visibilityController.forward();
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLayout(),
      builder: (context, child) {
        if (AppLayout().isFooterVisible) {
          _visibilityController.forward();
        } else {
          _visibilityController.reverse();
        }

        return SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onPanEnd: widget.enableSwipeGestures ? _handlePanEnd : null,
            child: _buildFooterContent(),
          ),
        );
      },
    );
  }

  Widget _buildFooterContent() {
    switch (widget.type) {
      case FooterType.bottomNavigation:
        return _buildBottomNavigationBar();
      case FooterType.custom:
        return _buildCustomFooter();
      case FooterType.tabBar:
        return _buildBottomNavigationBar(); // 簡略化
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: backgroundSurface,
      currentIndex: AppLayout().currentIndex,
      onTap: _handleTap,
      type: BottomNavigationBarType.fixed,
      items: widget.items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: item.activeIcon != null
                  ? Icon(item.activeIcon)
                  : null,
              label: item.label,
              tooltip: item.tooltip ?? item.label,
            ),
          )
          .toList(),
    );
  }

  Widget _buildCustomFooter() {
    return Container(
      decoration: BoxDecoration(
        color: backgroundSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == AppLayout().currentIndex;

              return Expanded(
                child: _buildCustomFooterItem(item, index, isSelected),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFooterItem(FooterItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(item.icon, color: textPrimary, size: 24),
                if (item.badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -3,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: textError,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        item.badgeCount > 99
                            ? '99+'
                            : item.badgeCount.toString(),
                        style: TextStyle(
                          color: textError,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePanEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy > 300) {
      AppLayout().setFooterVisibility(false);
    } else if (details.velocity.pixelsPerSecond.dy < -300) {
      AppLayout().setFooterVisibility(true);
    }
  }

  void _handleTap(int index) {
    AppLayout().setCurrentIndex(index);
    widget.onTap(index);
    HapticFeedback.selectionClick();
  }
}
