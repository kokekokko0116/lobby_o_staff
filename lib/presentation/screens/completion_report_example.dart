import 'package:flutter/material.dart';
import 'bottom_sheets/completion_report_popup.dart';

/// 完了報告ポップアップの使用例を示すサンプル画面
///
/// この画面は、CompletionReportPopupの使い方を説明するためのデモ画面です。
class CompletionReportExampleScreen extends StatelessWidget {
  const CompletionReportExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('完了報告ポップアップ サンプル'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '完了報告ポップアップのサンプル',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'ボタンを押すと、完了報告のポップアップが表示されます。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // デフォルトの完了報告ポップアップ
            ElevatedButton(
              onPressed: () => _showDefaultPopup(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('デフォルトの完了報告を表示'),
            ),

            const SizedBox(height: 16),

            // カスタム内容の完了報告ポップアップ
            ElevatedButton(
              onPressed: () => _showCustomPopup(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: const Text('カスタム内容の完了報告を表示'),
            ),

            const SizedBox(height: 16),

            // 別のスタッフの完了報告ポップアップ
            ElevatedButton(
              onPressed: () => _showDifferentStaffPopup(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
              ),
              child: const Text('別のスタッフの完了報告を表示'),
            ),

            const SizedBox(height: 32),

            const Text(
              '使用方法:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. CompletionReportPopup.show()を呼び出す\n'
              '2. 必要なパラメータ（日時、スタッフ情報等）を設定\n'
              '3. ポップアップが自動的に表示される',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// デフォルトの完了報告ポップアップを表示
  void _showDefaultPopup(BuildContext context) {
    CompletionReportPopup.show(
      context,
      completionDateTime: DateTime.now().subtract(const Duration(hours: 1)),
    );
  }

  /// カスタム内容の完了報告ポップアップを表示
  void _showCustomPopup(BuildContext context) {
    CompletionReportPopup.show(
      context,
      completionDateTime: DateTime.now().subtract(const Duration(hours: 2)),
      staffName: '佐藤花子',
      reportContent:
          'お疲れ様でした。本日はキッチンの換気扇清掃、浴室のカビ除去作業、窓拭き清掃を重点的に実施いたしました。'
          '特に換気扇については分解清掃を行い、内部の油汚れも綺麗に除去いたしました。'
          '浴室のカビについても専用洗剤で徹底的に清掃し、防カビコーティングも施しております。'
          '何かご質問やご要望がございましたら、お気軽にお声かけください。',
      onClose: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('カスタムポップアップが閉じられました')));
      },
    );
  }

  /// 別のスタッフの完了報告ポップアップを表示
  void _showDifferentStaffPopup(BuildContext context) {
    CompletionReportPopup.show(
      context,
      completionDateTime: DateTime.now().subtract(const Duration(days: 1)),
      staffName: '鈴木一郎',
      staffImagePath: 'assets/images/avatars/staff_sample_old.png',
      reportContent:
          '本日は庭の草取り、植木の剪定作業を実施いたしました。'
          '雑草を根元から除去し、植木は形を整えて風通しを良くしました。'
          '作業で出た草や枝葉は適切に処分いたします。'
          '今後も定期的なメンテナンスをお勧めいたします。',
    );
  }
}
