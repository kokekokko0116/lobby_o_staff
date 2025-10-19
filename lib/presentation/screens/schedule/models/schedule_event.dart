import '../../bottom_sheets/customer_list.dart';
import '../widgets/schedule_event_edit.dart'; // EditReasonのため
import '../widgets/schedule_cancel_confirm.dart'; // CancelReasonのため

enum EventStatus { completed, active, pending }

enum PendingType { add, edit, cancel }

// 理由を統一したenum（追加）
enum RequestReason {
  customerRequest, // お客様都合
  staffRequest, // スタッフ都合（お客様の承諾済み）
}

class Event {
  final String title;
  final String time;
  final EventStatus status;
  final DateTime date;
  final String staffName;
  final String? staffImagePath;
  final PendingType? pendingType; // ペンディングタイプ
  final DateTime? requestSentAt; // リクエスト送信時刻
  final String? originalTime; // 変更前の時間（変更の場合のみ）
  final DateTime? originalDate; // 変更前の日付（変更の場合のみ）
  final CustomerItem? customer; // お客様情報（追加）
  final RequestReason? requestReason; // リクエスト理由（追加）
  final bool? isCustomerRequest; // お客様からの依頼かどうか（追加用）

  Event({
    required this.title,
    required this.time,
    required this.status,
    required this.date,
    required this.staffName,
    this.staffImagePath,
    this.pendingType,
    this.requestSentAt,
    this.originalTime,
    this.originalDate,
    this.customer, // 追加
    this.requestReason, // 追加
    this.isCustomerRequest, // 追加
  });
}
