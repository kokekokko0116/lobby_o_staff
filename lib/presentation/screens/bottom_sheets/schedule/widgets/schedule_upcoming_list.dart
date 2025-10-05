import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../models/schedule_event.dart';

class ScheduleUpcomingList extends StatelessWidget {
  final List<Event> events;
  final Function(Event)? onEventTap;

  const ScheduleUpcomingList({
    super.key,
    required this.events,
    this.onEventTap,
  });

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

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('今後の予定はありません', style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final statusColor = _getStatusColor(event.status);

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
            title: Text(event.title, style: AppTextStyles.bodyMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.time, style: AppTextStyles.labelMedium),
                Text(
                  '${event.date.month}月${event.date.day}日',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
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
