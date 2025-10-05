import 'package:flutter/material.dart';

class FooterItem {
  const FooterItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.tooltip,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;
  final int badgeCount;
}

enum FooterType {
  bottomNavigation,
  tabBar,
  custom,
}