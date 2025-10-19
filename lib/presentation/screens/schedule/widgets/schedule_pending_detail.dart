import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../components/buttons/button_row.dart';
import '../../../components/buttons/secondary_button.dart';
import '../../../widgets/app/staff_info_widget.dart';
import '../models/schedule_event.dart';
import '../../bottom_sheets/customer_list.dart';
import '../widgets/schedule_event_edit.dart'; // EditReasonのため
import '../widgets/schedule_cancel_confirm.dart'; // CancelReasonのため

class SchedulePendingDetail extends StatelessWidget {
  final Event event;
  final VoidCallback onBack;

  const SchedulePendingDetail({
    super.key,
    required this.event,
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getPendingTypeText() {
    switch (event.pendingType) {
      case PendingType.add:
        return '追加';
      case PendingType.edit:
        return '変更';
      case PendingType.cancel:
        return 'キャンセル';
      default:
        return '処理';
    }
  }

  Color _getPendingTypeColor() {
    switch (event.pendingType) {
      case PendingType.add:
        return Colors.green;
      case PendingType.edit:
        return Colors.orange;
      case PendingType.cancel:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTimeDisplay() {
    switch (event.pendingType) {
      case PendingType.add:
        return _buildAddTimeDisplay();
      case PendingType.edit:
        return _buildEditTimeDisplay();
      case PendingType.cancel:
        return _buildCancelTimeDisplay();
      default:
        return Container();
    }
  }

  Widget _buildAddTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // お客様情報（追加）
          if (event.customer != null) ...[
            Text(
              'お客様情報',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${event.customer!.name}様',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.place, size: 12, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.customer!.nearestStation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: event.customer!.status == '契約中'
                        ? backgroundAccent.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.customer!.status,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: event.customer!.status == '契約中'
                          ? backgroundAccent
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別バッジ
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('リクエスト内容', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(_formatDate(event.date), style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(event.time, style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),
          // 理由（追加）
          if (event.isCustomerRequest != null) ...[
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.isCustomerRequest == true
                        ? 'お客様からのご依頼に基づきサービスを追加します。'
                        : 'スタッフからの追加リクエスト',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // お客様情報（追加）
          if (event.customer != null) ...[
            Text(
              'お客様情報',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${event.customer!.name}様',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.place, size: 12, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.customer!.nearestStation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: event.customer!.status == '契約中'
                        ? backgroundAccent.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.customer!.status,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: event.customer!.status == '契約中'
                          ? backgroundAccent
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('変更内容', style: AppTextStyles.labelMedium),
          const SizedBox(height: 12),

          // 変更前
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('変更前', style: AppTextStyles.labelSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(
                        event.originalDate ?? event.date,
                      ), // 変更前の日付を表示
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      event.originalTime ?? '時間情報なし',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Center(
            child: Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          ),
          const SizedBox(height: 8),

          // 変更後
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '変更後',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(event.date), // 変更後の日付を表示
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      event.time,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 理由（追加）
          if (event.requestReason != null) ...[
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getReasonText(),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCancelTimeDisplay() {
    final pendingTypeText = _getPendingTypeText();
    final pendingTypeColor = _getPendingTypeColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // お客様情報（追加）
          if (event.customer != null) ...[
            Text(
              'お客様情報',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${event.customer!.name}様',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.place, size: 12, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.customer!.nearestStation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: event.customer!.status == '契約中'
                        ? backgroundAccent.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.customer!.status,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: event.customer!.status == '契約中'
                          ? backgroundAccent
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // リクエスト送信時刻
          Text('リクエスト送信時刻', style: AppTextStyles.labelMedium),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(event.requestSentAt ?? DateTime.now()),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // リクエスト種別
          Text(
            '「$pendingTypeText」のリクエストを送信済み',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: 16),

          Text('キャンセル対象', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(_formatDate(event.date), style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                event.time,
                style: AppTextStyles.bodyMedium, // 取り消し線を削除
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 理由（追加）
          if (event.requestReason != null) ...[
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getReasonText(),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 理由のテキストを取得（追加）
  String _getReasonText() {
    if (event.requestReason == null) return '理由未設定';

    switch (event.requestReason!) {
      case RequestReason.customerRequest:
        return 'お客様都合';
      case RequestReason.staffRequest:
        return 'スタッフ都合（お客様の承諾済み）';
    }
  }

  // お客様情報セクションを構築（追加）
  Widget _buildCustomerInfoSection() {
    if (event.customer == null) return Container();

    final customer = event.customer!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'お客様情報',
            style: AppTextStyles.labelMedium.copyWith(
              color: textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // お客様名
              Text(
                '${customer.name}様',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              // 最寄駅
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundPrimary,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: borderPrimary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.place, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      customer.nearestStation,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ステータス
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: customer.status == '契約中'
                  ? backgroundAccent.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              customer.status,
              style: AppTextStyles.bodySmall.copyWith(
                color: customer.status == '契約中'
                    ? backgroundAccent
                    : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 理由セクションを構築（デバッグ版）
  Widget _buildReasonSection() {
    String? reasonText;

    // 追加リクエストの場合
    if (event.pendingType == PendingType.add &&
        event.isCustomerRequest != null) {
      reasonText = event.isCustomerRequest == true
          ? 'お客様からのご依頼に基づきサービスを追加します。'
          : 'スタッフからの追加リクエスト';
    }
    // 編集・キャンセルの場合
    else if (event.requestReason != null) {
      reasonText = _getReasonText();
    }

    // 理由が設定されていない場合は表示しない
    if (reasonText == null) {
      print('reasonTextがnullのため表示しない');
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderPrimary),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reasonText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                // 時間表示（お客様情報と理由を含む）
                _buildTimeDisplay(),
                const SizedBox(height: 20),

                // 注意事項
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundPrimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderPrimary),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: backgroundAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '担当者が内容を確認後に確定いたします。確定までしばらくお待ちください。',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ボタン部分
        ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: onBack,
          primaryText: null,
          onPrimaryPressed: null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
