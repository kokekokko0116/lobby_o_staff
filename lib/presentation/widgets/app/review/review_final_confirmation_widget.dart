import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'date_selection_widget.dart';
import 'additional_work.dart';
import 'completion_report_widget.dart';

class ReviewFinalConfirmationWidget extends StatelessWidget {
  const ReviewFinalConfirmationWidget({
    super.key,
    required this.schedule,
    this.modifiedDateTime,
    this.workStatus,
    this.additionalWorkText = '',
    this.reportStatus,
    this.reportText = '',
    required this.isConfirmed,
    required this.onConfirmationChanged,
  });

  final ServiceSchedule schedule;
  final DateTime? modifiedDateTime;
  final WorkCompletionStatus? workStatus;
  final String additionalWorkText;
  final ReportStatus? reportStatus;
  final String reportText;
  final bool isConfirmed;
  final Function(bool) onConfirmationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('以下をご確認の上、「送信」してください。', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 16),
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
                  // スケジュール情報
                  _buildSectionTitle('スケジュール情報'),
                  const SizedBox(height: 8),
                  _buildInfoItem('日付', _formatDate(schedule.dateTime)),
                  _buildInfoItem('時間', _formatTime(schedule.dateTime)),
                  _buildInfoItem('スタッフ', schedule.staffName),
                  _buildInfoItem('最寄駅', schedule.nearestStation),
                  _buildInfoItem(
                    'ステータス',
                    schedule.status == 'regular' ? 'レギュラー' : 'トライアル',
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 実施日時（変更がある場合）
                  if (modifiedDateTime != null) ...[
                    _buildSectionTitle('変更後の実施日時'),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      '変更後の日時',
                      _formatDateTime(modifiedDateTime!),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // 作業完了状況
                  _buildSectionTitle('作業完了状況'),
                  const SizedBox(height: 8),
                  _buildInfoItem('', _getWorkStatusText(workStatus)),

                  if (additionalWorkText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSectionTitle('追加や不足の作業内容', isSubtitle: true),
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
                        additionalWorkText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 報告内容
                  _buildSectionTitle('報告内容'),
                  const SizedBox(height: 8),
                  _buildInfoItem('', _getReportStatusText(reportStatus)),

                  if (reportStatus == ReportStatus.hasReport &&
                      reportText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSectionTitle('詳細内容', isSubtitle: true),
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
                        reportText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 承諾チェックボックス
        InkWell(
          onTap: () => onConfirmationChanged(!isConfirmed),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isConfirmed,
                  onChanged: (value) => onConfirmationChanged(value ?? false),
                  activeColor: backgroundAccent,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'お客様に変更の承諾を頂きました',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isConfirmed ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool isSubtitle = false}) {
    return Text(
      title,
      style: isSubtitle
          ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)
          : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    if (label.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(value, style: AppTextStyles.bodyMedium),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  String _getWorkStatusText(WorkCompletionStatus? status) {
    switch (status) {
      case WorkCompletionStatus.completed:
        return 'いつも通り問題なく予定作業が完了した';
      case WorkCompletionStatus.additionalWork:
        return '予定以上の追加作業を行なった';
      case WorkCompletionStatus.incomplete:
        return '予定作業の一部が終わらなかった';
      default:
        return '未選択';
    }
  }

  String _getReportStatusText(ReportStatus? status) {
    switch (status) {
      case ReportStatus.noIssue:
        return '特に気になることはなかった';
      case ReportStatus.hasReport:
        return '報告しておきたいことがあった';
      default:
        return '未選択';
    }
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
    return '$startTime ~ $endTimeStr';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}
