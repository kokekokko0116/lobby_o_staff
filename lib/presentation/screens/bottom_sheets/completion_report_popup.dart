import 'package:flutter/material.dart';
import '../../components/buttons/button_row.dart';
import '../../widgets/app/review/completion_report_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// 完了報告のポップアップ
///
/// このポップアップは、サービス完了報告を表示するためのシンプルな画面です。
/// reviewフォルダの既存ウィジェットを活用して、スタッフ情報と完了報告内容を表示します。
class CompletionReportPopup extends StatelessWidget {
  const CompletionReportPopup({
    super.key,
    required this.completionDateTime,
    this.staffName = '田中太郎',
    this.staffImagePath = 'assets/images/avatars/staff_sample.png',
    this.reportContent,
    this.onClose,
  });

  /// 完了報告の日時
  final DateTime completionDateTime;

  /// スタッフ名
  final String staffName;

  /// スタッフの画像パス
  final String staffImagePath;

  /// 報告内容（nullの場合はデフォルトの内容を表示）
  final String? reportContent;

  /// 閉じるボタンが押された時のコールバック
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: 400,
        maxWidth: 600, // デスクトップでの最大幅を制限
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ヘッダー
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: backgroundAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                // 中央配置のタイトル
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                  child: Center(
                    child: Text(
                      '完了報告',
                      style: AppTextStyles.h6.copyWith(color: textOnPrimary),
                    ),
                  ),
                ),
                // 絶対位置の閉じるボタン
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: IconButton(
                //     onPressed: onClose ?? () => Navigator.of(context).pop(),
                //     icon: const Icon(Icons.close, color: Colors.white),
                //     padding: EdgeInsets.zero,
                //     constraints: const BoxConstraints(
                //       minWidth: 24,
                //       minHeight: 24,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // コンテンツ領域
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CompletionReportWidget(
                selectedDateTime: completionDateTime,
                staffName: staffName,
                staffImagePath: staffImagePath,
                reportContent: reportContent,
              ),
            ),
          ),

          // ボタン領域
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonRow(
              secondaryText: null,
              onSecondaryPressed: null,
              primaryText: '次へ',
              onPrimaryPressed: onClose ?? () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  /// ポップアップを表示するヘルパーメソッド
  static Future<void> show(
    BuildContext context, {
    required DateTime completionDateTime,
    String staffName = '田中太郎',
    String staffImagePath = 'assets/images/avatars/staff_sample.png',
    String? reportContent,
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: CompletionReportPopup(
          completionDateTime: completionDateTime,
          staffName: staffName,
          staffImagePath: staffImagePath,
          reportContent: reportContent,
          onClose: onClose,
        ),
      ),
    );
  }
}
