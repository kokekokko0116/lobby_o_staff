import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceConfirmationWidget extends StatefulWidget {
  const ServiceConfirmationWidget({
    super.key,
    required this.serviceDateTime,
    this.isConfirmed = false,
    this.onConfirmationChanged,
  });

  final DateTime serviceDateTime;
  final bool isConfirmed;
  final Function(bool)? onConfirmationChanged;

  @override
  State<ServiceConfirmationWidget> createState() =>
      _ServiceConfirmationWidgetState();
}

class _ServiceConfirmationWidgetState extends State<ServiceConfirmationWidget> {
  late bool _isConfirmed;

  @override
  void initState() {
    super.initState();
    _isConfirmed = widget.isConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('以下の日時でサービスを実施しました。', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 24),
        _buildDateTimeCard(),
        const SizedBox(height: 24),
        _buildConfirmationCheckbox(),
        const SizedBox(height: 32),

        _buildNoticeSection(),
      ],
    );
  }

  Widget _buildDateTimeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
        color: backgroundDefault,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(widget.serviceDateTime),
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(widget.serviceDateTime),
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCheckbox() {
    return InkWell(
      onTap: () {
        setState(() {
          _isConfirmed = !_isConfirmed;
        });
        widget.onConfirmationChanged?.call(_isConfirmed);
      },
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _isConfirmed,
              onChanged: (value) {
                setState(() {
                  _isConfirmed = value ?? false;
                });
                widget.onConfirmationChanged?.call(_isConfirmed);
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
              '上記の通りサービスを利用しました',
              style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE69C)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber, color: const Color(0xFF856404), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '上記が実際とは異なる場合はこちらで中断して会社までご連絡ください',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF856404),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[dateTime.weekday - 1];
    return '${dateTime.year}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日（$weekday）';
  }

  String _formatTime(DateTime dateTime) {
    final startTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final endTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour + 2,
      dateTime.minute,
    );
    final endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startTime~$endTimeStr';
  }
}
