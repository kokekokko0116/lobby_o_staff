import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceSchedule {
  final DateTime dateTime;
  final String staffName;
  final String nearestStation;
  final String status; // 'regular' or 'trial'
  final bool isCompleted;

  ServiceSchedule({
    required this.dateTime,
    required this.staffName,
    required this.nearestStation,
    required this.status,
    required this.isCompleted,
  });
}

enum ScheduleFilter {
  all, // 全て
  completed, // 報告済み
  uncompleted, // 未報告
}

class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget({
    super.key,
    required this.serviceSchedules,
    this.selectedSchedule,
    this.onScheduleSelected,
  });

  final List<ServiceSchedule> serviceSchedules;
  final ServiceSchedule? selectedSchedule;
  final Function(ServiceSchedule)? onScheduleSelected;

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  ScheduleFilter _currentFilter = ScheduleFilter.all;

  List<ServiceSchedule> get _filteredSchedules {
    switch (_currentFilter) {
      case ScheduleFilter.all:
        return widget.serviceSchedules;
      case ScheduleFilter.completed:
        return widget.serviceSchedules
            .where((schedule) => schedule.isCompleted)
            .toList();
      case ScheduleFilter.uncompleted:
        return widget.serviceSchedules
            .where((schedule) => !schedule.isCompleted)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uncompletedCount = widget.serviceSchedules
        .where((schedule) => !schedule.isCompleted)
        .length;
    final completedCount = widget.serviceSchedules
        .where((schedule) => schedule.isCompleted)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('確認・報告する予定をタップしてください。', style: AppTextStyles.bodyLarge),
        // const SizedBox(height: 12),
        // Row(
        //   children: [
        //     Text('未報告', style: AppTextStyles.bodySmall),
        //     const SizedBox(width: 4),
        //     Text('$uncompletedCount件', style: AppTextStyles.bodySmall),
        //   ],
        // ),
        const SizedBox(height: 16),

        // フィルタータブ
        _buildFilterTabs(completedCount, uncompletedCount),

        const SizedBox(height: 16),
        Expanded(
          child: _filteredSchedules.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _filteredSchedules.length,
                  itemBuilder: (context, index) {
                    final schedule = _filteredSchedules[index];
                    final isSelected = widget.selectedSchedule == schedule;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => widget.onScheduleSelected?.call(schedule),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: schedule.isCompleted
                                  ? const Color(0xFF4CAF50) // 緑（完了）
                                  : const Color(0xFFD64545), // 赤（未完了）
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: backgroundDefault,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatDate(schedule.dateTime),
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTime(schedule.dateTime),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${schedule.staffName}　@${schedule.nearestStation}',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      schedule.status == 'regular'
                                          ? 'ステータス（レギュラー）'
                                          : 'ステータス（トライアル）',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                schedule.isCompleted
                                    ? Icons
                                          .check_circle // チェックマーク（完了）
                                    : Icons.radio_button_unchecked, // 空の円（未完了）
                                color: schedule.isCompleted
                                    ? const Color(0xFF4CAF50) // 緑
                                    : const Color(0xFF9E9E9E), // グレー
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(int completedCount, int uncompletedCount) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterTab(
            filter: ScheduleFilter.all,
            label: '全て',
            count: widget.serviceSchedules.length,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterTab(
            filter: ScheduleFilter.completed,
            label: '報告済み',
            count: completedCount,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterTab(
            filter: ScheduleFilter.uncompleted,
            label: '未報告',
            count: uncompletedCount,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab({
    required ScheduleFilter filter,
    required String label,
    required int count,
  }) {
    final isSelected = _currentFilter == filter;

    // フィルターの種類に応じた色を設定
    Color getBackgroundColor() {
      if (isSelected) {
        switch (filter) {
          case ScheduleFilter.completed:
            return const Color(0xFF4CAF50); // 緑
          case ScheduleFilter.uncompleted:
            return const Color(0xFFD64545); // 赤
          case ScheduleFilter.all:
            return backgroundAccent; // デフォルトのアクセントカラー
        }
      } else {
        return backgroundSecondary;
      }
    }

    Color getBorderColor() {
      if (isSelected) {
        switch (filter) {
          case ScheduleFilter.completed:
            return const Color(0xFF4CAF50); // 緑
          case ScheduleFilter.uncompleted:
            return const Color(0xFFD64545); // 赤
          case ScheduleFilter.all:
            return backgroundAccent;
        }
      } else {
        return borderPrimary;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: getBorderColor(),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$count件',
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Colors.white : textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: textSecondary),
          const SizedBox(height: 16),
          Text(
            '該当する予定がありません',
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
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
