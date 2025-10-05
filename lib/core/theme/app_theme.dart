import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

/// 【テーマ統合】アプリ全体のテーマ設定クラス
///
/// 【役割】
/// - FlutterのThemeDataと既存のデザインシステムの統合
/// - 全コンポーネントの統一されたデザイン適用
/// - Material 3準拠のテーマ設定
/// - Google Fonts (Inter + Noto Sans JP) による統一タイポグラフィ
///
/// 【使用場面】
/// ✅ MaterialAppでのテーマ設定
/// ✅ ThemeDataを使用する全てのMaterialウィジェット
/// ✅ アプリ全体の一貫したデザイン適用
///
/// 【使用例】
/// ```dart
/// // メインアプリでのテーマ設定
/// MaterialApp(
///   theme: AppTheme.lightTheme,     // ライトテーマ
///   darkTheme: AppTheme.darkTheme,  // ダークテーマ（今後実装）
///   home: HomePage(),
/// )
///
/// // テーマの値を取得
/// final theme = Theme.of(context);
/// Container(
///   color: theme.colorScheme.surface,    // テーマから色を取得
///   padding: theme.cardTheme.margin,     // テーマからサイズを取得
/// )
///
/// // カスタム拡張の使用
/// Container(
///   decoration: BoxDecoration(
///     color: theme.surfaceColor,         // カスタムカラー
///     borderRadius: theme.cardRadius,    // カスタム角丸
///     boxShadow: theme.mediumShadow,     // カスタムシャドウ
///   ),
/// )
/// ```
///
/// 【自動適用されるコンポーネント】
/// - ElevatedButton, OutlinedButton, TextButton
/// - TextField, TextFormField
/// - Card, ListTile
/// - AppBar, BottomNavigationBar
/// - Dialog, BottomSheet
/// - など、すべてのMaterialウィジェット
///
/// 【使い分け】
/// - 基礎的な数値指定 → app_dimensions.dart のAppDimensionsを使用
/// - レイアウト内での間隔 → spacing.dart のコンポーネントを使用
/// - テーマ統合スタイル → このAppThemeを使用（自動適用）
class AppTheme {
  AppTheme._();

  // ライトテーマ
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // カラースキーム
    colorScheme: const ColorScheme.light(
      primary: buttonPrimary,
      secondary: buttonAccent,
      surface: backgroundSurface,
      error: textError,
      onPrimary: textOnPrimary,
      onSecondary: textOnPrimary,
      onSurface: textPrimary,
      onError: textOnPrimary,
      outline: borderPrimary,
      outlineVariant: borderMuted,
    ),

    // スキャフォールド
    scaffoldBackgroundColor: backgroundSurface,

    // ページ遷移アニメーション
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeTransitionBuilder(),
        TargetPlatform.iOS: FadeTransitionBuilder(),
        TargetPlatform.linux: FadeTransitionBuilder(),
        TargetPlatform.macOS: FadeTransitionBuilder(),
        TargetPlatform.windows: FadeTransitionBuilder(),
      },
    ),

    // アプリバー
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDefault,
      foregroundColor: textPrimary,
      elevation: AppDimensions.elevationSmall,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimary),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarHeight: AppDimensions.appBarHeight,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: AppDimensions.iconMedium,
      ),
    ),

    // ボタンテーマ
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonPrimary,
        foregroundColor: textOnPrimary,
        textStyle: AppTextStyles.buttonMedium,
        padding: AppDimensions.buttonPaddingMedium,
        minimumSize: const Size(0, AppDimensions.buttonHeightMedium),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusAllMedium,
        ),
        elevation: AppDimensions.elevationSmall,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonPrimary,
        textStyle: AppTextStyles.buttonMedium,
        padding: AppDimensions.buttonPaddingMedium,
        minimumSize: const Size(0, AppDimensions.buttonHeightMedium),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusAllMedium,
        ),
        side: const BorderSide(
          color: borderPrimary,
          width: AppDimensions.borderWidthDefault,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: buttonPrimary,
        textStyle: AppTextStyles.buttonMedium,
        padding: AppDimensions.buttonPaddingMedium,
        minimumSize: const Size(0, AppDimensions.buttonHeightMedium),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusAllMedium,
        ),
      ),
    ),

    // フローティングアクションボタン
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: buttonAccent,
      foregroundColor: textOnPrimary,
      elevation: AppDimensions.elevationMedium,
      shape: CircleBorder(),
    ),

    // インプットテーマ
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundDefault,
      contentPadding: AppDimensions.inputPadding,
      border: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        borderSide: const BorderSide(
          color: borderPrimary,
          width: AppDimensions.borderWidthDefault,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        borderSide: const BorderSide(
          color: borderPrimary,
          width: AppDimensions.borderWidthDefault,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        borderSide: const BorderSide(
          color: borderFocus,
          width: AppDimensions.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        borderSide: const BorderSide(
          color: borderError,
          width: AppDimensions.borderWidthDefault,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
        borderSide: const BorderSide(
          color: borderError,
          width: AppDimensions.borderWidthThick,
        ),
      ),
      labelStyle: AppTextStyles.inputLabelPrimary,
      hintStyle: AppTextStyles.inputText.copyWith(color: textDisabled),
      errorStyle: AppTextStyles.inputErrorStyle,
      helperStyle: AppTextStyles.inputHelperStyle,
    ),

    // カードテーマ
    cardTheme: CardThemeData(
      color: backgroundDefault,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusAllLarge,
      ),
      margin: AppDimensions.paddingAllSmall,
    ),

    // リストタイルテーマ
    listTileTheme: ListTileThemeData(
      contentPadding: AppDimensions.listItemPadding,
      minVerticalPadding: AppDimensions.paddingSmall,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
      ),
      titleTextStyle: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
      subtitleTextStyle: AppTextStyles.bodySmall.copyWith(color: textSecondary),
      iconColor: textSecondary,
    ),

    // ボトムナビゲーションテーマ
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundDefault,
      selectedItemColor: buttonAccent,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: AppDimensions.elevationMedium,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
    ),

    // タブバーテーマ
    tabBarTheme: TabBarThemeData(
      labelColor: buttonPrimary,
      unselectedLabelColor: textSecondary,
      labelStyle: AppTextStyles.labelLarge,
      unselectedLabelStyle: AppTextStyles.labelLarge,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: buttonAccent,
          width: AppDimensions.borderWidthThick,
        ),
      ),
    ),

    // ダイアログテーマ
    dialogTheme: DialogThemeData(
      backgroundColor: backgroundDefault,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusAllLarge,
      ),
      elevation: AppDimensions.elevationLarge,
      titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimary),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
      actionsPadding: AppDimensions.paddingAllMedium,
      insetPadding: AppDimensions.paddingAllLarge,
    ),

    // ボトムシートテーマ
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: backgroundDefault,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusTopLarge,
      ),
      elevation: AppDimensions.elevationXLarge,
    ),

    // チップテーマ
    chipTheme: ChipThemeData(
      backgroundColor: backgroundSecondary,
      selectedColor: buttonAccent,
      labelStyle: AppTextStyles.labelMedium,
      padding: AppDimensions.paddingAllSmall,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusAllLarge,
      ),
    ),

    // スイッチテーマ
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return buttonAccent;
        }
        return buttonSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return buttonAccent.withValues(alpha: 0.3);
        }
        return borderMuted;
      }),
    ),

    // チェックボックステーマ
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return buttonAccent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textOnPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
    ),

    // ラジオテーマ
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return buttonAccent;
        }
        return borderPrimary;
      }),
    ),

    // プログレスインジケーターテーマ
    // progressIndicatorTheme: const ProgressIndicatorThemeData(
    //   color: buttonAccent,
    //   linearTrackColor: backgroundSecondary,
    //   circularTrackColor: backgroundSecondary,
    // ),

    // スライダーテーマ
    sliderTheme: const SliderThemeData(
      activeTrackColor: buttonAccent,
      inactiveTrackColor: backgroundSecondary,
      thumbColor: buttonAccent,
      overlayColor: Color(0x29F47216), // buttonAccent with opacity
    ),

    // ディバイダーテーマ
    dividerTheme: const DividerThemeData(
      color: borderMuted,
      thickness: AppDimensions.borderWidthThin,
      space: AppDimensions.space16,
    ),

    // テキストセレクションテーマ
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: buttonAccent,
      selectionColor: Color(0x33F47216), // buttonAccent with opacity
      selectionHandleColor: buttonAccent,
    ),

    // スクロールバーテーマ
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(textSecondary.withValues(alpha: 0.5)),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(AppDimensions.borderRadiusSmall),
      thickness: WidgetStateProperty.all(4.0),
    ),

    // ツールチップテーマ
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: buttonPrimary,
        borderRadius: AppDimensions.borderRadiusAllMedium,
        boxShadow: AppDimensions.shadowMedium,
      ),
      textStyle: AppTextStyles.bodySmall.copyWith(color: textOnPrimary),
      padding: AppDimensions.paddingAllMedium,
    ),

    // スナックバーテーマ
    snackBarTheme: SnackBarThemeData(
      backgroundColor: buttonPrimary,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: textOnPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusAllMedium,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: AppDimensions.elevationMedium,
    ),
  );

  // ダークテーマ（必要に応じて実装）
  static ThemeData get darkTheme => lightTheme.copyWith(
    brightness: Brightness.dark,
    // ダークテーマ固有の設定をここに追加
  );
}

/// テーマ拡張（カスタムプロパティ）
///
/// 【使用例】
/// ```dart
/// final theme = Theme.of(context);
/// Container(
///   decoration: BoxDecoration(
///     color: theme.surfaceColor,      // カスタムカラー
///     borderRadius: theme.cardRadius, // カスタム角丸
///     boxShadow: theme.mediumShadow,  // カスタムシャドウ
///   ),
/// )
/// ```
extension AppThemeExtension on ThemeData {
  // カスタムカラー
  Color get surfaceColor => backgroundSurface;
  Color get accentColor => buttonAccent;
  Color get mutedColor => textSecondary;

  // カスタムシャドウ
  List<BoxShadow> get smallShadow => AppDimensions.shadowSmall;
  List<BoxShadow> get mediumShadow => AppDimensions.shadowMedium;
  List<BoxShadow> get largeShadow => AppDimensions.shadowLarge;

  // カスタムボーダー
  BorderRadius get cardRadius => AppDimensions.borderRadiusAllLarge;
  BorderRadius get buttonRadius => AppDimensions.borderRadiusAllMedium;
  BorderRadius get inputRadius => AppDimensions.borderRadiusAllMedium;
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
