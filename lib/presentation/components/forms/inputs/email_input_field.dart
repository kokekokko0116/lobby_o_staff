import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/base_input_field.dart';

/// メールアドレス入力用のInputField
class EmailInputField extends StatelessWidget {
  const EmailInputField({
    super.key,
    this.controller,
    this.label = 'メールアドレス',
    this.hintText = 'example@email.com',
    this.helperText,
    this.errorText,
    this.isRequired = true,
    this.isEnabled = true,
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
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      isRequired: isRequired,
      isEnabled: isEnabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // スペース無効
      ],
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
      labelColor: labelColor, // ラベル色を渡す
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  static String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '正しいメールアドレスを入力してください';
    }

    return null;
  }
}
