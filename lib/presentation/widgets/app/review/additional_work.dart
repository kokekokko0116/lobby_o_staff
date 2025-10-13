import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'date_selection_widget.dart';

enum WorkCompletionStatus {
  completed, // いつも通り問題なく予定作業が完了した
  additionalWork, // 予定以上の追加作業を行なった
  incomplete, // 予定作業の一部が終わらなかった
}

class AdditionalWork extends StatefulWidget {
  const AdditionalWork({
    super.key,
    required this.schedule,
    this.selectedStatus,
    this.additionalWorkText = '',
    this.onStatusChanged,
    this.onAdditionalWorkChanged,
  });

  final ServiceSchedule schedule;
  final WorkCompletionStatus? selectedStatus;
  final String additionalWorkText;
  final Function(WorkCompletionStatus?)? onStatusChanged;
  final Function(String)? onAdditionalWorkChanged;

  @override
  State<AdditionalWork> createState() => _AdditionalWorkState();
}

class _AdditionalWorkState extends State<AdditionalWork> {
  WorkCompletionStatus? _selectedStatus;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
    _textController = TextEditingController(text: widget.additionalWorkText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScheduleInfo(),

        const SizedBox(height: 16),
        _buildCheckboxes(),

        const SizedBox(height: 16),
        Text(
          '追加や不足の作業',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildAdditionalWorkTextField()),
      ],
    );
  }

  Widget _buildScheduleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日付
        Text(
          _formatDate(widget.schedule.dateTime),
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 2),
        // 時間
        Text(
          _formatTime(widget.schedule.dateTime),
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 2),
        // 名前と最寄駅
        Text(
          '${widget.schedule.staffName}　@${widget.schedule.nearestStation}',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 2),
        // ステータス
        Text(
          widget.schedule.status == 'regular' ? 'レギュラー' : 'トライアル',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      children: [
        _buildCheckboxTile(
          value: _selectedStatus == WorkCompletionStatus.completed,
          title: 'いつも通り問題なく予定作業が完了した',
          onChanged: (value) {
            setState(() {
              _selectedStatus = value! ? WorkCompletionStatus.completed : null;
            });
            widget.onStatusChanged?.call(_selectedStatus);
          },
        ),
        const SizedBox(height: 8),
        _buildCheckboxTile(
          value: _selectedStatus == WorkCompletionStatus.additionalWork,
          title: '予定以上の追加作業を行なった',
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!
                  ? WorkCompletionStatus.additionalWork
                  : null;
            });
            widget.onStatusChanged?.call(_selectedStatus);
          },
        ),
        const SizedBox(height: 8),
        _buildCheckboxTile(
          value: _selectedStatus == WorkCompletionStatus.incomplete,
          title: '予定作業の一部が終わらなかった',
          onChanged: (value) {
            setState(() {
              _selectedStatus = value! ? WorkCompletionStatus.incomplete : null;
            });
            widget.onStatusChanged?.call(_selectedStatus);
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required String title,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
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
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalWorkTextField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
        color: backgroundDefault,
      ),
      child: TextField(
        controller: _textController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        onChanged: (value) {
          widget.onAdditionalWorkChanged?.call(value);
        },
        decoration: InputDecoration(
          hintText: '追加作業や未完了作業の内容を入力してください...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[dateTime.weekday - 1];
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日（$weekday）';
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
    return '$startTime ~ $endTimeStr';
  }
}
