import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../models/schedule_event.dart';

class ScheduleEventList extends StatelessWidget {
  final List<Event> events;
  final Function(Event)? onEventTap;

  const ScheduleEventList({super.key, required this.events, this.onEventTap});

  // ステータスに応じた色を取得
  Color _getStatusColor(Event event) {
    switch (event.status) {
      case EventStatus.completed:
        return textDisabled;
      case EventStatus.active:
        return backgroundAccent;
      case EventStatus.pending:
        // ペンディングタイプに応じて色を変更
        switch (event.pendingType) {
          case PendingType.add:
            return Colors.green; // 追加リクエスト
          case PendingType.edit:
            return Colors.orange; // 編集
          case PendingType.cancel:
            return Colors.red; // 削除要請
          case null:
            return Colors.red; // デフォルトは赤
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('この日に予定はありません', style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final statusColor = _getStatusColor(event); // ← ここを修正

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              event.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: event.status == EventStatus.completed
                    ? textDisabled
                    : null,
              ),
            ),
            subtitle: Text(
              event.time,
              style: AppTextStyles.labelMedium.copyWith(
                color: event.status == EventStatus.completed
                    ? textDisabled
                    : null,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: event.status == EventStatus.completed
                ? null
                : () => onEventTap?.call(event),
          ),
        );
      },
    );
  }
}
