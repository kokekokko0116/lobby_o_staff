import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../staff_info_widget.dart';

class CompletionReportWidget extends StatelessWidget {
  const CompletionReportWidget({
    super.key,
    required this.selectedDateTime,
    this.staffName = '田中太郎',
    this.staffImagePath = 'assets/images/avatars/staff_sample.png',
    this.reportContent,
  });

  final DateTime selectedDateTime;
  final String staffName;
  final String staffImagePath;
  final String? reportContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaffInfoWidget(staffName: staffName, staffImagePath: staffImagePath),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('完了報告書', style: AppTextStyles.h6)),
                const SizedBox(height: 24),
                Text('作成日', style: AppTextStyles.labelMedium),
                const SizedBox(height: 4),
                Text(
                  _formatDateTimeSimple(selectedDateTime),
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text('報告内容', style: AppTextStyles.labelMedium),
                const SizedBox(height: 4),
                Text(
                  reportContent ??
                      'お疲れ様でした。本日のサービスが完了いたしました。リビング、キッチン、洗面所、トイレ、玄関周りの清掃を丁寧に行わせていただき、簡易的な整理整頓も実施いたしました。何かご不明な点やご要望がございましたら、お気軽にお声かけください。',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTimeSimple(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
