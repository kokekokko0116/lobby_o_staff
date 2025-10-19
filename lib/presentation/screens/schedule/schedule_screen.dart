import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import 'models/schedule_event.dart';
import 'widgets/schedule_calendar.dart';
import 'widgets/schedule_event_list.dart';
import 'widgets/schedule_upcoming_list.dart';
import 'widgets/schedule_add_form.dart';
import 'widgets/schedule_event_detail.dart';
import 'widgets/schedule_event_edit.dart';
import 'widgets/schedule_cancel_confirm.dart';
import 'widgets/schedule_edit_confirm.dart';
import 'widgets/schedule_pending_detail.dart';
import 'data/sample_events.dart';
import '../../widgets/app/request_completion_widget.dart';
import '../../components/buttons/button_row.dart';
import '../bottom_sheets/customer_list.dart';

// 追加: enumのインポート
export 'widgets/schedule_event_edit.dart' show EditReason;
export 'widgets/schedule_cancel_confirm.dart' show CancelReason;

enum ScheduleMode {
  view,
  add,
  detail,
  edit,
  editConfirm,
  cancelConfirm,
  pendingDetail,
  requestSent,
}

class ScheduleScreen extends StatefulWidget {
  final bool showDetailDirectly; // 詳細画面を直接表示するかどうか

  const ScheduleScreen({super.key, this.showDetailDirectly = false});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // 既存の状態
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 追加: モード管理
  ScheduleMode _currentMode = ScheduleMode.view;

  // 追加: 新規予定入力用
  String _newEventTitle = '';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDateForNewEvent;

  // 追加: 選択された予定
  Event? _selectedEvent;

  // サンプルデータ（自動生成）
  late final Map<DateTime, List<Event>> _events;

  // 編集内容を保存するための変数
  String? _editedTitle;
  TimeOfDay? _editedStartTime;
  TimeOfDay? _editedEndTime;
  DateTime? _editedDate;

  // 顧客リスト（追加）
  final List<CustomerItem> _customers = [
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

  @override
  void initState() {
    super.initState();

    // サンプルデータを自動生成
    _events = SampleEventGenerator.generateSampleEvents();

    // 初期表示では本日の予定を表示
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);

    // パラメータに応じて初期表示を分岐
    if (widget.showDetailDirectly) {
      _initializeWithNearestEvent();
    } else {
      _currentMode = ScheduleMode.view;
    }
  }

  void _initializeWithNearestEvent() {
    final nearestEvent = _getNearestUpcomingEvent();
    if (nearestEvent != null) {
      setState(() {
        _selectedEvent = nearestEvent;
        _selectedDay = nearestEvent.date;
        // ペンディングステータスかどうかで詳細画面を分岐
        if (nearestEvent.status == EventStatus.pending) {
          _currentMode = ScheduleMode.pendingDetail;
        } else {
          _currentMode = ScheduleMode.detail;
        }
      });
    }
  }

  // 最も日程の近い今後の予定を取得
  Event? _getNearestUpcomingEvent() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    Event? nearestEvent;
    DateTime? nearestDate;

    for (var entry in _events.entries) {
      if (entry.key.isAfter(today) || entry.key.isAtSameMomentAs(today)) {
        for (var event in entry.value) {
          if (nearestDate == null || entry.key.isBefore(nearestDate)) {
            nearestDate = entry.key;
            nearestEvent = event;
          }
        }
      }
    }

    // 過去の日付の場合はcompletedステータスに変換
    if (nearestEvent != null && _isPastDate(nearestEvent.date)) {
      return Event(
        title: nearestEvent.title,
        time: nearestEvent.time,
        status: EventStatus.completed,
        date: nearestEvent.date,
        staffName: nearestEvent.staffName,
        staffImagePath: nearestEvent.staffImagePath,
        pendingType: nearestEvent.pendingType,
        requestSentAt: nearestEvent.requestSentAt,
        originalTime: nearestEvent.originalTime,
        originalDate: nearestEvent.originalDate,
        customer: nearestEvent.customer, // 追加
        requestReason: nearestEvent.requestReason, // 追加
        isCustomerRequest: nearestEvent.isCustomerRequest, // 追加
      );
    }

    return nearestEvent;
  }

  // その日の予定を取得する関数
  List<Event> _getEventsForDay(DateTime day) {
    final events = _events[DateTime(day.year, day.month, day.day)] ?? [];

    if (_isPastDate(day)) {
      return events
          .map(
            (event) => Event(
              title: event.title,
              time: event.time,
              status: EventStatus.completed,
              date: event.date,
              staffName: event.staffName,
              staffImagePath: event.staffImagePath,
              pendingType: event.pendingType,
              requestSentAt: event.requestSentAt,
              originalTime: event.originalTime,
              originalDate: event.originalDate,
              customer: event.customer, // 追加
              requestReason: event.requestReason, // 追加
              isCustomerRequest: event.isCustomerRequest, // 追加
            ),
          )
          .toList();
    }

    return events;
  }

  // 今後の予定を3つまで取得
  List<Event> _getUpcomingEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Event> upcomingEvents = [];

    for (var entry in _events.entries) {
      if (entry.key.isAfter(today) || entry.key.isAtSameMomentAs(today)) {
        upcomingEvents.addAll(entry.value);
      }
    }

    upcomingEvents.sort((a, b) => a.date.compareTo(b.date));
    return upcomingEvents.take(3).toList();
  }

  // 日付がtoday以前かどうかチェック
  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isBefore(today);
  }

  void _onEventTap(Event event) {
    setState(() {
      _selectedEvent = event;
      // ペンディングステータスの場合は専用画面へ
      if (event.status == EventStatus.pending) {
        _currentMode = ScheduleMode.pendingDetail;
      } else {
        _currentMode = ScheduleMode.detail;
      }
    });
  }

  void _onAddButtonPressed() {
    setState(() {
      _currentMode = ScheduleMode.add;
    });
  }

  void _onCancelAdd() {
    setState(() {
      _currentMode = ScheduleMode.view;
    });
  }

  void _onSubmitNewEvent(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    CustomerItem? customer, // 追加
    bool isCustomerRequest, // 追加
  ) {
    // 新規予定に担当者情報を追加（実際のAPIではサーバーから取得）
    final newEvent = Event(
      title: title.isEmpty ? '清掃' : title,
      time:
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}~${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      status: EventStatus.pending,
      date: date,
      staffName: '田中太郎', // 実際はAPIから取得
      staffImagePath: 'assets/images/avatars/staff_sample.png',
      pendingType: PendingType.add, // 追加リクエスト
      requestSentAt: DateTime.now(), // 追加
      customer: customer, // 追加
      isCustomerRequest: isCustomerRequest, // 追加
      // requestReasonは追加リクエストの場合は不要（編集・キャンセル時のみ）
    );

    // TODO: customerとisCustomerRequestをAPIに送信する処理を追加
    print('選択されたお客様: ${customer?.name}');
    print('お客様からの依頼: $isCustomerRequest');

    // リクエスト送信処理
    setState(() {
      _currentMode = ScheduleMode.requestSent;
    });
  }

  void _onRequestComplete() {
    setState(() {
      _currentMode = ScheduleMode.view;
      // 選択をリセットせず、当日を設定
      final now = DateTime.now();
      _selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  void _onEditEvent() {
    setState(() {
      _currentMode = ScheduleMode.edit;
    });
  }

  void _onCancelEvent() {
    setState(() {
      _currentMode = ScheduleMode.cancelConfirm;
    });
  }

  void _onConfirmCancel(CancelReason reason) {
    // CancelReasonをRequestReasonに変換
    final requestReason = reason == CancelReason.customerRequest
        ? RequestReason.customerRequest
        : RequestReason.staffRequest;

    // キャンセル処理を実行
    // TODO: reasonをAPIに送信する処理
    print(
      'キャンセル理由: ${requestReason == RequestReason.customerRequest ? "お客様都合" : "スタッフ都合"}',
    );
    setState(() {
      _currentMode = ScheduleMode.requestSent;
    });
  }

  void _onBackToDetail() {
    setState(() {
      _currentMode = ScheduleMode.detail;
    });
  }

  void _onBackToView() {
    setState(() {
      _currentMode = ScheduleMode.view;
      _selectedEvent = null;
      // 選択をリセットせず、当日を設定
      final now = DateTime.now();
      _selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  void _onSubmitEditEvent(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
    EditReason reason, // 追加
  ) {
    // EditReasonをRequestReasonに変換
    final requestReason = reason == EditReason.customerRequest
        ? RequestReason.customerRequest
        : RequestReason.staffRequest;

    // 編集内容を保存して確認画面へ
    setState(() {
      _editedTitle = title;
      _editedStartTime = startTime;
      _editedEndTime = endTime;
      _editedDate = date;

      // TODO: 実際にはここで編集されたイベントを作成してAPIに送信
      // 暫定的にrequestReasonを保存
      print(
        '変更理由: ${requestReason == RequestReason.customerRequest ? "お客様都合" : "スタッフ都合"}',
      );

      _currentMode = ScheduleMode.editConfirm;
    });
  }

  void _onConfirmEdit() {
    // 編集リクエスト送信処理
    setState(() {
      _currentMode = ScheduleMode.requestSent;
    });
  }

  void _onBackToEdit() {
    setState(() {
      _currentMode = ScheduleMode.edit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSurface,
      appBar: _buildAppBar(context),
      body: Padding(padding: const EdgeInsets.all(16), child: _buildContent()),
      // フローティングアクションボタンを追加（viewモードの時のみ表示）
      floatingActionButton: _currentMode == ScheduleMode.view
          ? FloatingActionButton(
              onPressed: _onAddButtonPressed,
              backgroundColor: backgroundAccent,
              elevation: 4,
              child: Icon(Icons.add, color: textOnPrimary, size: 28),
            )
          : null,
    );
  }

  // AppBarの構築（モードに応じて変更）
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    String title;
    VoidCallback? onBackPressed;

    switch (_currentMode) {
      case ScheduleMode.view:
        title = '変更・キャンセル連絡';
        onBackPressed = () => Navigator.of(context).pop();
        break;
      case ScheduleMode.add:
        title = '予定を追加';
        onBackPressed = _onCancelAdd;
        break;
      case ScheduleMode.detail:
        title = '予定詳細';
        onBackPressed = _onBackToView;
        break;
      case ScheduleMode.edit:
        title = '予定を編集';
        onBackPressed = _onBackToDetail;
        break;
      case ScheduleMode.editConfirm:
        title = '変更内容の確認';
        onBackPressed = _onBackToEdit;
        break;
      case ScheduleMode.cancelConfirm:
        title = 'キャンセルの確認';
        onBackPressed = _onBackToDetail;
        break;
      case ScheduleMode.pendingDetail:
        title = '申請中の予定';
        onBackPressed = _onBackToView;
        break;
      case ScheduleMode.requestSent:
        title = '申請完了';
        onBackPressed = null; // 完了画面では戻るボタンを非表示
        break;
    }

    return AppBar(
      backgroundColor: backgroundSurface,
      elevation: 0,
      leading: onBackPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: textPrimary),
              onPressed: onBackPressed,
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.h6.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    switch (_currentMode) {
      case ScheduleMode.view:
        return _buildViewMode();
      case ScheduleMode.add:
        return _buildAddMode();
      case ScheduleMode.detail:
        return _buildDetailMode();
      case ScheduleMode.edit:
        return _buildEditMode();
      case ScheduleMode.editConfirm:
        return _buildEditConfirmMode();
      case ScheduleMode.cancelConfirm:
        return _buildCancelConfirmMode();
      case ScheduleMode.pendingDetail:
        return _buildPendingDetailMode();
      case ScheduleMode.requestSent:
        return _buildRequestSentMode();
    }
  }

  Widget _buildViewMode() {
    return Column(
      children: [
        // カレンダー部分
        ScheduleCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),

        // 予定表示部分（常に選択された日の予定を表示）
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 真ん中寄せ
              Center(
                child: Text(
                  '${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日の予定',
                  style: AppTextStyles.h5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ScheduleEventList(
                  events: _getEventsForDay(_selectedDay!),
                  onEventTap: _onEventTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddMode() {
    return ScheduleAddForm(
      selectedDate: _selectedDay,
      onSubmit: _onSubmitNewEvent,
      onCancel: _onCancelAdd,
      customers: _customers, // 追加
    );
  }

  Widget _buildRequestSentMode() {
    String requestType = '追加';

    // 現在のモードの履歴に基づいてメッセージを決定
    if (_selectedEvent != null) {
      if (_editedDate != null) {
        requestType = '変更';
      } else {
        requestType = 'キャンセル';
      }
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: RequestCompletionWidget(requestType: requestType),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonRow(
              reserveSecondarySpace: false,
              secondaryText: '閉じる',
              onSecondaryPressed: () => Navigator.of(context).pop(),
              primaryText: null,
              onPrimaryPressed: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailMode() {
    if (_selectedEvent == null) return Container();

    return ScheduleEventDetail(
      event: _selectedEvent!,
      onEdit: _onEditEvent,
      onCancel: _onCancelEvent,
      onBack: _onBackToView,
    );
  }

  Widget _buildEditMode() {
    if (_selectedEvent == null) return Container();

    return ScheduleEventEdit(
      event: _selectedEvent!,
      onSubmit: _onSubmitEditEvent,
      onCancel: _onBackToView,
    );
  }

  Widget _buildEditConfirmMode() {
    if (_selectedEvent == null) return Container();

    return ScheduleEditConfirm(
      originalEvent: _selectedEvent!,
      editedTitle: _editedTitle!,
      editedStartTime: _editedStartTime!,
      editedEndTime: _editedEndTime!,
      editedDate: _editedDate!,
      onConfirm: _onConfirmEdit,
      onBack: _onBackToEdit,
    );
  }

  Widget _buildCancelConfirmMode() {
    if (_selectedEvent == null) return Container();

    return ScheduleCancelConfirm(
      event: _selectedEvent!,
      onBack: _onBackToDetail,
      onConfirm: _onConfirmCancel, // このまま（メソッド参照として渡す）
    );
  }

  Widget _buildPendingDetailMode() {
    if (_selectedEvent == null) return Container();

    return SchedulePendingDetail(event: _selectedEvent!, onBack: _onBackToView);
  }
}
