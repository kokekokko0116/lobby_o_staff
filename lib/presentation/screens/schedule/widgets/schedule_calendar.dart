import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../models/schedule_event.dart';

class ScheduleCalendar extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<Event> Function(DateTime)? eventLoader; // オプションに変更
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat)? onFormatChanged; // オプションに変更
  final Function(DateTime) onPageChanged;
  final bool showMarkers; // マーカー表示のフラグを追加
  final DateTime? firstDay; // 開始日をカスタマイズ可能に
  final DateTime? lastDay; // 終了日をカスタマイズ可能に

  const ScheduleCalendar({
    super.key,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    this.eventLoader, // requiredを外す
    required this.onDaySelected,
    this.onFormatChanged, // requiredを外す
    required this.onPageChanged,
    this.showMarkers = true, // デフォルトはtrue
    this.firstDay,
    this.lastDay,
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
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      decoration: BoxDecoration(
        color: backgroundSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderPrimary),
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar<Event>(
        firstDay: firstDay ?? DateTime.utc(2020, 1, 1),
        lastDay: lastDay ?? DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        eventLoader: eventLoader ?? (_) => [], // nullの場合は空リストを返す
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged ?? (_) {}, // nullの場合は何もしない
        onPageChanged: onPageChanged,

        // 曜日のスタイル設定を追加
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),

        // スタイルの設定
        calendarStyle: CalendarStyle(
          // サイズの設定
          outsideDaysVisible: true,
          selectedDecoration: BoxDecoration(
            color: backgroundAccent,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.bodyLarge.copyWith(
            color: textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
          todayDecoration: BoxDecoration(shape: BoxShape.circle),
          todayTextStyle: AppTextStyles.bodyLarge,
          weekendTextStyle: AppTextStyles.bodyLarge,
          holidayTextStyle: AppTextStyles.bodyLarge,
          defaultTextStyle: AppTextStyles.bodyLarge,
          markersMaxCount: 0, // デフォルトマーカーは使用しない
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

        // カスタムビルダー
        calendarBuilders: CalendarBuilders(
          // 曜日ヘッダーのカスタマイズ（漢字表記）
          dowBuilder: (context, day) {
            final weekDays = ['日', '月', '火', '水', '木', '金', '土'];
            final weekDay = weekDays[day.weekday % 7];

            return Center(
              child: Text(
                weekDay,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },

          // マーカービルダーを条件付きで追加
          markerBuilder: showMarkers
              ? (context, day, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: events.take(3).map((event) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
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
                }
              : null,
          defaultBuilder: (context, day, focusedDay) {
            final isSelected = isSameDay(selectedDay, day);

            if (isSelected) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: borderInfo, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('${day.day}', style: AppTextStyles.bodyLarge),
                ),
              );
            }
            return null;
          },
          outsideBuilder: (context, day, focusedDay) {
            final isSelected = isSameDay(selectedDay, day);

            if (isSelected) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: borderInfo, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey),
                  ),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
