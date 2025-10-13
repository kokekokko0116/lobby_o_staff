import 'package:flutter/material.dart';
import '../../components/buttons/button_row.dart';
import '../../widgets/app/review/date_selection_widget.dart';
import '../../widgets/app/review/completion_report_widget.dart';
import '../../widgets/app/review/service_confirmation_widget.dart';
import '../../widgets/app/review/additional_work.dart';
import '../../widgets/app/review/review_final_confirmation_widget.dart';
import '../../widgets/app/review/review_completion_success.dart';

enum ReviewViewState {
  dateSelection, // 1. 日付選択
  serviceConfirmation, // 2. サービス実施確認
  additionalWork, // 3. 追加作業
  completionReport, // 4. 完了報告
  finalConfirmation, // 5. 最終確認
  completion, // 6. 完了画面
}

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({super.key});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  ReviewViewState _currentState = ReviewViewState.dateSelection;
  ServiceSchedule? _selectedSchedule;
  DateTime? _modifiedDateTime;
  bool _isServiceConfirmed = false;

  // 追加作業関連
  WorkCompletionStatus? _workStatus;
  String _additionalWorkText = '';

  // 完了報告関連
  ReportStatus? _reportStatus;
  String _reportText = '';

  // 最終確認
  bool _isFinalConfirmed = false;

  // サンプルのサービス実施予定リスト
  List<ServiceSchedule> _getServiceSchedules() {
    final now = DateTime.now();
    return [
      ServiceSchedule(
        dateTime: DateTime(now.year, now.month, now.day - 7, 10, 0),
        staffName: '田中太郎',
        nearestStation: '新宿駅',
        status: 'regular',
        isCompleted: true,
      ),
      ServiceSchedule(
        dateTime: DateTime(now.year, now.month, now.day - 3, 14, 30),
        staffName: '佐藤花子',
        nearestStation: '渋谷駅',
        status: 'trial',
        isCompleted: false,
      ),
      ServiceSchedule(
        dateTime: DateTime(now.year, now.month, now.day - 1, 9, 15),
        staffName: '山田次郎',
        nearestStation: '品川駅',
        status: 'regular',
        isCompleted: false,
      ),
    ];
  }

  void _navigateToState(ReviewViewState state) {
    setState(() {
      _currentState = state;
    });
  }

  void _navigateNext() {
    switch (_currentState) {
      case ReviewViewState.dateSelection:
        if (_selectedSchedule != null) {
          _navigateToState(ReviewViewState.serviceConfirmation);
        }
        break;
      case ReviewViewState.serviceConfirmation:
        if (_isServiceConfirmed) {
          _navigateToState(ReviewViewState.additionalWork);
        }
        break;
      case ReviewViewState.additionalWork:
        if (_workStatus != null) {
          _navigateToState(ReviewViewState.completionReport);
        }
        break;
      case ReviewViewState.completionReport:
        if (_reportStatus != null) {
          _navigateToState(ReviewViewState.finalConfirmation);
        }
        break;
      case ReviewViewState.finalConfirmation:
        if (_isFinalConfirmed) {
          _submitReview();
        }
        break;
      default:
        break;
    }
  }

  void _navigatePrevious() {
    switch (_currentState) {
      case ReviewViewState.serviceConfirmation:
        _navigateToState(ReviewViewState.dateSelection);
        break;
      case ReviewViewState.additionalWork:
        _navigateToState(ReviewViewState.serviceConfirmation);
        break;
      case ReviewViewState.completionReport:
        _navigateToState(ReviewViewState.additionalWork);
        break;
      case ReviewViewState.finalConfirmation:
        _navigateToState(ReviewViewState.completionReport);
        break;
      case ReviewViewState.completion:
        Navigator.of(context).pop();
        break;
      default:
        break;
    }
  }

  void _submitReview() {
    // レビューデータを送信する処理
    print('=== レビュー送信 ===');
    print('選択スケジュール: ${_selectedSchedule?.dateTime}');
    print('変更後の日時: $_modifiedDateTime');
    print('スタッフ名: ${_selectedSchedule?.staffName}');
    print('サービス確認: $_isServiceConfirmed');
    print('作業状況: $_workStatus');
    print('追加作業内容: $_additionalWorkText');
    print('報告状況: $_reportStatus');
    print('報告内容: $_reportText');
    print('最終確認: $_isFinalConfirmed');

    _navigateToState(ReviewViewState.completion);
  }

  Widget _getCurrentView() {
    switch (_currentState) {
      case ReviewViewState.dateSelection:
        return DateSelectionWidget(
          serviceSchedules: _getServiceSchedules(),
          selectedSchedule: _selectedSchedule,
          onScheduleSelected: (schedule) {
            setState(() {
              _selectedSchedule = schedule;
              _modifiedDateTime = null;
            });
            Future.microtask(() => _navigateNext());
          },
        );
      case ReviewViewState.serviceConfirmation:
        return ServiceConfirmationWidget(
          serviceDateTime: _modifiedDateTime ?? _selectedSchedule!.dateTime,
          isConfirmed: _isServiceConfirmed,
          onConfirmationChanged: (isConfirmed) {
            setState(() {
              _isServiceConfirmed = isConfirmed;
            });
          },
          onDateTimeChanged: (newDateTime) {
            setState(() {
              _modifiedDateTime = newDateTime;
            });
          },
        );
      case ReviewViewState.additionalWork:
        return AdditionalWork(
          schedule: _selectedSchedule!,
          selectedStatus: _workStatus,
          additionalWorkText: _additionalWorkText,
          onStatusChanged: (status) {
            setState(() {
              _workStatus = status;
            });
          },
          onAdditionalWorkChanged: (text) {
            setState(() {
              _additionalWorkText = text;
            });
          },
        );
      case ReviewViewState.completionReport:
        return CompletionReportWidget(
          schedule: _selectedSchedule!,
          selectedStatus: _reportStatus,
          reportText: _reportText,
          onStatusChanged: (status) {
            setState(() {
              _reportStatus = status;
            });
          },
          onReportChanged: (text) {
            setState(() {
              _reportText = text;
            });
          },
        );
      case ReviewViewState.finalConfirmation:
        return ReviewFinalConfirmationWidget(
          schedule: _selectedSchedule!,
          modifiedDateTime: _modifiedDateTime,
          workStatus: _workStatus,
          additionalWorkText: _additionalWorkText,
          reportStatus: _reportStatus,
          reportText: _reportText,
          isConfirmed: _isFinalConfirmed,
          onConfirmationChanged: (isConfirmed) {
            setState(() {
              _isFinalConfirmed = isConfirmed;
            });
          },
        );
      case ReviewViewState.completion:
        return ReviewCompletionSuccessWidget(
          selectedDateTime: _modifiedDateTime ?? _selectedSchedule!.dateTime,
          rating: 0,
          comment: '',
        );
    }
  }

  ButtonRow _getButtonRow() {
    switch (_currentState) {
      case ReviewViewState.dateSelection:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: null,
          onSecondaryPressed: null,
          primaryText: null,
          onPrimaryPressed: null,
        );
      case ReviewViewState.serviceConfirmation:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _isServiceConfirmed ? _navigateNext : null,
        );
      case ReviewViewState.additionalWork:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _workStatus != null ? _navigateNext : null,
        );
      case ReviewViewState.completionReport:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _reportStatus != null ? _navigateNext : null,
        );
      case ReviewViewState.finalConfirmation:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '送信する',
          onPrimaryPressed: _isFinalConfirmed ? _navigateNext : null,
        );
      case ReviewViewState.completion:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: null,
          onSecondaryPressed: null,
          primaryText: '閉じる',
          onPrimaryPressed: () => Navigator.of(context).pop(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        minHeight: 400,
      ),
      child: Column(
        children: [
          // Content領域（8割）
          Expanded(flex: 8, child: _getCurrentView()),
          // Button領域（2割）
          Expanded(flex: 2, child: _getButtonRow()),
        ],
      ),
    );
  }
}
