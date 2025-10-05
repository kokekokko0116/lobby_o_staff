import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../components/buttons/tile_button.dart';
import '../../../core/constants/app_images.dart';

class CoordinatorBottomSheet extends StatefulWidget {
  const CoordinatorBottomSheet({super.key});

  @override
  State<CoordinatorBottomSheet> createState() => _CoordinatorBottomSheetState();
}

class _CoordinatorBottomSheetState extends State<CoordinatorBottomSheet> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // パララックス効果の計算
    double imageOffset = _scrollOffset * 0.5;
    double overlayOpacity = (_scrollOffset / 300).clamp(0.0, 0.7);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: Stack(
        children: [
          // 背景画像
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.authBackground),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    debugPrint('Background image loading failed: $error');
                  },
                ),
              ),
            ),
          ),

          // スタッフ画像（パララックス効果）
          Positioned.fill(
            child: Image.asset(AppImages.staffSample, fit: BoxFit.cover),
          ),

          // グラデーションオーバーレイ（スクロールで濃くなる）
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3 + overlayOpacity),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // スクロール可能なコンテンツ
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 上部の余白（画像表示用）
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),

                // コンテンツエリア
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '田中 太郎',
                        style: AppTextStyles.h4.copyWith(color: textOnPrimary),
                      ),

                      SizedBox(height: 24),
                      Text(
                        '【ひとこと】',
                        style: AppTextStyles.h6.copyWith(color: textOnPrimary),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'お客様一人ひとりに寄り添い、最適なサービスを提案いたします。何でもお気軽にご相談ください！',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: textOnPrimary,
                        ),
                      ),

                      SizedBox(height: 32),

                      Text(
                        '【略歴】',
                        style: AppTextStyles.h6.copyWith(color: textOnPrimary),
                      ),
                      SizedBox(height: 16),

                      _buildCareerItem('2018年', '○○大学経済学部卒業'),
                      _buildCareerItem('2018年', '当社入社、営業部配属'),
                      _buildCareerItem('2020年', 'カスタマーサポート部へ異動'),
                      _buildCareerItem('2022年', 'コーディネーター認定取得'),
                      _buildCareerItem('2023年', 'チームリーダーに昇格'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerItem(String year, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year,
            style: AppTextStyles.bodyMedium.copyWith(color: textOnPrimary),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.bodyLarge.copyWith(color: textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
