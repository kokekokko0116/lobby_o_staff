import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';

enum ScheduleAction { edit, cancel }

class ScheduleEventDetail extends StatefulWidget {
  final Event event;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onBack;

  const ScheduleEventDetail({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onCancel,
    required this.onBack,
  });

  @override
  State<ScheduleEventDetail> createState() => _ScheduleEventDetailState();
}

class _ScheduleEventDetailState extends State<ScheduleEventDetail> {
  ScheduleAction? _selectedAction;

  // ステータスに応じた色を取得
  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.completed:
        return textDisabled;
      case EventStatus.active:
        return backgroundAccent;
      case EventStatus.pending:
        return Colors.red;
    }
  }

  // ステータスに応じたテキストを取得
  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.completed:
        return '完了済み';
      case EventStatus.active:
        return 'アクティブ';
      case EventStatus.pending:
        return '調整中';
    }
  }

  // 曜日を取得
  String _getWeekday(DateTime date) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    return weekdays[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日（${_getWeekday(date)}）';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.event.status);
    final canEdit = widget.event.status != EventStatus.completed;

    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StaffInfoWidget(
                        staffName: widget.event.staffName,
                        staffImagePath: widget.event.staffImagePath,
                      ),
                      const SizedBox(height: 20),

                      // 日付
                      Text('日付', style: AppTextStyles.labelMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(widget.event.date),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 時間
                      Text('時間', style: AppTextStyles.labelMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.event.time,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 注意事項（完了済みの場合）
              if (widget.event.status == EventStatus.completed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '完了済みの予定は変更・キャンセルできません',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Text('この予定を変更・キャンセルしますか？', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 16),

              // ラジオボタン選択
              Column(
                children: [
                  RadioListTile<ScheduleAction>(
                    title: Text('変更する', style: AppTextStyles.bodyMedium),
                    value: ScheduleAction.edit,
                    groupValue: _selectedAction,
                    onChanged: (ScheduleAction? value) {
                      setState(() {
                        _selectedAction = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<ScheduleAction>(
                    title: Text('キャンセルする', style: AppTextStyles.bodyMedium),
                    value: ScheduleAction.cancel,
                    groupValue: _selectedAction,
                    onChanged: (ScheduleAction? value) {
                      setState(() {
                        _selectedAction = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),

        // ボタン部分
        canEdit
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 戻る・次へボタン
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: '戻る',
                          onPressed: widget.onBack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrimaryButton(
                          text: '次へ',
                          onPressed: _selectedAction != null
                              ? () {
                                  if (_selectedAction == ScheduleAction.edit) {
                                    widget.onEdit();
                                  } else if (_selectedAction ==
                                      ScheduleAction.cancel) {
                                    widget.onCancel();
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : SecondaryButton(text: '戻る', onPressed: widget.onBack),
        const SizedBox(height: 16),
      ],
    );
  }
}
