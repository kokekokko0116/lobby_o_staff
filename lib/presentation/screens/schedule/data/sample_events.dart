import '../models/schedule_event.dart';
import '../../bottom_sheets/customer_list.dart'; // 追加
import 'dart:math';

class SampleEventGenerator {
  static final Random _random = Random();

  // スタッフリスト
  static final List<Map<String, String>> _staffList = [
    {'name': '田中太郎', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '佐藤花子', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '山田次郎', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '鈴木一郎', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '高橋美咲', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '伊藤健太', 'image': 'assets/images/avatars/staff_sample.png'},
    {'name': '渡辺愛', 'image': 'assets/images/avatars/staff_sample.png'},
  ];

  // 顧客リスト（追加）
  static final List<CustomerItem> _customerList = [
    CustomerItem(
      name: '山田太郎',
      nearestStation: '博多駅',
      startDate: '2025/10/01',
      endDate: '2026/03/31',
      coordinatorName: '田中 花子',
      status: '契約中',
    ),
    CustomerItem(
      name: '佐藤花子',
      nearestStation: '天神駅',
      startDate: '2025/09/15',
      endDate: null,
      coordinatorName: '鈴木 太郎',
      status: '契約中',
    ),
    CustomerItem(
      name: '鈴木一郎',
      nearestStation: '西新駅',
      startDate: '2025/08/20',
      endDate: '2025/12/31',
      coordinatorName: '山田 次郎',
      status: '休止中',
    ),
  ];

  // タイトルリスト
  static final List<String> _titles = ['清掃', '定期清掃', '特別清掃'];

  /// 現在の日付の1ヶ月前から2ヶ月後までのサンプルイベントを生成
  static Map<DateTime, List<Event>> generateSampleEvents() {
    final Map<DateTime, List<Event>> events = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    // 1ヶ月前から2ヶ月後までの範囲
    final startDate = DateTime(today.year, today.month - 1, today.day);
    final endDate = DateTime(today.year, today.month + 2, today.day);

    // 日付を1日ずつループ
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      // 昨日、今日、明日は必ず予定がある
      final isImportantDay =
          currentDate.isAtSameMomentAs(yesterday) ||
          currentDate.isAtSameMomentAs(today) ||
          currentDate.isAtSameMomentAs(tomorrow);

      // 重要な日は必ず予定あり、それ以外は70%の確率でイベントあり
      if (isImportantDay || _random.nextDouble() > 0.3) {
        final eventCount = _random.nextInt(5) + 1; // 1〜5個のイベント
        final dayEvents = <Event>[];

        for (int i = 0; i < eventCount; i++) {
          dayEvents.add(_generateEvent(currentDate, today));
        }

        // 時間順にソート
        dayEvents.sort((a, b) => a.time.compareTo(b.time));

        events[DateTime(currentDate.year, currentDate.month, currentDate.day)] =
            dayEvents;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return events;
  }

  /// 単一のイベントを生成
  static Event _generateEvent(DateTime date, DateTime today) {
    final staff = _staffList[_random.nextInt(_staffList.length)];
    final title = _titles[_random.nextInt(_titles.length)];
    final customer = _customerList[_random.nextInt(_customerList.length)]; // 追加

    // 時間を生成（8:00〜20:00の範囲で）
    final startHour = _random.nextInt(12) + 8;
    final startMinute = _random.nextBool() ? 0 : 30;
    final duration = _random.nextInt(4) + 1;
    final endHour = startHour + duration;
    final endMinute = startMinute;

    final timeString =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}'
        '~${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

    // ステータスを決定
    EventStatus status;
    PendingType? pendingType;
    DateTime? requestSentAt;
    String? originalTime;
    DateTime? originalDate;
    RequestReason? requestReason; // 追加
    bool? isCustomerRequest; // 追加

    final isPast = date.isBefore(today);

    if (isPast) {
      // 過去の日付は完了済み
      status = EventStatus.completed;
    } else {
      // 未来の日付
      final statusRandom = _random.nextDouble();
      if (statusRandom < 0.7) {
        // 70%の確率でactive
        status = EventStatus.active;
      } else {
        // 30%の確率でpending
        status = EventStatus.pending;

        // Pendingタイプを決定
        final pendingRandom = _random.nextDouble();
        if (pendingRandom < 0.5) {
          pendingType = PendingType.add;
          // 追加の場合は、お客様からの依頼かどうかをランダムに設定
          isCustomerRequest = _random.nextBool();
        } else if (pendingRandom < 0.8) {
          pendingType = PendingType.edit;
          // 編集の場合は元の時間を設定
          originalTime =
              '${(startHour - 1).toString().padLeft(2, '0')}:00'
              '~${(endHour - 1).toString().padLeft(2, '0')}:00';
          originalDate = date.subtract(Duration(days: _random.nextInt(3)));
          // 理由をランダムに設定
          requestReason = _random.nextBool()
              ? RequestReason.customerRequest
              : RequestReason.staffRequest;
        } else {
          pendingType = PendingType.cancel;
          // 理由をランダムに設定
          requestReason = _random.nextBool()
              ? RequestReason.customerRequest
              : RequestReason.staffRequest;
        }

        // リクエスト送信日時（1〜5日前）
        requestSentAt = today
            .subtract(Duration(days: _random.nextInt(5) + 1))
            .add(
              Duration(
                hours: _random.nextInt(8) + 9,
                minutes: _random.nextInt(60),
              ),
            );
      }
    }

    return Event(
      title: title,
      time: timeString,
      status: status,
      date: date,
      staffName: staff['name']!,
      staffImagePath: staff['image']!,
      pendingType: pendingType,
      requestSentAt: requestSentAt,
      originalTime: originalTime,
      originalDate: originalDate,
      customer: customer, // 追加
      requestReason: requestReason, // 追加
      isCustomerRequest: isCustomerRequest, // 追加
    );
  }
}
