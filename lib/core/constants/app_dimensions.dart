import 'package:flutter/material.dart';

/// 【基礎定数】アプリ全体で使用するサイズ・間隔の定数クラス
/// 
/// 【役割】
/// - 生の数値定数の定義（4pxベースのデザインシステム）
/// - 基本的なEdgeInsetsとBorderRadiusの組み合わせの提供
/// - 他のファイル（spacing.dart、app_theme.dart）から参照される基礎データ
/// 
/// 【使用場面】
/// ✅ Container、Paddingウィジェットでのpadding/margin指定
/// ✅ DecorationでのborderRadius指定
/// ✅ カスタムウィジェット作成時の数値参照
/// 
/// 【使用例】
/// ```dart
/// // パディング指定
/// Container(
///   padding: AppDimensions.paddingAllMedium,
///   margin: AppDimensions.marginVerticalLarge,
///   child: Text('コンテンツ'),
/// )
/// 
/// // 角丸指定
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: AppDimensions.borderRadiusAllLarge,
///     boxShadow: AppDimensions.shadowMedium,
///   ),
/// )
/// 
/// // カスタムサイズ指定
/// SizedBox(
///   width: AppDimensions.space24,
///   height: AppDimensions.buttonHeightMedium,
/// )
/// ```
/// 
/// 【使い分け】
/// - レイアウト内での間隔 → spacing.dart のVerticalSpacing/HorizontalSpacingを使用
/// - テーマ統合スタイル → app_theme.dart のテーマ設定を使用
/// - 直接的な数値指定 → このAppDimensionsを使用
class AppDimensions {
  AppDimensions._();

  // 基本スペーシング（4pxベース）
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // パディング
  static const double paddingXSmall = space4;    // 4px
  static const double paddingSmall = space8;     // 8px
  static const double paddingMedium = space16;   // 16px
  static const double paddingLarge = space24;    // 24px
  static const double paddingXLarge = space32;   // 32px
  static const double paddingXXLarge = space48;  // 48px

  // マージン
  static const double marginXSmall = space4;     // 4px
  static const double marginSmall = space8;      // 8px
  static const double marginMedium = space16;    // 16px
  static const double marginLarge = space24;     // 24px
  static const double marginXLarge = space32;    // 32px
  static const double marginXXLarge = space48;   // 48px

  // ボーダー半径
  static const double borderRadiusXSmall = 2.0;
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  static const double borderRadiusXXLarge = 24.0;
  static const double borderRadiusCircular = 999.0;

  // ボーダー幅
  static const double borderWidthThin = 0.5;
  static const double borderWidthDefault = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthBold = 3.0;

  // アイコンサイズ
  static const double iconXSmall = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 64.0;

  // ボタン高さ
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 56.0;

  // インプット高さ
  static const double inputHeightSmall = 36.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;

  // コンポーネント固有のサイズ
  static const double appBarHeight = 56.0;
  static const double bottomNavigationHeight = 56.0;
  static const double tabBarHeight = 48.0;
  static const double listItemHeight = 56.0;
  static const double cardMinHeight = 64.0;
  static const double bottomSheetHeaderHeight = 56.0;

  // レスポンシブブレークポイント
  static const double mobileMaxWidth = 768.0;
  static const double tabletMaxWidth = 1024.0;
  static const double desktopMinWidth = 1025.0;

  // よく使用されるEdgeInsetsの組み合わせ
  static const EdgeInsets paddingAllXSmall = EdgeInsets.all(paddingXSmall);
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(paddingMedium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(paddingLarge);
  static const EdgeInsets paddingAllXLarge = EdgeInsets.all(paddingXLarge);

  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: paddingSmall);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: paddingMedium);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: paddingLarge);

  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: paddingSmall);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: paddingMedium);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: paddingLarge);

  // ページパディング（スクリーン全体）
  static const EdgeInsets pagePadding = EdgeInsets.all(paddingMedium);
  static const EdgeInsets pageHorizontalPadding = EdgeInsets.symmetric(horizontal: paddingMedium);

  // カードパディング
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingMedium);
  static const EdgeInsets cardContentPadding = EdgeInsets.all(paddingLarge);

  // リストアイテムパディング
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );

  // ボタンパディング
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );
  static const EdgeInsets buttonPaddingMedium = EdgeInsets.symmetric(
    horizontal: paddingLarge,
    vertical: paddingMedium,
  );
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: paddingXLarge,
    vertical: paddingLarge,
  );

  // インプットパディング
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: paddingMedium,
    vertical: paddingSmall,
  );

  // モーダル・ダイアログパディング
  static const EdgeInsets dialogPadding = EdgeInsets.all(paddingLarge);
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(paddingMedium);

  // よく使用されるBorderRadiusの組み合わせ
  static const BorderRadius borderRadiusAllSmall = BorderRadius.all(Radius.circular(borderRadiusSmall));
  static const BorderRadius borderRadiusAllMedium = BorderRadius.all(Radius.circular(borderRadiusMedium));
  static const BorderRadius borderRadiusAllLarge = BorderRadius.all(Radius.circular(borderRadiusLarge));
  static const BorderRadius borderRadiusAllXLarge = BorderRadius.all(Radius.circular(borderRadiusXLarge));

  // 上部のみの角丸（ボトムシートなど）
  static const BorderRadius borderRadiusTopMedium = BorderRadius.only(
    topLeft: Radius.circular(borderRadiusMedium),
    topRight: Radius.circular(borderRadiusMedium),
  );
  static const BorderRadius borderRadiusTopLarge = BorderRadius.only(
    topLeft: Radius.circular(borderRadiusLarge),
    topRight: Radius.circular(borderRadiusLarge),
  );

  // シャドウ
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x0A000000), // 4% opacity
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x0F000000), // 6% opacity
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowXLarge = [
    BoxShadow(
      color: Color(0x19000000), // 10% opacity
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // エレベーション（マテリアルデザイン準拠）
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;
}