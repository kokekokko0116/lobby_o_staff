import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'date_selection_widget.dart';
import 'additional_work.dart';
import 'completion_report_widget.dart';

/// 報告済みのレビュー内容を表示するウィジェット（読み取り専用）
class CompletedReviewDetailWidget extends StatelessWidget {
  const CompletedReviewDetailWidget({
    super.key,
    required this.schedule,
    this.modifiedDateTime,
    this.workStatus,
    this.additionalWorkText = '',
    this.reportStatus,
    this.reportText = '',
    this.submittedAt,
  });

  final ServiceSchedule schedule;
  final DateTime? modifiedDateTime;
  final WorkCompletionStatus? workStatus;
  final String additionalWorkText;
  final ReportStatus? reportStatus;
  final String reportText;
  final DateTime? submittedAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // タイトルと提出日時
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '報告内容',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (submittedAt != null)
              Text(
                '提出日時: ${_formatDateTime(submittedAt!)}',
                style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
              ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // スケジュール情報カード
                _buildSectionCard(
                  title: 'スケジュール情報',
                  child: Column(
                    children: [
                      _buildInfoRow('日付', _formatDate(schedule.dateTime)),
                      const SizedBox(height: 8),
                      _buildInfoRow('時間', _formatTime(schedule.dateTime)),
                      const SizedBox(height: 8),
                      _buildInfoRow('スタッフ', schedule.staffName),
                      const SizedBox(height: 8),
                      _buildInfoRow('最寄駅', schedule.nearestStation),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'ステータス',
                        schedule.status == 'regular' ? 'レギュラー' : 'トライアル',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 実施日時の変更（ある場合）
                if (modifiedDateTime != null) ...[
                  _buildSectionCard(
                    title: '変更後の実施日時',
                    backgroundColor: const Color(0xFFFFF3E0),
                    borderColor: const Color(0xFFFF9800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: const Color(0xFFE65100),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _formatDateTime(modifiedDateTime!),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: const Color(0xFFE65100),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'お客様の承諾済み',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 作業完了状況
                _buildSectionCard(
                  title: '作業完了状況',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusChip(_getWorkStatusText(workStatus)),
                      if (additionalWorkText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          '追加や不足の作業内容',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: backgroundSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            additionalWorkText,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 報告内容
                _buildSectionCard(
                  title: '報告内容',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusChip(_getReportStatusText(reportStatus)),
                      if (reportStatus == ReportStatus.hasReport &&
                          reportText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          '詳細内容',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: backgroundSecondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reportText,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? backgroundDefault,
        border: Border.all(
          color: borderColor ?? borderPrimary,
          width: borderColor != null ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: backgroundAccent),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: backgroundAccent,
          fontWeight: FontWeight.w600,
        ),
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
