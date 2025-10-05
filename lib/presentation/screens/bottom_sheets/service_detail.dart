import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../components/buttons/tile_button.dart';
import '../../../core/constants/app_images.dart';
import 'package:intl/intl.dart';

// 拡充されたサンプルデータのモデルクラス
class ServiceDetailItem {
  final String title;
  final int duration; // 所要時間（分）
  final List<String> locationImages; // 場所の画像配列
  final List<String> toolImages; // 掃除道具の画像配列
  final String description; // 作業内容の詳細説明
  final List<String> tasks; // 具体的な作業内容リスト
  final List<String> cautions; // 注意点リスト
  final List<CleaningTool> cleaningTools; // 必要な掃除道具リスト
  final String updatedAt; // 更新日

  ServiceDetailItem({
    required this.title,
    required this.duration,
    required this.locationImages,
    required this.toolImages,
    required this.description,
    required this.tasks,
    required this.cautions,
    required this.cleaningTools,
    required this.updatedAt,
  });
}

// 掃除道具のモデルクラス
class CleaningTool {
  final String name;
  final String description;
  final bool isRequired; // 必須かどうか

  CleaningTool({
    required this.name,
    required this.description,
    this.isRequired = true,
  });
}

// 画像スライダーウィジェット
class ImageSlider extends StatefulWidget {
  final List<String> images;
  final String title;

  const ImageSlider({super.key, required this.images, required this.title});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.h6?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(widget.images[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              // インジケーター
              if (widget.images.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.asMap().entries.map((entry) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              // ナビゲーション矢印
              // if (widget.images.length > 1) ...[
              //   // 左矢印
              //   Positioned(
              //     left: 8,
              //     top: 0,
              //     bottom: 0,
              //     child: Center(
              //       child: Container(
              //         width: 32,
              //         height: 32,
              //         decoration: BoxDecoration(
              //           color: Colors.black.withOpacity(0.5),
              //           shape: BoxShape.circle,
              //         ),
              //         child: IconButton(
              //           icon: Icon(
              //             Icons.chevron_left,
              //             color: Colors.white,
              //             size: 16,
              //           ),
              //           onPressed: _currentIndex > 0
              //               ? () {
              //                   _pageController.previousPage(
              //                     duration: Duration(milliseconds: 300),
              //                     curve: Curves.easeInOut,
              //                   );
              //                 }
              //               : null,
              //           padding: EdgeInsets.zero,
              //         ),
              //       ),
              //     ),
              //   ),
              //   // 右矢印
              //   Positioned(
              //     right: 8,
              //     top: 0,
              //     bottom: 0,
              //     child: Center(
              //       child: Container(
              //         width: 32,
              //         height: 32,
              //         decoration: BoxDecoration(
              //           color: Colors.black.withOpacity(0.5),
              //           shape: BoxShape.circle,
              //         ),
              //         child: IconButton(
              //           icon: Icon(
              //             Icons.chevron_right,
              //             color: Colors.white,
              //             size: 16,
              //           ),
              //           onPressed: _currentIndex < widget.images.length - 1
              //               ? () {
              //                   _pageController.nextPage(
              //                     duration: Duration(milliseconds: 300),
              //                     curve: Curves.easeInOut,
              //                   );
              //                 }
              //               : null,
              //           padding: EdgeInsets.zero,
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ],
    );
  }
}

// 詳細画面のウィジェット
class ServiceItemDetailPage extends StatelessWidget {
  final ServiceDetailItem item;
  final int index;

  const ServiceItemDetailPage({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${item.title}',
          style: AppTextStyles.h5?.copyWith(color: textOnPrimary),
        ),
        backgroundColor: backgroundAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 場所の画像スライダー
            ImageSlider(images: item.locationImages, title: '作業場所'),
            SizedBox(height: 16),
            Row(
              children: [
                // 所要時間
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: backgroundAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '所要時間：${item.duration}分',
                    style: AppTextStyles.bodySmall?.copyWith(
                      color: textAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // 更新日
                ),
                SizedBox(width: 16),
                Text(
                  '最終更新日：${(item.updatedAt)}',
                  style: AppTextStyles.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // 作業内容の説明
            Text(
              '作業内容',
              style: AppTextStyles.h6?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),
            ...item.tasks
                .map(
                  (task) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(task, style: AppTextStyles.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            SizedBox(height: 20),

            // 注意点
            Text(
              '注意点',
              style: AppTextStyles.h6?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...item.cautions
                .map(
                  (caution) => Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, size: 16, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(caution, style: AppTextStyles.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            SizedBox(height: 20),

            // 掃除道具の画像スライダー
            if (item.toolImages.isNotEmpty) ...[
              ImageSlider(images: item.toolImages, title: '使用する掃除道具'),
              SizedBox(height: 20),
            ],

            // 必要な掃除道具
            Text(
              '必要な掃除道具一覧',
              style: AppTextStyles.h6?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...item.cleaningTools
                .map(
                  (tool) => Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        tool.isRequired ? Icons.build : Icons.build_outlined,
                        color: tool.isRequired ? backgroundAccent : Colors.grey,
                      ),
                      title: Row(
                        children: [
                          Text(
                            tool.name,
                            style: AppTextStyles.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (tool.isRequired) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '必須',
                                style: AppTextStyles.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        tool.description,
                        style: AppTextStyles.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class ServiceDetailBottomSheet extends StatefulWidget {
  const ServiceDetailBottomSheet({super.key});

  @override
  State<ServiceDetailBottomSheet> createState() =>
      _ServiceDetailBottomSheetState();
}

class _ServiceDetailBottomSheetState extends State<ServiceDetailBottomSheet> {
  // 家事代行サービス向けのサンプルデータ
  final List<ServiceDetailItem> ServiceDetailItems = [
    ServiceDetailItem(
      title: 'リビングルーム清掃',
      duration: 45,
      locationImages: [
        'assets/images/local/bedroom.jpeg',
        'assets/images/local/kitchen.jpeg',
        'assets/images/local/toilet.jpeg',
      ],
      toolImages: [
        'assets/images/local/cleaner.jpg',
        'assets/images/local/splay.jpg',
        'assets/images/local/cloth.jpg',
      ],
      description:
          'リビングルーム全体の清掃を行います。家具の配置を確認し、ソファや テーブル周りの掃除機がけ、拭き掃除を丁寧に実施します。',
      tasks: [
        'ソファクッションの掃除機がけ',
        'テーブル・TV台の拭き掃除',
        'フローリングの掃除機がけ・モップ掛け',
        '窓ガラス・窓枠の清拭',
        '照明器具のホコリ取り',
        'リモコン類の除菌清拭',
      ],
      cautions: [
        '貴重品や壊れやすい装飾品には触れないよう注意',
        '電子機器の清拭時は電源を切ってから実施',
        'ソファの材質を確認してから適切な清掃方法を選択',
        '窓清拭時は足場の安全を確保',
      ],
      cleaningTools: [
        CleaningTool(
          name: '掃除機',
          description: 'コードレス式、ソファ用ノズル付き',
          isRequired: true,
        ),
        CleaningTool(
          name: 'マイクロファイバークロス',
          description: '乾拭き・水拭き用（複数枚）',
          isRequired: true,
        ),
        CleaningTool(
          name: '中性洗剤スプレー',
          description: '家具・床用クリーナー',
          isRequired: true,
        ),
        CleaningTool(name: 'フロアモップ', description: 'フローリング用', isRequired: true),
        CleaningTool(name: 'ハンディモップ', description: '照明・高所用', isRequired: false),
      ],
      updatedAt: DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
    ),
    ServiceDetailItem(
      title: 'キッチン清掃',
      duration: 60,
      locationImages: [
        'assets/images/local/bedroom.jpeg',
        'assets/images/local/kitchen.jpeg',
        'assets/images/local/toilet.jpeg',
      ],
      toolImages: [
        'assets/images/local/splay.jpg',
        'assets/images/local/cloth.jpg',
        'assets/images/local/cleaner.jpg',
      ],
      description: 'キッチン全体の清掃と除菌を行います。シンク、コンロ、調理台の汚れ落としと、冷蔵庫や電子レンジの清拭を実施します。',
      tasks: [
        'シンクの洗浄・水垢除去',
        'コンロ・グリルの油汚れ清掃',
        '調理台・カウンターの除菌清拭',
        '冷蔵庫外側の清拭',
        '電子レンジ内外の清掃',
        '食器棚扉の清拭',
        '床の清掃・モップ掛け',
      ],
      cautions: [
        'ガスの元栓が閉まっていることを確認',
        '電子機器は電源を切ってから清掃',
        '強力な洗剤使用時は換気を十分に',
        '食材や調味料には触れない',
        '排水口清掃時は手袋着用必須',
      ],
      cleaningTools: [
        CleaningTool(
          name: 'キッチンスポンジセット',
          description: '研磨面付き、交換用複数個',
          isRequired: true,
        ),
        CleaningTool(
          name: 'キッチン用洗剤',
          description: '油汚れ用・除菌用',
          isRequired: true,
        ),
        CleaningTool(
          name: 'ゴム手袋',
          description: '耐薬品性、使い捨てタイプ',
          isRequired: true,
        ),
        CleaningTool(name: '水垢除去剤', description: 'シンク・蛇口用', isRequired: true),
        CleaningTool(
          name: 'マイクロファイバークロス',
          description: 'キッチン専用',
          isRequired: true,
        ),
      ],
      updatedAt: DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
    ),
    ServiceDetailItem(
      title: 'バスルーム清掃',
      duration: 50,
      locationImages: [
        'assets/images/local/bedroom.jpeg',
        'assets/images/local/kitchen.jpeg',
        'assets/images/local/toilet.jpeg',
      ],
      toolImages: [
        'assets/images/local/splay.jpg',
        'assets/images/local/cloth.jpg',
        'assets/images/local/cleaner.jpg',
      ],
      description: 'バスルーム全体の清掃と除菌、カビ予防を行います。浴槽、洗面台、トイレの清掃を衛生的に実施します。',
      tasks: [
        '浴槽の洗浄・水垢除去',
        'シャワーヘッド・蛇口の清掃',
        '洗面台・鏡の清拭',
        'トイレ便器・便座の除菌清掃',
        '床・壁タイルの清掃',
        '排水口の清掃',
        '換気扇フィルターの清拭',
      ],
      cautions: [
        '滑りやすいため足元に十分注意',
        '換気を十分に行いながら作業',
        '塩素系漂白剤使用時は他の洗剤と混ぜない',
        '電気製品への水の飛散に注意',
        '作業後は必ず換気扇を回す',
      ],
      cleaningTools: [
        CleaningTool(name: 'バスクリーナー', description: '浴槽・タイル用', isRequired: true),
        CleaningTool(
          name: 'トイレクリーナー',
          description: '除菌・消臭効果付き',
          isRequired: true,
        ),
        CleaningTool(name: 'カビ取り剤', description: '塩素系漂白剤', isRequired: true),
        CleaningTool(name: 'スクラブブラシ', description: '浴槽・タイル用', isRequired: true),
        CleaningTool(name: 'スクイージー', description: '鏡・ガラス用', isRequired: true),
        CleaningTool(name: '使い捨て手袋', description: 'ニトリル製', isRequired: true),
      ],
      updatedAt: DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
    ),
    ServiceDetailItem(
      title: 'ベッドルーム清掃',
      duration: 35,
      locationImages: [
        'assets/images/local/bedroom.jpeg',
        'assets/images/local/kitchen.jpeg',
        'assets/images/local/toilet.jpeg',
      ],
      toolImages: [
        'assets/images/local/splay.jpg',
        'assets/images/local/cloth.jpg',
        'assets/images/local/cleaner.jpg',
      ],
      description: 'ベッドルームの清掃と整頓を行います。寝具の除菌、家具の拭き掃除、床の清掃を丁寧に実施します。',
      tasks: [
        'ベッドメイキング（シーツ交換は別料金）',
        'ベッドフレーム・マットレスの掃除機がけ',
        'ナイトテーブル・ドレッサーの拭き掃除',
        'クローゼット扉の清拭',
        'フローリング・カーペットの清掃',
        '窓際・窓枠の清拭',
        'エアコンフィルターの簡易清掃',
      ],
      cautions: [
        '個人の衣類や私物には触れない',
        'ベッドメイキング時は清潔な手で作業',
        'カーペット清掃時は材質を確認',
        'クローゼット内部は開けずに扉のみ清拭',
        '貴重品エリアには近づかない',
      ],
      cleaningTools: [
        CleaningTool(
          name: '布団クリーナー',
          description: 'UV除菌機能付き',
          isRequired: true,
        ),
        CleaningTool(
          name: 'フロアクリーナー',
          description: 'フローリング・カーペット対応',
          isRequired: true,
        ),
        CleaningTool(name: 'ダストモップ', description: '静電気除去タイプ', isRequired: true),
        CleaningTool(
          name: 'マイクロファイバークロス',
          description: '家具用',
          isRequired: true,
        ),
        CleaningTool(
          name: 'エアフレッシュナー',
          description: '無香料・除菌タイプ',
          isRequired: false,
        ),
      ],
      updatedAt: DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
    ),
    ServiceDetailItem(
      title: '全体仕上げ・点検',
      duration: 20,
      locationImages: [
        'assets/images/local/bedroom.jpeg',
        'assets/images/local/kitchen.jpeg',
        'assets/images/local/toilet.jpeg',
      ],
      toolImages: [
        'assets/images/local/cleaner.jpg',
        'assets/images/local/splay.jpg',
        'assets/images/local/cloth.jpg',
      ],
      description: '清掃作業の最終確認と仕上げを行います。見落としがないか全体をチェックし、道具の片付けを実施します。',
      tasks: [
        '各部屋の清掃状況の最終確認',
        '玄関・廊下の清掃',
        'ゴミの分別・まとめ',
        '使用した道具の清拭・片付け',
        'お客様への作業完了報告',
        '次回の提案・スケジュール確認',
      ],
      cautions: [
        '清掃漏れがないか入念にチェック',
        'ゴミの分別ルールを遵守',
        '道具は清潔な状態で片付ける',
        'お客様に不明点がないか確認',
        '次回訪問の約束は明確に',
      ],
      cleaningTools: [
        CleaningTool(name: 'チェックリスト', description: '作業確認用', isRequired: true),
        CleaningTool(
          name: '最終仕上げセット',
          description: '細部用クリーナー類',
          isRequired: true,
        ),
        CleaningTool(name: '道具収納ケース', description: '持ち運び用', isRequired: true),
        CleaningTool(name: 'ゴミ袋', description: '分別用（複数種類）', isRequired: true),
        CleaningTool(
          name: 'タブレット',
          description: '報告書作成・次回予約用',
          isRequired: false,
        ),
      ],
      // YYYY/MM/DD HH:MM の形式で更新日を設定
      updatedAt: DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(ServiceDetailItem item, int index) {
    // 詳細画面への遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceItemDetailPage(item: item, index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('詳細を見るには各項目をタップしてください。', style: AppTextStyles.bodyMedium),
          SizedBox(height: 12),
          Text('利用場所', style: AppTextStyles.labelMedium),
          Text('福岡市博多区冷泉町 2-34', style: AppTextStyles.h6),
          SizedBox(height: 12),
          Text('利用スケジュール', style: AppTextStyles.labelMedium),
          Text('火曜日 13:00〜14:00', style: AppTextStyles.h6),
          SizedBox(height: 12),
          Text('清掃手順と時間配分', style: AppTextStyles.labelMedium),
          SizedBox(height: 8),
          // 拡張可能なリスト
          Expanded(
            child: ListView.builder(
              itemCount: ServiceDetailItems.length,
              itemBuilder: (context, index) {
                final item = ServiceDetailItems[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    // 左側：画像と番号のオーバーレイ（配列の0番目を表示）
                    leading: Container(
                      width: 56,
                      height: 56,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 背景画像（locationImagesの0番目）
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  item.locationImages.isNotEmpty
                                      ? item.locationImages[0]
                                      : 'assets/images/local/default.jpeg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // 番号のオーバーレイ（左上）
                          Positioned(
                            top: -6,
                            left: -6,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: backgroundAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: AppTextStyles.labelSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 中央：タイトルと所要時間
                    title: Text(
                      item.title,
                      style: AppTextStyles.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '所要：${item.duration}分',
                      style: AppTextStyles.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    // 右側：矢印アイコン
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    // タップ処理
                    onTap: () => _onItemTapped(item, index),
                    // タップ時の視覚的フィードバック
                    // splashColor: AppColors.primary?.withOpacity(0.1),
                    // hoverColor: AppColors.primary?.withOpacity(0.05),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
