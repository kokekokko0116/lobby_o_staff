import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/button_row.dart';
import 'schedule_calendar.dart'; // 追加

class ScheduleAddForm extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
  )
  onSubmit;
  final VoidCallback onCancel;

  const ScheduleAddForm({
    super.key,
    required this.selectedDate,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<ScheduleAddForm> createState() => _ScheduleAddFormState();
}

class _ScheduleAddFormState extends State<ScheduleAddForm> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();

  // 時間選択用の値（9時から開始、1時間の予定）
  int _startHour = 9;
  int _startMinute = 0;
  int _endHour = 10;
  int _endMinute = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _focusedDay = _selectedDate ?? DateTime.now();
  }

  TimeOfDay get _startTime => TimeOfDay(hour: _startHour, minute: _startMinute);
  TimeOfDay get _endTime => TimeOfDay(hour: _endHour, minute: _endMinute);

  bool get _canSubmit {
    return _selectedDate != null;
  }

  // 簡単な時間選択ウィジェット
  Widget _buildSimpleTimeSelector({
    required String label,
    required int hour,
    required int minute,
    required Function(int hour, int minute) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: borderPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 時間選択（ドロップダウン）- 6時から24時まで
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: hour,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(value, minute);
                      }
                    },
                    items: List.generate(19, (index) {
                      final hourValue = index + 6; // 6時から24時まで
                      return DropdownMenuItem(
                        value: hourValue,
                        child: Text(
                          '${hourValue.toString().padLeft(2, '0')}時',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 分選択（ドロップダウン）- 0分と30分のみ
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: minute,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(hour, value);
                      }
                    },
                    items: [0, 30].map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text(
                          '${minutes.toString().padLeft(2, '0')}分',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 日付選択カレンダー（ScheduleCalendarを使用）
                Text('日付を選択', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                ScheduleCalendar(
                  calendarFormat: CalendarFormat.month,
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDate,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  showMarkers: false, // マーカーを非表示
                  firstDay: DateTime.now(), // 今日以降のみ選択可能
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                ),
                const SizedBox(height: 24),

                // 時間選択
                Row(
                  children: [
                    Expanded(
                      child: _buildSimpleTimeSelector(
                        label: '開始時間',
                        hour: _startHour,
                        minute: _startMinute,
                        onChanged: (hour, minute) {
                          setState(() {
                            _startHour = hour;
                            _startMinute = minute;

                            // 終了時間を自動調整（最低1時間後）
                            if (_endHour <= hour ||
                                (_endHour == hour && _endMinute <= minute)) {
                              _endHour = hour + 1;
                              if (_endHour > 23) {
                                _endHour = 23;
                                _endMinute = 59;
                              } else {
                                _endMinute = minute;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSimpleTimeSelector(
                        label: '終了時間',
                        hour: _endHour,
                        minute: _endMinute,
                        onChanged: (hour, minute) {
                          setState(() {
                            _endHour = hour;
                            _endMinute = minute;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ボタン部分（固定）
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonRow(
                reserveSecondarySpace: false,
                secondaryText: 'キャンセル',
                onSecondaryPressed: widget.onCancel,
                primaryText: '追加する',
                onPrimaryPressed: _canSubmit
                    ? () {
                        widget.onSubmit(
                          '', // タイトルは空文字
                          _startTime,
                          _endTime,
                          _selectedDate!,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
