import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class WorkHistoryBottomSheet extends StatefulWidget {
  const WorkHistoryBottomSheet({Key? key}) : super(key: key);

  @override
  State<WorkHistoryBottomSheet> createState() => _WorkHistoryBottomSheetState();
}

class _WorkHistoryBottomSheetState extends State<WorkHistoryBottomSheet> {
  late DateTime _currentDate;
  late DateTime _oldestDate;

  // 月ごとの稼働データ（サンプル）
  final Map<String, Map<String, dynamic>> _monthlyData = {
    '2024-10': {'hours': 25, 'minutes': 30, 'days': 8},
    '2024-11': {'hours': 30, 'minutes': 15, 'days': 10},
    '2024-12': {'hours': 28, 'minutes': 0, 'days': 9},
    '2025-1': {'hours': 32, 'minutes': 45, 'days': 11},
    '2025-2': {'hours': 27, 'minutes': 20, 'days': 9},
    '2025-3': {'hours': 29, 'minutes': 10, 'days': 10},
    '2025-4': {'hours': 26, 'minutes': 30, 'days': 8},
    '2025-5': {'hours': 31, 'minutes': 0, 'days': 10},
    '2025-6': {'hours': 28, 'minutes': 50, 'days': 9},
    '2025-7': {'hours': 30, 'minutes': 15, 'days': 10},
    '2025-8': {'hours': 33, 'minutes': 40, 'days': 11},
    '2025-9': {'hours': 29, 'minutes': 25, 'days': 10},
    '2025-10': {'hours': 25, 'minutes': 30, 'days': 8},
  };

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    // 1年前の日付を計算
    _oldestDate = DateTime(_currentDate.year - 1, _currentDate.month);
  }

  // 前の月に移動
  void _goToPreviousMonth() {
    if (_currentDate.isAfter(_oldestDate)) {
      setState(() {
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      });
    }
  }

  // 次の月に移動
  void _goToNextMonth() {
    final now = DateTime.now();
    if (_currentDate.isBefore(DateTime(now.year, now.month))) {
      setState(() {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      });
    }
  }

  // 月の名前を取得
  String _getMonthName(int month) {
    const months = [
      '1月',
      '2月',
      '3月',
      '4月',
      '5月',
      '6月',
      '7月',
      '8月',
      '9月',
      '10月',
      '11月',
      '12月',
    ];
    return months[month - 1];
  }

  // 累積稼働時間を計算
  Map<String, int> _calculateCumulativeHours(DateTime targetDate) {
    int totalHours = 0;
    int totalMinutes = 0;

    // データがある最も古い月から対象月までループ
    DateTime currentMonth = _oldestDate;

    while (currentMonth.isBefore(targetDate) ||
        (currentMonth.year == targetDate.year &&
            currentMonth.month == targetDate.month)) {
      final key = '${currentMonth.year}-${currentMonth.month}';
      final monthData = _monthlyData[key];

      if (monthData != null) {
        totalHours += monthData['hours'] as int;
        totalMinutes += monthData['minutes'] as int;
      }

      // 次の月へ
      if (currentMonth.month == 12) {
        currentMonth = DateTime(currentMonth.year + 1, 1);
      } else {
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      }
    }

    // 分を時間に変換
    totalHours += totalMinutes ~/ 60;
    totalMinutes = totalMinutes % 60;

    return {'hours': totalHours, 'minutes': totalMinutes};
  }

  // サンプルデータを取得（実際のアプリでは API やデータベースから取得）
  List<Map<String, dynamic>> _getUsageData() {
    final key = '${_currentDate.year}-${_currentDate.month}';
    final monthData = _monthlyData[key];

    // その月のデータ
    final hours = monthData?['hours'] ?? 0;
    final minutes = monthData?['minutes'] ?? 0;
    final days = monthData?['days'] ?? 0;

    // 累積稼働時間を計算
    final cumulative = _calculateCumulativeHours(_currentDate);

    return [
      {
        'icon': Icons.access_time,
        'label': '稼働時間',
        'value': '${hours}時間${minutes}分',
        'type': 'text',
      },
      {
        // 日数
        'icon': Icons.event,
        'label': '稼働日数',
        'value': '${days}日',
        'type': 'text',
      },
      {
        'icon': Icons.trending_up,
        'label': '累積稼働時間',
        'value': '${cumulative['hours']}時間${cumulative['minutes']}分',
        'type': 'text',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final canGoBack = _currentDate.isAfter(_oldestDate);
    final canGoForward = _currentDate.isBefore(DateTime(now.year, now.month));
    final usageData = _getUsageData();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 300,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 月選択ヘッダー
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左矢印
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: canGoBack ? _goToPreviousMonth : null,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: canGoBack ? Colors.black87 : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: textPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentDate.year}年${_getMonthName(_currentDate.month)}',
                      style: AppTextStyles.h6,
                    ),
                  ],
                ),

                // 右矢印
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: canGoForward ? _goToNextMonth : null,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: canGoForward ? Colors.black87 : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 稼働実績項目
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 各項目を表示
                for (int i = 0; i < usageData.length; i++)
                  _buildUsageItem(usageData[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(Map<String, dynamic> item) {
    final IconData icon = item['icon'];
    final String label = item['label'];
    final String? value = item['value'];
    final String type = item['type'];
    final IconData? actionIcon = item['actionIcon'];

    return Container(
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
        ),
      ),
      child: InkWell(
        onTap: type == 'action'
            ? () {
                // 請求書のタップ処理をここに実装
                _onInvoiceTap();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
          child: Row(
            children: [
              // アイコン
              Icon(icon, color: textPrimary, size: 24),

              const SizedBox(width: 16),

              // ラベル
              Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),

              // 値または矢印アイコン
              if (type == 'text' && value != null) ...[
                Text(value, style: AppTextStyles.bodyMedium),
              ] else if (type == 'action' && actionIcon != null) ...[
                Icon(actionIcon, color: textSecondary, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onInvoiceTap() {
    // 請求書タップ時の処理
    // 例：請求書画面へ遷移、PDFダウンロードなど
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('請求書を表示します'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
