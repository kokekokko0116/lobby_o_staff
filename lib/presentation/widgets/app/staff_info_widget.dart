import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_images.dart';

class StaffInfoWidget extends StatelessWidget {
  const StaffInfoWidget({
    super.key,
    required this.staffName,
    this.staffImagePath,
    this.label = '担当',
    this.size = 50.0,
  });

  final String staffName;
  final String? staffImagePath;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundAccent,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Image.asset(
              staffImagePath ?? AppImages.staffSample,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: backgroundAccent,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Icon(
                    Icons.person,
                    color: textSecondary,
                    size: size * 0.64, // サイズに比例したアイコンサイズ
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelMedium),
            Text(staffName, style: AppTextStyles.h6),
          ],
        ),
      ],
    );
  }
}
