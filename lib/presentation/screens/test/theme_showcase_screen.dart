import 'package:flutter/material.dart';

/// 【テーマショーケース】アプリテーマの全コンポーネントを表示するページ
///
/// 【目的】
/// - AppThemeで設定したすべてのコンポーネントの確認
/// - デザインシステムの一覧表示
/// - 各パーツの見た目とテーマ適用の確認
///
/// 【使用方法】
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => ThemeShowcaseScreen()),
/// )
/// ```
class ThemeShowcaseScreen extends StatefulWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  State<ThemeShowcaseScreen> createState() => _ThemeShowcaseScreenState();
}

class _ThemeShowcaseScreenState extends State<ThemeShowcaseScreen>
    with TickerProviderStateMixin {
  bool _switchValue = true;
  bool _checkboxValue = true;
  String _radioValue = 'option1';
  double _sliderValue = 50.0;
  int _selectedTabIndex = 0;
  int _bottomNavIndex = 0;
  final TextEditingController _textController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _textController.text = 'サンプルテキスト';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テーマショーケース'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              _showSnackBar(context, 'テーマアクションが実行されました');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'コンポーネント', icon: Icon(Icons.widgets)),
            Tab(text: 'テキスト', icon: Icon(Icons.text_fields)),
            Tab(text: 'カラー', icon: Icon(Icons.palette)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComponentsTab(),
          _buildTextTab(),
          _buildColorsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        tooltip: 'ダイアログを表示',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'お気に入り',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('ボタン', [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('アイコン付き'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('シェア'),
                ),
              ],
            ),
          ]),

          _buildSection('入力フィールド', [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'ラベル',
                hintText: 'ヒントテキストを入力してください',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'エラー状態',
                errorText: 'エラーメッセージの例',
                helperText: 'ヘルパーテキストの例',
                suffixIcon: Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'マルチライン',
                hintText: '複数行のテキストを入力できます...',
                border: OutlineInputBorder(),
              ),
            ),
          ]),

          _buildSection('選択コントロール', [
            SwitchListTile(
              title: const Text('スイッチ'),
              subtitle: const Text('オン/オフを切り替え'),
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('チェックボックス'),
              subtitle: const Text('複数選択可能'),
              value: _checkboxValue,
              onChanged: (bool? value) {
                setState(() {
                  _checkboxValue = value ?? false;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('ラジオボタン 1'),
              value: 'option1',
              groupValue: _radioValue,
              onChanged: (String? value) {
                setState(() {
                  _radioValue = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('ラジオボタン 2'),
              value: 'option2',
              groupValue: _radioValue,
              onChanged: (String? value) {
                setState(() {
                  _radioValue = value!;
                });
              },
            ),
          ]),

          _buildSection('スライダー', [
            Text('値: ${_sliderValue.round()}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 10,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ]),

          _buildSection('プログレスインジケーター', [
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CircularProgressIndicator(value: 0.7),
                CircularProgressIndicator(),
              ],
            ),
          ]),

          _buildSection('チップ', [
            Wrap(
              spacing: 8,
              children: [
                const Chip(
                  avatar: CircleAvatar(
                    child: Text('A'),
                  ),
                  label: Text('アバター付きチップ'),
                ),
                Chip(
                  label: const Text('削除可能チップ'),
                  onDeleted: () {},
                ),
                const Chip(
                  label: Text('基本チップ'),
                ),
                ActionChip(
                  label: const Text('アクションチップ'),
                  onPressed: () {},
                ),
              ],
            ),
          ]),

          _buildSection('カード & リスト', [
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.album),
                    title: const Text('カードタイトル'),
                    subtitle: const Text('サブタイトルテキスト'),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('カード内のコンテンツです。'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('キャンセル'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),

          _buildSection('その他', [
            const Divider(thickness: 2),
            Tooltip(
              message: 'ツールチップの例です',
              child: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _showDialog(context),
                  child: const Text('ダイアログ'),
                ),
                ElevatedButton(
                  onPressed: () => _showBottomSheet(context),
                  child: const Text('ボトムシート'),
                ),
                ElevatedButton(
                  onPressed: () => _showSnackBar(context, 'スナックバーの例'),
                  child: const Text('スナックバー'),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTextTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('見出し', [
            Text(
              '見出し1（H1）',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '見出し2（H2）',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '見出し3（H3）',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '見出し4（H4）',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '見出し5（H5）',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '見出し6（H6）',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ]),

          _buildSection('本文テキスト', [
            Text(
              'Large Body Text - このテキストは大きめの本文です。読みやすさを考慮したサイズとなっています。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Medium Body Text - 標準的な本文テキストのサイズです。一般的な文章に使用されます。',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Small Body Text - 小さめの本文テキストです。詳細情報や補足説明に使用されます。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ]),

          _buildSection('ラベル', [
            Text(
              'Large Label',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              'Medium Label',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Small Label',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ]),

          _buildSection('テキストスタイル例', [
            const Text(
              '通常のテキスト',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '太字のテキスト',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'イタリックのテキスト',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Text(
              '下線付きテキスト',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildColorsTab() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('プライマリカラー', [
            _buildColorTile('Primary', colorScheme.primary, colorScheme.onPrimary),
            _buildColorTile('Primary Container', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
          ]),

          _buildSection('セカンダリカラー', [
            _buildColorTile('Secondary', colorScheme.secondary, colorScheme.onSecondary),
            _buildColorTile('Secondary Container', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
          ]),

          _buildSection('表面カラー', [
            _buildColorTile('Surface', colorScheme.surface, colorScheme.onSurface),
            _buildColorTile('Surface Variant', colorScheme.surfaceVariant, colorScheme.onSurfaceVariant),
          ]),

          _buildSection('その他のカラー', [
            _buildColorTile('Error', colorScheme.error, colorScheme.onError),
            _buildColorTile('Outline', colorScheme.outline, colorScheme.onSurface),
            _buildColorTile('Outline Variant', colorScheme.outlineVariant, colorScheme.onSurface),
          ]),

          _buildSection('背景カラー', [
            _buildColorTile('Background', colorScheme.background, colorScheme.onBackground),
            _buildColorTile('Scaffold Background', Theme.of(context).scaffoldBackgroundColor, colorScheme.onBackground),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildColorTile(String name, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ダイアログの例'),
          content: const Text('これはテーマが適用されたダイアログです。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ボトムシートの例',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('これはテーマが適用されたボトムシートです。'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('閉じる'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '元に戻す',
          onPressed: () {
            // アクション処理
          },
        ),
      ),
    );
  }
}