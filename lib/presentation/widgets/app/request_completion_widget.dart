import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';

class RequestCompletionWidget extends StatelessWidget {
  final String requestType;

  const RequestCompletionWidget({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('「$requestType」のリクエストを送信しました', style: AppTextStyles.h5),
        const SizedBox(height: 16),
        Text('担当者が内容を確認後に確定いたします。', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        Text('確定までしばらくお待ちください。', style: AppTextStyles.bodyLarge),
      ],
    );
  }
}
