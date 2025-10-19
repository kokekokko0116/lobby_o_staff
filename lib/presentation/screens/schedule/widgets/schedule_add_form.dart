import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/button_row.dart';
import 'schedule_calendar.dart';
import '../../bottom_sheets/customer_list.dart'; // 追加

class ScheduleAddForm extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    CustomerItem? customer, // 追加
    bool isCustomerRequest, // 追加
  )
  onSubmit;
  final VoidCallback onCancel;
  final List<CustomerItem> customers; // 追加：お客様リストを外部から受け取る

  const ScheduleAddForm({
    super.key,
    required this.selectedDate,
    required this.onSubmit,
    required this.onCancel,
    required this.customers, // 追加
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

  // 追加：お客様選択とチェックボックスの状態
  CustomerItem? _selectedCustomer;
  bool _isCustomerRequest = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _focusedDay = _selectedDate ?? DateTime.now();
  }

  TimeOfDay get _startTime => TimeOfDay(hour: _startHour, minute: _startMinute);
  TimeOfDay get _endTime => TimeOfDay(hour: _endHour, minute: _endMinute);

  bool get _canSubmit {
    // 日付とお客様が選択されていて、かつチェックボックスがtrueであることが必須
    return _selectedDate != null &&
        _selectedCustomer != null &&
        _isCustomerRequest;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // お客様選択（追加）
                Text('お客様を選択', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderPrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CustomerItem>(
                      value: _selectedCustomer,
                      isExpanded: true,
                      hint: Text(
                        'お客様を選択してください',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textSecondary,
                        ),
                      ),
                      onChanged: (customer) {
                        setState(() {
                          _selectedCustomer = customer;
                        });
                      },
                      items: widget.customers.map((customer) {
                        return DropdownMenuItem<CustomerItem>(
                          value: customer,
                          child: Text(
                            '${customer.name}様（${customer.nearestStation}）',
                            style: AppTextStyles.bodyMedium,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 日付選択カレンダー（既存）
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
                const SizedBox(height: 16),

                // 時間選択（既存）
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
                const SizedBox(height: 16),

                // チェックボックスのセクション（262行目付近）
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCustomerRequest = !_isCustomerRequest;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isCustomerRequest,
                        onChanged: (value) {
                          setState(() {
                            _isCustomerRequest = value ?? false;
                          });
                        },
                        activeColor: backgroundAccent,
                      ),
                      Expanded(
                        child: Text(
                          'お客様からのご依頼に基づきサービスを追加します。',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ボタン部分（既存）
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
                    _selectedCustomer, // 追加
                    _isCustomerRequest, // 追加
                  );
                }
              : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
