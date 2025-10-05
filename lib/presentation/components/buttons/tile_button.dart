import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

enum TileButtonVariant { primary, accent }

class TileButton extends StatelessWidget {
  const TileButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onPressed,
    this.variant = TileButtonVariant.primary,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onPressed;
  final TileButtonVariant variant;

  Color get _backgroundColor {
    switch (variant) {
      case TileButtonVariant.primary:
        return backgroundDefault;
      case TileButtonVariant.accent:
        return backgroundAccent;
    }
  }

  Color get _iconColor {
    switch (variant) {
      case TileButtonVariant.primary:
        return textAccent;
      case TileButtonVariant.accent:
        return textOnPrimary;
    }
  }

  Color get _textColor {
    switch (variant) {
      case TileButtonVariant.primary:
        return textPrimary;
      case TileButtonVariant.accent:
        return textOnPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppDimensions.borderRadiusAllMedium,
        boxShadow: AppDimensions.shadowSmall,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppDimensions.borderRadiusAllMedium,
          child: Padding(
            padding: AppDimensions.paddingAllSmall,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: _iconColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.buttonLarge.copyWith(color: _textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(color: _textColor),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
