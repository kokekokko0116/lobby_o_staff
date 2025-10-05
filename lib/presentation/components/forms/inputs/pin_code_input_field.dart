import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/base_input_field.dart';

/// ピンコード入力用のInputField
class PinCodeInputField extends StatelessWidget {
  const PinCodeInputField({
    super.key,
    this.controller,
    this.label = 'ピンコード',
    this.hintText,
    this.helperText,
    this.errorText,
    this.isRequired = true,
    this.isEnabled = true,
    this.pinLength = 6,
    this.obscureText = true,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.labelColor, // ラベルの色を指定可能
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool isEnabled;
  final int pinLength;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? labelColor; // ラベルの色

  @override
  Widget build(BuildContext context) {
    return BaseInputField(
      controller: controller,
      label: label,
      hintText: hintText ?? '$pinLength桁の数字を入力',
      helperText: helperText,
      errorText: errorText,
      isRequired: isRequired,
      isEnabled: isEnabled,
      // obscureText: obscureText,
      maxLength: pinLength,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(pinLength),
      ],
      validator: validator ?? _defaultPinValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
      labelColor: labelColor, // ラベル色を渡す
      prefixIcon: const Icon(Icons.pin_outlined),
    );
  }

  String? _defaultPinValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'ピンコードを入力してください';
    }

    if (value.length != pinLength) {
      return '$pinLength桁の数字を入力してください';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '数字のみ入力してください';
    }

    return null;
  }
}
