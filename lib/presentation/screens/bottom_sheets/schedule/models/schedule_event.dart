enum EventStatus { completed, active, pending }

enum PendingType { add, edit, cancel }

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
  });
}
