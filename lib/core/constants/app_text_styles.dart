import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Google Fontsパッケージを使用したテキストスタイル
///
/// 使用例: Text('タイトル', style: AppTextStyles.h1)
class AppTextStyles {
  AppTextStyles._();

  // ベーススタイル取得メソッド
  static TextStyle _getInterStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle _getNotoSansJPStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.notoSansJp(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ヘッダー・タイトル系
  static TextStyle get h1 => _getInterStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => _getInterStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static TextStyle get h3 => _getInterStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static TextStyle get h4 =>
      _getInterStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);

  static TextStyle get h5 =>
      _getInterStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);

  static TextStyle get h6 =>
      _getInterStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5);

  // ボディテキスト系
  static TextStyle get bodyLarge => _getInterStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle get bodyMedium => _getInterStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle get bodySmall => _getInterStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.2,
  );

  // ラベル・キャプション系
  static TextStyle get labelLarge => _getInterStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => _getInterStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => _getInterStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle get labelXSmall => _getInterStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.4,
  );

  // ボタンテキスト
  static TextStyle get buttonLarge => _getInterStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonMedium => _getInterStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonSmall => _getInterStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // インプット系
  static TextStyle get inputLabel => _getInterStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get inputText =>
      _getInterStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);

  static TextStyle get inputHint =>
      _getInterStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);

  static TextStyle get inputHelper => _getInterStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static TextStyle get inputError => _getInterStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // 日本語用スタイル（Noto Sans JP）
  static TextStyle get h1JP => _getNotoSansJPStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h3JP => _getNotoSansJPStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get bodyLargeJP => _getNotoSansJPStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // 色付きスタイル（使用頻度の高い組み合わせ）
  static TextStyle get h1Primary => h1.copyWith(color: textPrimary);
  static TextStyle get h1OnPrimary => h1.copyWith(color: textOnPrimary);
  static TextStyle get h2Primary => h2.copyWith(color: textPrimary);
  static TextStyle get h3Primary => h3.copyWith(color: textPrimary);
  static TextStyle get h3OnPrimary => h3.copyWith(color: textOnPrimary);

  static TextStyle get bodyLargePrimary =>
      bodyLarge.copyWith(color: textPrimary);
  static TextStyle get bodyLargeSecondary =>
      bodyLarge.copyWith(color: textSecondary);
  static TextStyle get bodyLargeOnPrimary =>
      bodyLarge.copyWith(color: textOnPrimary);

  static TextStyle get bodyMediumPrimary =>
      bodyMedium.copyWith(color: textPrimary);
  static TextStyle get bodyMediumSecondary =>
      bodyMedium.copyWith(color: textSecondary);
  static TextStyle get bodyMediumOnPrimary =>
      bodyMedium.copyWith(color: textOnPrimary);

  static TextStyle get labelPrimary => labelLarge.copyWith(color: textPrimary);
  static TextStyle get labelSecondary =>
      labelLarge.copyWith(color: textSecondary);
  static TextStyle get labelOnPrimary =>
      labelLarge.copyWith(color: textOnPrimary);

  static TextStyle get inputLabelPrimary =>
      inputLabel.copyWith(color: textPrimary);
  static TextStyle get inputLabelOnPrimary =>
      inputLabel.copyWith(color: textOnPrimary);
  static TextStyle get inputErrorStyle => inputError.copyWith(color: textError);
  static TextStyle get inputHelperStyle =>
      inputHelper.copyWith(color: textSecondary);
}
