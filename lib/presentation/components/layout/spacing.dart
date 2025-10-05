import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

/// 【UIコンポーネント】アプリ全体で使用する間隔コンポーネント
/// 
/// 【役割】
/// - レイアウト内で直接使用できるWidgetベースのスペーシング
/// - Column/Row内での要素間の間隔調整
/// - パディング・マージン用のヘルパークラス
/// 
/// 【使用場面】
/// ✅ Column/Rowの子要素間での間隔指定
/// ✅ Paddingウィジェットでの定型的なパディング指定
/// ✅ Containerでの定型的なマージン指定
/// 
/// 【使用例】
/// ```dart
/// // Column内での間隔
/// Column(
///   children: [
///     Text('タイトル'),
///     VerticalSpacing.medium,  // 16px の間隔
///     Text('内容'),
///     VerticalSpacing.large,   // 24px の間隔
///     ElevatedButton(onPressed: () {}, child: Text('ボタン')),
///   ],
/// )
/// 
/// // Row内での間隔
/// Row(
///   children: [
///     Icon(Icons.star),
///     HorizontalSpacing.small,  // 8px の間隔
///     Text('評価'),
///     FlexibleSpacing.expanded, // 余白を埋める
///     Text('5.0'),
///   ],
/// )
/// 
/// // 定型的なパディング
/// Padding(
///   padding: AppPadding.allMedium,  // 16px の全方向パディング
///   child: Card(...),
/// )
/// ```
/// 
/// 【使い分け】
/// - 直接的な数値指定 → app_dimensions.dart のAppDimensionsを使用
/// - テーマ統合スタイル → app_theme.dart のテーマ設定を使用
/// - レイアウト内での間隔 → このファイルのコンポーネントを使用

// ===== 間隔ウィジェット =====

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing._(this.height);
  
  final double height;

  // 基本的な縦間隔
  static const VerticalSpacing xSmall = VerticalSpacing._(AppDimensions.space4);
  static const VerticalSpacing small = VerticalSpacing._(AppDimensions.space8);
  static const VerticalSpacing medium = VerticalSpacing._(AppDimensions.space16);
  static const VerticalSpacing large = VerticalSpacing._(AppDimensions.space24);
  static const VerticalSpacing xLarge = VerticalSpacing._(AppDimensions.space32);
  static const VerticalSpacing xxLarge = VerticalSpacing._(AppDimensions.space48);

  // カスタムサイズ（keyパラメータを削除）
  const VerticalSpacing.custom(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing._(this.width);
  
  final double width;

  // 基本的な横間隔
  static const HorizontalSpacing xSmall = HorizontalSpacing._(AppDimensions.space4);
  static const HorizontalSpacing small = HorizontalSpacing._(AppDimensions.space8);
  static const HorizontalSpacing medium = HorizontalSpacing._(AppDimensions.space16);
  static const HorizontalSpacing large = HorizontalSpacing._(AppDimensions.space24);
  static const HorizontalSpacing xLarge = HorizontalSpacing._(AppDimensions.space32);
  static const HorizontalSpacing xxLarge = HorizontalSpacing._(AppDimensions.space48);

  // カスタムサイズ（keyパラメータを削除）
  const HorizontalSpacing.custom(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class FlexibleSpacing extends StatelessWidget {
  const FlexibleSpacing({
    super.key,
    this.flex = 1,
  });
  
  final int flex;

  static const FlexibleSpacing expanded = FlexibleSpacing();
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: const SizedBox(),
    );
  }
}

// ===== ヘルパークラス =====

/// パディング用のヘルパークラス
/// 
/// 【用途】
/// - Paddingウィジェットでの定型的なパディング指定
/// - Containerでのpadding指定
/// 
/// 【使用例】
/// ```dart
/// Padding(
///   padding: AppPadding.allMedium,    // 全方向に16px
///   child: Text('コンテンツ'),
/// )
/// 
/// Container(
///   padding: AppPadding.horizontalLarge,  // 左右に24px
///   child: Column(...),
/// )
/// ```
class AppPadding {
  AppPadding._();

  // 全方向パディング
  static const EdgeInsets allXSmall = AppDimensions.paddingAllXSmall;
  static const EdgeInsets allSmall = AppDimensions.paddingAllSmall;
  static const EdgeInsets allMedium = AppDimensions.paddingAllMedium;
  static const EdgeInsets allLarge = AppDimensions.paddingAllLarge;
  static const EdgeInsets allXLarge = AppDimensions.paddingAllXLarge;

  // 水平方向パディング
  static const EdgeInsets horizontalXSmall = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXSmall);
  static const EdgeInsets horizontalSmall = AppDimensions.paddingHorizontalSmall;
  static const EdgeInsets horizontalMedium = AppDimensions.paddingHorizontalMedium;
  static const EdgeInsets horizontalLarge = AppDimensions.paddingHorizontalLarge;
  static const EdgeInsets horizontalXLarge = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge);

  // 垂直方向パディング
  static const EdgeInsets verticalXSmall = EdgeInsets.symmetric(vertical: AppDimensions.paddingXSmall);
  static const EdgeInsets verticalSmall = AppDimensions.paddingVerticalSmall;
  static const EdgeInsets verticalMedium = AppDimensions.paddingVerticalMedium;
  static const EdgeInsets verticalLarge = AppDimensions.paddingVerticalLarge;
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: AppDimensions.paddingXLarge);

  // 特定用途のパディング
  static const EdgeInsets page = AppDimensions.pagePadding;
  static const EdgeInsets pageHorizontal = AppDimensions.pageHorizontalPadding;
  static const EdgeInsets card = AppDimensions.cardPadding;
  static const EdgeInsets cardContent = AppDimensions.cardContentPadding;
  static const EdgeInsets listItem = AppDimensions.listItemPadding;
  static const EdgeInsets button = AppDimensions.buttonPaddingMedium;
  static const EdgeInsets input = AppDimensions.inputPadding;
  static const EdgeInsets dialog = AppDimensions.dialogPadding;
  static const EdgeInsets bottomSheet = AppDimensions.bottomSheetPadding;

  // よく使用される非対称パディング
  static const EdgeInsets topMedium = EdgeInsets.only(top: AppDimensions.paddingMedium);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: AppDimensions.paddingMedium);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: AppDimensions.paddingMedium);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: AppDimensions.paddingMedium);

  static const EdgeInsets topLarge = EdgeInsets.only(top: AppDimensions.paddingLarge);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: AppDimensions.paddingLarge);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: AppDimensions.paddingLarge);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: AppDimensions.paddingLarge);
}

/// マージン用のヘルパークラス
/// 
/// 【用途】
/// - Containerでのmargin指定
/// - ウィジェット間の外側の間隔調整
/// 
/// 【使用例】
/// ```dart
/// Container(
///   margin: AppMargin.verticalMedium,  // 上下に16px
///   child: Card(...),
/// )
/// 
/// Container(
///   margin: AppMargin.bottomLarge,     // 下に24px
///   child: Text('最後の要素'),
/// )
/// ```
class AppMargin {
  AppMargin._();

  // 全方向マージン
  static const EdgeInsets allXSmall = EdgeInsets.all(AppDimensions.marginXSmall);
  static const EdgeInsets allSmall = EdgeInsets.all(AppDimensions.marginSmall);
  static const EdgeInsets allMedium = EdgeInsets.all(AppDimensions.marginMedium);
  static const EdgeInsets allLarge = EdgeInsets.all(AppDimensions.marginLarge);
  static const EdgeInsets allXLarge = EdgeInsets.all(AppDimensions.marginXLarge);

  // 水平方向マージン
  static const EdgeInsets horizontalXSmall = EdgeInsets.symmetric(horizontal: AppDimensions.marginXSmall);
  static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: AppDimensions.marginSmall);
  static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: AppDimensions.marginMedium);
  static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: AppDimensions.marginLarge);
  static const EdgeInsets horizontalXLarge = EdgeInsets.symmetric(horizontal: AppDimensions.marginXLarge);

  // 垂直方向マージン
  static const EdgeInsets verticalXSmall = EdgeInsets.symmetric(vertical: AppDimensions.marginXSmall);
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: AppDimensions.marginSmall);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: AppDimensions.marginMedium);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: AppDimensions.marginLarge);
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: AppDimensions.marginXLarge);

  // よく使用される非対称マージン
  static const EdgeInsets topMedium = EdgeInsets.only(top: AppDimensions.marginMedium);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: AppDimensions.marginMedium);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: AppDimensions.marginMedium);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: AppDimensions.marginMedium);

  static const EdgeInsets topLarge = EdgeInsets.only(top: AppDimensions.marginLarge);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: AppDimensions.marginLarge);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: AppDimensions.marginLarge);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: AppDimensions.marginLarge);
}

/// ボーダー半径用のヘルパークラス
/// 
/// 【用途】
/// - ContainerのDecorationでのborderRadius指定
/// - カスタムウィジェットでの角丸設定
/// 
/// 【使用例】
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: AppBorderRadius.large,  // 12px の角丸
///     boxShadow: AppDimensions.shadowMedium,
///   ),
///   child: Text('カード'),
/// )
/// 
/// ClipRRect(
///   borderRadius: AppBorderRadius.topLarge,  // 上部のみ角丸
///   child: Image.network(url),
/// )
/// ```
class AppBorderRadius {
  AppBorderRadius._();

  // 基本的な角丸
  static const BorderRadius xSmall = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusXSmall));
  static const BorderRadius small = AppDimensions.borderRadiusAllSmall;
  static const BorderRadius medium = AppDimensions.borderRadiusAllMedium;
  static const BorderRadius large = AppDimensions.borderRadiusAllLarge;
  static const BorderRadius xLarge = AppDimensions.borderRadiusAllXLarge;
  static const BorderRadius xxLarge = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusXXLarge));
  static const BorderRadius circular = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusCircular));

  // 特定方向の角丸
  static const BorderRadius topMedium = AppDimensions.borderRadiusTopMedium;
  static const BorderRadius topLarge = AppDimensions.borderRadiusTopLarge;

  static const BorderRadius bottomMedium = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimensions.borderRadiusMedium),
    bottomRight: Radius.circular(AppDimensions.borderRadiusMedium),
  );

  static const BorderRadius bottomLarge = BorderRadius.only(
    bottomLeft: Radius.circular(AppDimensions.borderRadiusLarge),
    bottomRight: Radius.circular(AppDimensions.borderRadiusLarge),
  );

  static const BorderRadius leftMedium = BorderRadius.only(
    topLeft: Radius.circular(AppDimensions.borderRadiusMedium),
    bottomLeft: Radius.circular(AppDimensions.borderRadiusMedium),
  );

  static const BorderRadius rightMedium = BorderRadius.only(
    topRight: Radius.circular(AppDimensions.borderRadiusMedium),
    bottomRight: Radius.circular(AppDimensions.borderRadiusMedium),
  );
}