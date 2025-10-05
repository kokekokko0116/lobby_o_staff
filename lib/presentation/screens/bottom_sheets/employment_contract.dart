import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class EmploymentContractBottomSheet extends StatelessWidget {
  const EmploymentContractBottomSheet({super.key});

  // 書類データを取得
  List<Map<String, dynamic>> _getDocumentData() {
    return [
      {
        'icon': Icons.picture_as_pdf,
        'label': '雇用契約書',
        'actionIcon': Icons.arrow_forward_ios,
      },
      {
        'icon': Icons.picture_as_pdf,
        'label': '誓約書',
        'actionIcon': Icons.arrow_forward_ios,
      },
      {
        'icon': Icons.picture_as_pdf,
        'label': '身元保証書',
        'actionIcon': Icons.arrow_forward_ios,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final documentData = _getDocumentData();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 300,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < documentData.length; i++)
                  _buildDocumentItem(context, documentData[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, Map<String, dynamic> item) {
    final IconData icon = item['icon'];
    final String label = item['label'];
    final IconData? actionIcon = item['actionIcon'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
      child: InkWell(
        onTap: () {
          _onDocumentTap(context, label);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
          child: Row(
            children: [
              // アイコン
              Icon(icon, color: textPrimary, size: 24),

              const SizedBox(width: 16),

              // ラベル
              Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),

              // 矢印アイコン
              if (actionIcon != null)
                Icon(actionIcon, color: textSecondary, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _onDocumentTap(BuildContext context, String documentName) {
    // 書類タップ時の処理
    // 例：書類画面へ遷移、PDFダウンロードなど
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$documentNameを表示します'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
