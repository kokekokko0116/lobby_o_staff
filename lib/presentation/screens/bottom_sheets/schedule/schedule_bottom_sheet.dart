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
import 'widgets/schedule_cancel_confirm.dart'; // Added import for ScheduleCancelConfirm
import 'widgets/schedule_edit_confirm.dart'; // Added import for ScheduleEditConfirm
import 'widgets/schedule_pending_detail.dart'; // Added import for SchedulePendingDetail
import 'data/sample_events.dart'; // 追加
import '../../../widgets/app/request_completion_widget.dart';
import '../../../components/buttons/button_row.dart';

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

class ScheduleBottomSheet extends StatefulWidget {
  final bool showDetailDirectly; // 詳細画面を直接表示するかどうか

  const ScheduleBottomSheet({super.key, this.showDetailDirectly = false});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
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
    );

    // リクエスト送信処理
    setState(() {
      _currentMode = ScheduleMode.requestSent;
    });
  }

  void _onRequestComplete() {
    setState(() {
      _currentMode = ScheduleMode.view;
      _selectedDay = null; // 選択をリセット
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

  void _onConfirmCancel() {
    // キャンセル処理を実行
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
      _selectedDay = null;
    });
  }

  void _onSubmitEditEvent(
    String title,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime date,
  ) {
    // 編集内容を保存して確認画面へ
    setState(() {
      _editedTitle = title;
      _editedStartTime = startTime;
      _editedEndTime = endTime;
      _editedDate = date;
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
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: Column(
        children: [
          // モードに応じた表示切り替え
          Expanded(child: _buildContent()),
        ],
      ),
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

        // 予定表示部分
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedDay != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日の予定',
                      style: AppTextStyles.h6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundAccent,
                        borderRadius: BorderRadius.circular(8),
                        // shadow
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _onAddButtonPressed,
                        color: textPrimary,
                        icon: Icon(Icons.add, color: Colors.white),
                        tooltip: '予定を追加',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ScheduleEventList(
                    events: _getEventsForDay(_selectedDay!),
                    onEventTap: _onEventTap,
                  ),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('今後の予定', style: AppTextStyles.h6),
                    FilledButton(
                      onPressed: _onAddButtonPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: backgroundAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(64, 42),
                      ),
                      child: Icon(Icons.add, color: textOnPrimary, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ScheduleUpcomingList(
                    events: _getUpcomingEvents(),
                    onEventTap: _onEventTap,
                  ),
                ),
              ],
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
          flex: 8,
          child: Center(
            child: RequestCompletionWidget(requestType: requestType),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonRow(
                reserveSecondarySpace: false,
                secondaryText: null,
                onSecondaryPressed: null,
                primaryText: '閉じる',
                onPrimaryPressed: _onRequestComplete,
              ),
            ],
          ),
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
      onConfirm: _onConfirmCancel,
      onBack: _onBackToDetail,
    );
  }

  Widget _buildPendingDetailMode() {
    if (_selectedEvent == null) return Container();

    return SchedulePendingDetail(event: _selectedEvent!, onBack: _onBackToView);
  }
}
