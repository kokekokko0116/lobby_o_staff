import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// InputFieldの共通設定クラス
class InputFieldConfig {
  static const double borderRadius = 8.0;
  static const double borderWidth = 1.0;
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );
  static const double fontSize = 16.0;
  static const double labelFontSize = 14.0;
  static const double errorFontSize = 12.0;
  static const double height = 56.0;

  // Border styles
  static OutlineInputBorder get defaultBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: borderPrimary, width: borderWidth),
  );

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: borderFocus, width: borderWidth),
  );

  static OutlineInputBorder get errorBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: borderError, width: borderWidth),
  );

  static OutlineInputBorder get disabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: const BorderSide(color: borderMuted, width: borderWidth),
  );

  // Text styles - Google Fontsを使用した統一されたタイポグラフィシステム
  static TextStyle get inputTextStyle =>
      AppTextStyles.inputText.copyWith(color: textPrimary);

  static TextStyle get labelTextStyle =>
      AppTextStyles.inputLabel.copyWith(color: textSecondary);

  static TextStyle get errorTextStyle =>
      AppTextStyles.inputError.copyWith(color: textError);

  static TextStyle get hintTextStyle =>
      AppTextStyles.inputHint.copyWith(color: textDisabled);
}
