import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../components/buttons/tile_button.dart';
import '../../../core/constants/app_images.dart';

enum EventStatus { completed, active, pending }

class Event {
  final String title;
  final String time;
  final EventStatus status;

  Event({required this.title, required this.time, required this.status});
}

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 新しい予定データ構造（日本語のサンプルデータ）
  final Map<DateTime, List<Event>> _events = {
    DateTime(2025, 9, 25): [
      Event(title: '会議', time: '10:00~12:00', status: EventStatus.active),
      Event(
        title: 'ランチミーティング',
        time: '12:30~13:30',
        status: EventStatus.pending,
      ),
    ],
    DateTime(2025, 9, 26): [
      Event(
        title: 'プレゼンテーション',
        time: '14:00~15:00',
        status: EventStatus.completed,
      ),
    ],
    DateTime(2025, 9, 28): [
      Event(title: '病院', time: '09:00~10:00', status: EventStatus.completed),
      Event(title: '買い物', time: '15:00~16:00', status: EventStatus.active),
      Event(title: '映画', time: '19:00~21:00', status: EventStatus.pending),
    ],
    DateTime(2025, 10, 1): [
      Event(
        title: '誕生日パーティー',
        time: '18:00~22:00',
        status: EventStatus.pending,
      ),
    ],
    DateTime(2025, 10, 5): [
      Event(title: '出張', time: '08:00~18:00', status: EventStatus.active),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
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
