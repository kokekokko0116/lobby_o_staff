import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../components/buttons/tile_button.dart';
import '../../../core/constants/app_images.dart';

enum EventStatus { completed, active, pending }

class Event {
  final String title;
  final String time;
  final EventStatus status;

  Event({required this.title, required this.time, required this.status});
}

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 新しい予定データ構造
  final Map<DateTime, List<Event>> _events = {
    DateTime(2025, 9, 25): [
      Event(title: '会議', time: '10:00~12:00', status: EventStatus.active),
      Event(
        title: 'ランチミーティング',
        time: '12:30~13:30',
        status: EventStatus.pending,
      ),
    ],
    DateTime(2025, 9, 26): [
      Event(
        title: 'プレゼンテーション',
        time: '14:00~15:00',
        status: EventStatus.completed,
      ),
    ],
    DateTime(2025, 9, 28): [
      Event(title: '病院', time: '09:00~10:00', status: EventStatus.completed),
      Event(title: '買い物', time: '15:00~16:00', status: EventStatus.active),
      Event(title: '映画', time: '19:00~21:00', status: EventStatus.pending),
    ],
    DateTime(2025, 10, 1): [
      Event(
        title: '誕生日パーティー',
        time: '18:00~22:00',
        status: EventStatus.pending,
      ),
    ],
    DateTime(2025, 10, 5): [
      Event(title: '出張', time: '08:00~18:00', status: EventStatus.active),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // その日の予定を取得する関数
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // ステータスに応じた色を取得
  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.completed:
        return Colors.grey;
      case EventStatus.active:
        return Colors.orange;
      case EventStatus.pending:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: Column(
        children: [
          // カレンダー部分
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },

              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },

              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },

              // スタイルの設定
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                selectedDecoration: BoxDecoration(
                  color: backgroundAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(shape: BoxShape.circle),
                todayTextStyle: AppTextStyles.bodyLarge,
                weekendTextStyle: AppTextStyles.bodyLarge,
                holidayTextStyle: AppTextStyles.bodyLarge,
                defaultTextStyle: AppTextStyles.bodyLarge,
              ),

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (date, locale) {
                  return '${date.year}年${date.month}月';
                },
                titleTextStyle: AppTextStyles.h6,
                leftChevronIcon: Icon(Icons.chevron_left, color: textPrimary),
                rightChevronIcon: Icon(Icons.chevron_right, color: textPrimary),
              ),

              // カスタムマーカー
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.take(3).map((event) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 0.5),
                            decoration: BoxDecoration(
                              color: _getStatusColor(event.status),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),

          // 選択された日の予定表示
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedDay != null) ...[
                  // ヘッダー部分
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日の予定',
                        style: AppTextStyles.h6,
                      ),
                      IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.add, color: textPrimary),
                        tooltip: '予定を追加',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildEventsList(_getEventsForDay(_selectedDay!)),
                  ),
                ] else ...[
                  Center(
                    child: Text('日付を選択してください', style: AppTextStyles.bodyMedium),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Event> events) {
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
              color: event.status == EventStatus.completed
                  ? Colors.grey
                  : Colors.grey,
            ),
            onTap: () {
              print('予定をタップ: ${event.title} (${event.time})');
            },
          ),
        );
      },
    );
  }
}
