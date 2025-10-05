import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ReviewFinalConfirmationWidget extends StatelessWidget {
  const ReviewFinalConfirmationWidget({
    super.key,
    required this.selectedDateTime,
    required this.rating,
    required this.comment,
  });

  final DateTime selectedDateTime;
  final int rating;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('以下をご確認の上「送信」してください。', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: borderPrimary),
              borderRadius: BorderRadius.circular(8),
              color: backgroundDefault,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConfirmationItem(
                    '実施日時',
                    _formatDateTime(selectedDateTime),
                  ),
                  _buildRatingConfirmationItem(),
                  const SizedBox(height: 16),
                  Text('コメント', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundSecondary,
                      border: Border.all(color: borderPrimary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      comment.isEmpty ? 'コメントなし' : comment,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: comment.isEmpty ? textSecondary : textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: AppTextStyles.bodySmall),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildRatingConfirmationItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('評価', style: AppTextStyles.bodySmall),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating ? backgroundAccent : Colors.grey[400],
                  size: 20,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[dateTime.weekday - 1];
    return '${dateTime.year}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日（$weekday）';
  }

  String _formatTime(DateTime dateTime) {
    final startTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final endTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour + 2,
      dateTime.minute,
    );
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startTime~$endTimeStr';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}
