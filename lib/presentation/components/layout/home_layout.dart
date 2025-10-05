import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/constants/app_text_styles.dart';
import '../buttons/tile_button.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({
    super.key,
    this.onTilePressed,
    this.onIconPressed,
    this.backgroundImage,
    this.displayDate,
  });

  final textStyle = AppTextStyles.bodyMedium.copyWith(color: textPrimary);

  final Function(String)? onTilePressed;
  final Function(String)? onIconPressed;
  final String? backgroundImage;
  final DateTime? displayDate;

  String _getFormattedDate() {
    final now = displayDate ?? DateTime.now();
    final weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    final weekday = weekdays[now.weekday - 1];
    return '${now.year}年${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日($weekday)';
  }

  String _getTimeRange() {
    return '9:00 〜 18:00';
  }

  String _getStaffName() {
    return '担当：田中太郎';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: DefaultTextStyle(
            style: textStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSection(),
                _buildTimeSection(),
                _buildStaffSection(),
                const SizedBox(height: 8),
                _buildIconButtonsRow(),
                const SizedBox(height: 8),
                _buildNewsSection(),
                const SizedBox(height: 16),
                Expanded(child: _buildTileButtonsGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Text(_getFormattedDate());
  }

  Widget _buildTimeSection() {
    return Text(_getTimeRange());
  }

  Widget _buildStaffSection() {
    return Text(_getStaffName());
  }

  Widget _buildIconButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIconButton(
          icon: Icons.place,
          label: '利用場所',
          onPressed: () => onIconPressed?.call('location'),
        ),
        const SizedBox(width: 12),
        _buildIconButton(
          // documents
          icon: Icons.description_outlined,
          label: 'サービス内容',
          onPressed: () => onIconPressed?.call('service'),
        ),
        const SizedBox(width: 12),
        _buildIconButton(
          // 予約変更 icon
          icon: Icons.edit_calendar,
          label: '変更・キャンセル',
          onPressed: () => onIconPressed?.call('schedule_detail'), // 詳細画面直接表示
        ),
        // const SizedBox(width: 12),
        // _buildIconButton(
        //   // 予約変更 icon
        //   icon: Icons.check_circle,
        //   label: '完了報告',
        //   onPressed: () => onIconPressed?.call('review'), // 詳細画面直接表示
        // ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundDefault,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: AppDimensions.shadowSmall,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: textAccent, size: 24),
      ),
    );
  }

  Widget _buildNewsSection() {
    // Expanded にしたい
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('お知らせ'), Text('新しいサービスがリリースされました。詳細はアプリ内でご確認ください。')],
      ),
    );
  }

  Widget _buildTileButtonsGrid() {
    final tiles = [
      {
        'title': 'Schedule',
        'subtitle': '予定の確認と変更',
        'icon': Icons.calendar_month,
        'key': 'schedule_list', // 一覧表示用のキー
      },
      {
        'title': 'Review',
        'subtitle': '実施の確認と評価',
        'icon': Icons.check_circle,
        'key': 'review',
      },
      {
        'title': 'Service',
        'subtitle': 'サービス内容詳細',
        'icon': Icons.cleaning_services,
        'key': 'service',
      },
      {
        'title': 'Coordinator',
        'subtitle': '担当コーディネーター',
        'icon': Icons.support_agent,
        'key': 'coordinator',
      },
    ];

    return MasonryGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      itemCount: tiles.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final tile = tiles[index];
        return TileButton(
          title: tile['title'] as String,
          subtitle: tile['subtitle'] as String,
          icon: tile['icon'] as IconData,
          onPressed: () => onTilePressed?.call(tile['key'] as String),
        );
      },
    );
  }
}
