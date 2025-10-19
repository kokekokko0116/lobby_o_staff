import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceConfirmationWidget extends StatefulWidget {
  const ServiceConfirmationWidget({
    super.key,
    required this.serviceDateTime,
    this.isConfirmed = false,
    this.onConfirmationChanged,
    this.onDateTimeChanged,
  });

  final DateTime serviceDateTime;
  final bool isConfirmed;
  final Function(bool)? onConfirmationChanged;
  final Function(DateTime)? onDateTimeChanged;

  @override
  State<ServiceConfirmationWidget> createState() =>
      _ServiceConfirmationWidgetState();
}

class _ServiceConfirmationWidgetState extends State<ServiceConfirmationWidget> {
  late DateTime _originalDateTime;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late int _startHour;
  late int _startMinute;
  late int _endHour;
  late int _endMinute;
  late bool _customerApprovalConfirmed;

  @override
  void initState() {
    super.initState();
    _originalDateTime = widget.serviceDateTime;
    _selectedYear = widget.serviceDateTime.year;
    _selectedMonth = widget.serviceDateTime.month;
    _selectedDay = widget.serviceDateTime.day;
    _startHour = widget.serviceDateTime.hour;
    _startMinute = widget.serviceDateTime.minute;

    // 終了時間は開始時間+2時間
    final endTime = widget.serviceDateTime.add(const Duration(hours: 2));
    _endHour = endTime.hour;
    _endMinute = endTime.minute;

    _customerApprovalConfirmed = false;

    // 初期状態を親に通知
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  DateTime get _currentDateTime => DateTime(
    _selectedYear,
    _selectedMonth,
    _selectedDay,
    _startHour,
    _startMinute,
  );

  bool get _hasDateTimeChanged =>
      _currentDateTime.year != _originalDateTime.year ||
      _currentDateTime.month != _originalDateTime.month ||
      _currentDateTime.day != _originalDateTime.day ||
      _startHour != _originalDateTime.hour ||
      _startMinute != _originalDateTime.minute ||
      _endHour != (_originalDateTime.hour + 2) % 24 ||
      _endMinute != _originalDateTime.minute;

  bool get _canProceed => !_hasDateTimeChanged || _customerApprovalConfirmed;

  void _notifyParent() {
    widget.onConfirmationChanged?.call(_canProceed);
    if (_hasDateTimeChanged) {
      widget.onDateTimeChanged?.call(_currentDateTime);
    }
  }

  // 指定された年月の最大日数を取得
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // 日付ドロップダウン選択ウィジェット
  Widget _buildDateDropdownSelector() {
    final maxDays = _getDaysInMonth(_selectedYear, _selectedMonth);

    // 選択中の日が有効範囲外の場合、最大日数に調整
    if (_selectedDay > maxDays) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedDay = maxDays;
        });
        _notifyParent();
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: borderPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 年
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedYear,
                isExpanded: true,
                items: List.generate(3, (i) => DateTime.now().year - 1 + i)
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(
                          '${year}年',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (year) {
                  setState(() {
                    _selectedYear = year!;
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          // 月
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedMonth,
                isExpanded: true,
                items: List.generate(12, (i) => i + 1)
                    .map(
                      (month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          '${month}月',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (month) {
                  setState(() {
                    _selectedMonth = month!;
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          // 日
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedDay > maxDays ? maxDays : _selectedDay,
                isExpanded: true,
                items: List.generate(maxDays, (i) => i + 1)
                    .map(
                      (day) => DropdownMenuItem(
                        value: day,
                        child: Text(
                          '${day}日',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (day) {
                  setState(() {
                    _selectedDay = day!;
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 時間選択ウィジェット
  Widget _buildSimpleTimeSelector({
    required String label,
    required int hour,
    required int minute,
    required Function(int hour, int minute) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: borderPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // 時間選択（9時から19時まで）
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
              const SizedBox(width: 4),
              // 分選択
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('利用日時に変更がなかったか確認してください。', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 24),
        _buildDateTimeEditCard(),
        const SizedBox(height: 24),

        if (_hasDateTimeChanged) ...[
          _buildChangedNotice(),
          const SizedBox(height: 16),
          _buildCustomerApprovalCheckbox(),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildDateTimeEditCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: _hasDateTimeChanged
              ? const Color(0xFFFF9800)
              : const Color(0xFFE0E0E0),
          width: _hasDateTimeChanged ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: backgroundDefault,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 利用日
          Text(
            '利用日',
            style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
          ),
          const SizedBox(height: 8),
          _buildDateDropdownSelector(),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

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
                        if (_endHour > 24) {
                          _endHour = 24;
                          _endMinute = 0;
                        } else {
                          _endMinute = minute;
                        }
                      }
                    });
                    _notifyParent();
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
                    _notifyParent();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangedNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: const Color(0xFFE65100), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '利用日時が変更されています。お客様の承諾を得た上で続行してください。',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFFE65100),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerApprovalCheckbox() {
    return InkWell(
      onTap: () {
        setState(() {
          _customerApprovalConfirmed = !_customerApprovalConfirmed;
        });
        _notifyParent();
      },
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _customerApprovalConfirmed,
              onChanged: (value) {
                setState(() {
                  _customerApprovalConfirmed = value ?? false;
                });
                _notifyParent();
              },
              activeColor: backgroundAccent,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'お客様に変更の承諾を頂きました。',
              style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
