import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/button_row.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';

// キャンセル理由のenum（追加）
enum CancelReason {
  customerRequest, // お客様都合
  staffRequest, // スタッフ都合（お客様の承諾済み）
}

class ScheduleCancelConfirm extends StatefulWidget {
  final Event event;
  final Function(CancelReason reason) onConfirm; // 修正：理由を受け取る
  final VoidCallback onBack;

  const ScheduleCancelConfirm({
    super.key,
    required this.event,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  State<ScheduleCancelConfirm> createState() => _ScheduleCancelConfirmState();
}

class _ScheduleCancelConfirmState extends State<ScheduleCancelConfirm> {
  CancelReason? _selectedReason; // 選択された理由

  // 曜日を取得
  String _getWeekday(DateTime date) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    return weekdays[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日（${_getWeekday(date)}）';
  }

  // 送信可能かどうか
  bool get _canSubmit => _selectedReason != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // コンテンツ部分
        Expanded(
          child: SingleChildScrollView(
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
                const SizedBox(height: 16),

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
                              _formatDate(widget.event.date),
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
                            Text(
                              widget.event.time,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        StaffInfoWidget(
                          staffName: widget.event.staffName,
                          staffImagePath: widget.event.staffImagePath,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ラジオボタンセクション（追加）
                Column(
                  children: [
                    // お客様都合
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedReason = CancelReason.customerRequest;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<CancelReason>(
                            value: CancelReason.customerRequest,
                            groupValue: _selectedReason,
                            onChanged: (value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                            activeColor: backgroundAccent,
                          ),
                          Expanded(
                            child: Text(
                              'お客様都合',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // スタッフ都合
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedReason = CancelReason.staffRequest;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<CancelReason>(
                            value: CancelReason.staffRequest,
                            groupValue: _selectedReason,
                            onChanged: (value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                            activeColor: backgroundAccent,
                          ),
                          Expanded(
                            child: Text(
                              'スタッフ都合（お客様の承諾済み）',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ボタン部分
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonRow(
              reserveSecondarySpace: false,
              secondaryText: '戻る',
              onSecondaryPressed: widget.onBack,
              primaryText: '送信する',
              onPrimaryPressed: _canSubmit
                  ? () => widget.onConfirm(_selectedReason!)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
