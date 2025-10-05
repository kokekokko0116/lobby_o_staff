import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../../components/buttons/button_row.dart';
import '../../../../components/buttons/primary_button.dart';
import '../../../../components/buttons/secondary_button.dart';
import '../../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';

class ScheduleCancelConfirm extends StatelessWidget {
  final Event event;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const ScheduleCancelConfirm({
    super.key,
    required this.event,
    required this.onConfirm,
    required this.onBack,
  });

  // 曜日を取得
  String _getWeekday(DateTime date) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    return weekdays[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日（${_getWeekday(date)}）';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // コンテンツ部分
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 48,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '以下の内容を',
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '【キャンセルする】',
                      style: AppTextStyles.h6.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'でよろしいですか？',
                      style: AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 予定詳細カード
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 担当者情報
                      // 日付
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(event.date),
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 時間
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(event.time, style: AppTextStyles.bodyMedium),
                        ],
                      ),

                      const SizedBox(height: 16),

                      StaffInfoWidget(
                        staffName: event.staffName,
                        staffImagePath: event.staffImagePath,
                        size: 40, // 少し小さく
                      ),
                      // const SizedBox(height: 16),

                      // 予定内容
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.cleaning_services,
                      //       size: 20,
                      //       color: textSecondary,
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       event.title,
                      //       style: AppTextStyles.bodyMedium.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ボタン部分
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonRow(
                reserveSecondarySpace: false,
                secondaryText: '戻る',
                onSecondaryPressed: onBack,
                primaryText: '送信する',
                onPrimaryPressed: onConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
