import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../components/buttons/button_row.dart';
import '../../widgets/app/request_completion_widget.dart';

enum ContractViewState {
  detail, // 詳細表示画面
  edit, // 編集画面
  completion, // 完了画面
}

class ContractDetailsBottomSheet extends StatefulWidget {
  const ContractDetailsBottomSheet({super.key});

  @override
  State<ContractDetailsBottomSheet> createState() =>
      _ContractDetailsBottomSheetState();
}

class _ContractDetailsBottomSheetState
    extends State<ContractDetailsBottomSheet> {
  final Map<int, bool> _expandedStates = {};
  ContractViewState _currentState = ContractViewState.detail;

  // 編集モード用の状態管理
  final Map<String, bool> _selectedItems = {};
  final TextEditingController _changeContentController =
      TextEditingController();

  List<Map<String, dynamic>> _getContractSections() {
    return [
      {
        'icon': Icons.account_circle,
        'title': '利用者情報',
        'details': [
          {'title': '氏名', 'value': '田中太郎'},
          {'title': '生年月日', 'value': '1985年4月15日'},
          {'title': '住所', 'value': '東京都渋谷区神宮前1-2-3'},
          {'title': '電話番号', 'value': '090-1234-5678'},
          {'title': '緊急連絡先', 'value': '03-1234-5678'},
        ],
      },
      {
        'icon': Icons.assignment,
        'title': '利用内容',
        'details': [
          {'title': 'サービス内容', 'value': '定期清掃サービス'},
          {'title': '契約期間', 'value': '1年3ヶ月'},
          {'title': '契約回数', 'value': '月2回'},
          {'title': 'サービス開始日', 'value': '2023年4月1日'},
          {'title': '担当スタッフ', 'value': '佐藤花子'},
        ],
      },
      {
        'icon': Icons.receipt,
        'title': '請求情報',
        'details': [
          {'title': '月額料金', 'value': '¥45,000'},
          {'title': '交通費', 'value': '¥4,500 (月額)'},
          {'title': '支払方法', 'value': '銀行振込'},
          {'title': '支払日', 'value': '毎月末日'},
          {'title': '支払先', 'value': '○○銀行'},
        ],
      },
    ];
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedStates[index] = !(_expandedStates[index] ?? false);
    });
  }

  @override
  void dispose() {
    _changeContentController.dispose();
    super.dispose();
  }

  void _navigateToEditMode() {
    setState(() {
      _currentState = ContractViewState.edit;
    });
  }

  void _navigateToDetailMode() {
    setState(() {
      _currentState = ContractViewState.detail;
    });
  }

  void _navigateToCompletionMode() {
    setState(() {
      _currentState = ContractViewState.completion;
    });
  }

  Widget _buildDetailView(List<Map<String, dynamic>> sections) {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return _buildContractSection(sections[index], index);
      },
    );
  }

  Widget _buildEditView(List<Map<String, dynamic>> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ヘッダー
        Text('変更したい項目にチェックを入れてください。（複数可）', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),

        // チェックボックスリスト（固定サイズ）
        Container(
          height: 160, // 3つのアイテム × 約60pxの固定高さ
          child: ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final sectionTitle = section['title'];

              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                  ),
                ),
                child: CheckboxListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 4,
                  ),
                  title: Text(sectionTitle, style: AppTextStyles.bodyMedium),
                  value: _selectedItems[sectionTitle] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedItems[sectionTitle] = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // 変更内容入力欄
        Text('変更内容をご記入ください。', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),

        // 残りの領域を全てテキストフィールドに
        Expanded(
          child: TextFormField(
            controller: _changeContentController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: '変更したい内容をこちらにご記入ください...',
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }

  void _submitChanges() {
    // 選択された項目を取得（セクションタイトルのみ）
    List<String> selectedSections = _selectedItems.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    String changeContent = _changeContentController.text;

    // ここで変更内容を処理（例：API送信など）
    print('選択されたセクション: $selectedSections');
    print('変更内容: $changeContent');

    // フォームをクリア
    _selectedItems.clear();
    _changeContentController.clear();

    // 完了画面に遷移
    _navigateToCompletionMode();
  }

  Widget _buildCompletionView() {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [const RequestCompletionWidget(requestType: '変更')],
      ),
    );
  }

  Widget _buildContractSection(Map<String, dynamic> section, int index) {
    final IconData icon = section['icon'];
    final String title = section['title'];
    final List<Map<String, String>> details = section['details'];
    final bool isExpanded = _expandedStates[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleExpanded(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 4.0,
              ),
              child: Row(
                children: [
                  Icon(icon, color: textPrimary, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 4, bottom: 16),
              child: Column(
                children: details.map((detail) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            detail['title']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            detail['value']!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getCurrentView() {
    final sections = _getContractSections();

    switch (_currentState) {
      case ContractViewState.detail:
        return _buildDetailView(sections);
      case ContractViewState.edit:
        return _buildEditView(sections);
      case ContractViewState.completion:
        return _buildCompletionView();
    }
  }

  ButtonRow _getButtonRow() {
    switch (_currentState) {
      case ContractViewState.detail:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: null,
          onSecondaryPressed: null,
          primaryText: '変更する',
          onPrimaryPressed: _navigateToEditMode,
        );
      case ContractViewState.edit:
        return ButtonRow(
          reserveSecondarySpace: false,
          secondaryText: '戻る',
          onSecondaryPressed: _navigateToDetailMode,
          primaryText: '送信する',
          onPrimaryPressed: _submitChanges,
        );
      case ContractViewState.completion:
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
          // Content領域（7割）
          Expanded(flex: 8, child: _getCurrentView()),
          // Button領域（3割）
          Expanded(flex: 2, child: _getButtonRow()),
        ],
      ),
    );
  }
}
