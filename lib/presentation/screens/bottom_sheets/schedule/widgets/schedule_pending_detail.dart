import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../../components/buttons/button_row.dart';
import '../../../../components/buttons/secondary_button.dart';
import '../../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';

class SchedulePendingDetail extends StatelessWidget {
  final Event event;
  final VoidCallback onBack;

  const SchedulePendingDetail({
    super.key,
    required this.event,
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getPendingTypeText() {
    switch (event.pendingType) {
      case PendingType.add:
        return '追加';
      case PendingType.edit:
        return '変更';
      case PendingType.cancel:
        return 'キャンセル';
      default:
        return '処理';
    }
  }

  Color _getPendingTypeColor() {
    switch (event.pendingType) {
      case PendingType.add:
        return Colors.green;
      case PendingType.edit:
        return Colors.orange;
      case PendingType.cancel:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTimeDisplay() {
    switch (event.pendingType) {
      case PendingType.add:
        return _buildAddTimeDisplay();
      case PendingType.edit:
        return _buildEditTimeDisplay();
      case PendingType.cancel:
        return _buildCancelTimeDisplay();
      default:
        return Container();
    }
  }

  Widget _buildAddTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別バッジ
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('リクエスト内容', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(_formatDate(event.date), style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(event.time, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('変更内容', style: AppTextStyles.labelMedium),
          const SizedBox(height: 12),

          // 変更前
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('変更前', style: AppTextStyles.labelSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(
                        event.originalDate ?? event.date,
                      ), // 変更前の日付を表示
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      event.originalTime ?? '時間情報なし',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Center(
            child: Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          ),
          const SizedBox(height: 8),

          // 変更後
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '変更後',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(event.date), // 変更後の日付を表示
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      event.time,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('キャンセル対象', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(_formatDate(event.date), style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                event.time,
                style: AppTextStyles.bodyMedium, // 取り消し線を削除
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // コンテンツ部分
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 時間表示（リクエスト送信時刻とリクエスト種別を含む）
                _buildTimeDisplay(),
                const SizedBox(height: 20),

                // 注意事項
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundPrimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderPrimary),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: backgroundAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '担当者が内容を確認後に確定いたします。確定までしばらくお待ちください。',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ボタン部分
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonRow(
                reserveSecondarySpace: false,
                secondaryText: null,
                onSecondaryPressed: null,
                primaryText: '戻る',
                onPrimaryPressed: onBack,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
