import 'package:flutter/material.dart';
import '../../components/buttons/button_row.dart';
import '../../widgets/app/review/date_selection_widget.dart';
import '../../widgets/app/review/completion_report_widget.dart';
import '../../widgets/app/review/service_confirmation_widget.dart';
import '../../widgets/app/review/service_evaluation_widget.dart';
import '../../widgets/app/review/service_comment_widget.dart';
import '../../widgets/app/review/review_final_confirmation_widget.dart';
import '../../widgets/app/review/review_completion_success.dart';

enum ReviewViewState {
  dateSelection, // 1. 日付選択
  completionReport, // 2. 完了報告の確認
  serviceConfirmation, // 3. サービス実施確認
  starRating, // 4. 5つ星評価
  comment, // 5. コメント入力
  finalConfirmation, // 6. 最終確認
  completion, // 完了画面
}

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({super.key});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  ReviewViewState _currentState = ReviewViewState.dateSelection;
  DateTime? _selectedDateTime;
  bool _isServiceConfirmed = false;
  int _rating = 0;
  String _comment = '';

  // サンプルのサービス実施日時リスト
  List<DateTime> _getServiceDates() {
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day - 7, 10, 0), // 1週間前
      DateTime(now.year, now.month, now.day - 3, 14, 30), // 3日前
      DateTime(now.year, now.month, now.day - 1, 9, 15), // 昨日
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
        if (_selectedDateTime != null) {
          _navigateToState(ReviewViewState.completionReport);
        }
        break;
      case ReviewViewState.completionReport:
        _navigateToState(ReviewViewState.serviceConfirmation);
        break;
      case ReviewViewState.serviceConfirmation:
        if (_isServiceConfirmed) {
          _navigateToState(ReviewViewState.starRating);
        }
        break;
      case ReviewViewState.starRating:
        if (_rating > 0) {
          _navigateToState(ReviewViewState.comment);
        }
        break;
      case ReviewViewState.comment:
        _navigateToState(ReviewViewState.finalConfirmation);
        break;
      case ReviewViewState.finalConfirmation:
        _submitReview();
        break;
      default:
        break;
    }
  }

  void _navigatePrevious() {
    switch (_currentState) {
      case ReviewViewState.completionReport:
        _navigateToState(ReviewViewState.dateSelection);
        break;
      case ReviewViewState.serviceConfirmation:
        _navigateToState(ReviewViewState.completionReport);
        break;
      case ReviewViewState.starRating:
        _navigateToState(ReviewViewState.serviceConfirmation);
        break;
      case ReviewViewState.comment:
        _navigateToState(ReviewViewState.starRating);
        break;
      case ReviewViewState.finalConfirmation:
        _navigateToState(ReviewViewState.comment);
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
    print('選択日時: $_selectedDateTime');
    print('サービス確認: $_isServiceConfirmed');
    print('評価: $_rating');
    print('コメント: $_comment');

    _navigateToState(ReviewViewState.completion);
  }

  Widget _getCurrentView() {
    switch (_currentState) {
      case ReviewViewState.dateSelection:
        return DateSelectionWidget(
          serviceDates: _getServiceDates(),
          selectedDateTime: _selectedDateTime,
          onDateSelected: (date) {
            setState(() {
              _selectedDateTime = date;
            });
          },
        );
      case ReviewViewState.completionReport:
        return CompletionReportWidget(
          selectedDateTime: _selectedDateTime!,
          staffName: '田中太郎',
          staffImagePath: 'assets/images/avatars/staff_sample.png',
        );
      case ReviewViewState.serviceConfirmation:
        return ServiceConfirmationWidget(
          serviceDateTime: _selectedDateTime!,
          isConfirmed: _isServiceConfirmed,
          onConfirmationChanged: (isConfirmed) {
            setState(() {
              _isServiceConfirmed = isConfirmed;
            });
          },
        );
      case ReviewViewState.starRating:
        return ServiceEvaluationWidget(
          rating: _rating,
          primaryButtonText: '次へ',
          secondaryButtonText: '戻る',
          onRatingChanged: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        );
      case ReviewViewState.comment:
        return ServiceCommentWidget(
          comment: _comment,
          onCommentChanged: (comment) {
            setState(() {
              _comment = comment;
            });
          },
        );
      case ReviewViewState.finalConfirmation:
        return ReviewFinalConfirmationWidget(
          selectedDateTime: _selectedDateTime!,
          rating: _rating,
          comment: _comment,
        );
      case ReviewViewState.completion:
        return ReviewCompletionSuccessWidget(
          selectedDateTime: _selectedDateTime!,
          rating: _rating,
          comment: _comment,
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
          primaryText: '次へ',
          onPrimaryPressed: _selectedDateTime != null ? _navigateNext : null,
        );
      case ReviewViewState.completionReport:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _navigateNext,
        );
      case ReviewViewState.serviceConfirmation:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _isServiceConfirmed ? _navigateNext : null,
        );
      case ReviewViewState.starRating:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _rating > 0 ? _navigateNext : null,
        );
      case ReviewViewState.comment:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '次へ',
          onPrimaryPressed: _navigateNext,
        );
      case ReviewViewState.finalConfirmation:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigatePrevious,
          primaryText: '送信する',
          onPrimaryPressed: _navigateNext,
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
