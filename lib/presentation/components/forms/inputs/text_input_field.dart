import 'package:flutter/material.dart';
import '../base/base_input_field.dart';

/// 一般的なテキスト入力用のInputField
class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool isEnabled;
  final bool isReadOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return BaseInputField(
      controller: controller,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      isRequired: isRequired,
      isEnabled: isEnabled,
      isReadOnly: isReadOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: TextInputType.text,
      textInputAction:
          textInputAction ??
          (maxLines == 1 ? TextInputAction.next : TextInputAction.newline),
      textCapitalization: textCapitalization,
      validator: validator ?? _defaultTextValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  static String? _defaultTextValidator(String? value) {
    // デフォルトでは何もバリデーションしない
    return null;
  }
}
