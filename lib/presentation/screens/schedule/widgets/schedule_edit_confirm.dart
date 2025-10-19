import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/button_row.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';

class ScheduleEditConfirm extends StatelessWidget {
  final Event originalEvent;
  final String editedTitle;
  final TimeOfDay editedStartTime;
  final TimeOfDay editedEndTime;
  final DateTime editedDate;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const ScheduleEditConfirm({
    super.key,
    required this.originalEvent,
    required this.editedTitle,
    required this.editedStartTime,
    required this.editedEndTime,
    required this.editedDate,
    required this.onConfirm,
    required this.onBack,
  });

  // 曜日を取得
  String _getWeekday(DateTime date) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    return weekdays[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日（${_getWeekday(date)}）';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeRange(TimeOfDay start, TimeOfDay end) {
    return '${_formatTime(start)}~${_formatTime(end)}';
  }

  // 変更があったかどうかをチェック
  bool _hasChanges() {
    final originalTimeParts = originalEvent.time.split('~');
    if (originalTimeParts.length != 2) return true;

    final originalStartParts = originalTimeParts[0].split(':');
    final originalEndParts = originalTimeParts[1].split(':');

    final originalStartTime = TimeOfDay(
      hour: int.tryParse(originalStartParts[0]) ?? 0,
      minute: int.tryParse(originalStartParts[1]) ?? 0,
    );
    final originalEndTime = TimeOfDay(
      hour: int.tryParse(originalEndParts[0]) ?? 0,
      minute: int.tryParse(originalEndParts[1]) ?? 0,
    );

    return originalEvent.date != editedDate ||
        originalStartTime.hour != editedStartTime.hour ||
        originalStartTime.minute != editedStartTime.minute ||
        originalEndTime.hour != editedEndTime.hour ||
        originalEndTime.minute != editedEndTime.minute;
  }

  Widget _buildScheduleComparisonCard({required bool hasChanges}) {
    final originalTimeRange = originalEvent.time;
    final editedTimeRange = _formatTimeRange(editedStartTime, editedEndTime);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hasChanges ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: hasChanges
            ? Border.all(color: Colors.blue.shade200, width: 2)
            : Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 変更前
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '変更前',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: hasChanges ? textSecondary : textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(originalEvent.date),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: hasChanges ? textSecondary : textPrimary,
                    decoration: hasChanges ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  originalTimeRange,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: hasChanges ? textSecondary : textPrimary,
                    decoration: hasChanges ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),

          if (hasChanges) ...[
            const SizedBox(height: 16),
            // 矢印
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward, color: backgroundAccent, size: 24),
                ],
              ),
            ),
            // Center(
            //   child: Column(
            //     children: [
            //       Icon(Icons.arrow_downward, color: backgroundAccent, size: 24),
            //       Text(
            //         '変更',
            //         style: AppTextStyles.labelSmall.copyWith(
            //           color: backgroundAccent,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            // 変更後
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: backgroundAccent, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '変更後',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: backgroundAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(editedDate),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: backgroundAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    editedTimeRange,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: backgroundAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasChanges = _hasChanges();

    return Column(
      children: [
        // コンテンツ部分
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('予定変更の確認', style: AppTextStyles.h5),
              const SizedBox(height: 20),
              // 日時変更の比較表示
              _buildScheduleComparisonCard(hasChanges: hasChanges),
              const SizedBox(height: 20),

              if (hasChanges) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: backgroundAccent, size: 20),
                    const SizedBox(width: 8),
                    Text('上記の内容で予定変更をします。', style: AppTextStyles.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (!hasChanges) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '変更はありません。元の予定と同じ内容です。',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: onBack,
          primaryText: hasChanges ? '送信する' : null,
          onPrimaryPressed: hasChanges ? onConfirm : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
