import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/base_input_field.dart';

/// 数字入力用のInputField
class NumberInputField extends StatelessWidget {
  const NumberInputField({
    super.key,
    this.controller,
    this.label,
    this.hintText = '数字を入力',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.isEnabled = true,
    this.allowDecimal = false,
    this.allowNegative = false,
    this.maxLength,
    this.minValue,
    this.maxValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
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
  final bool allowDecimal;
  final bool allowNegative;
  final int? maxLength;
  final double? minValue;
  final double? maxValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
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
      maxLength: maxLength,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: allowNegative,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: _buildInputFormatters(),
      validator: validator ?? _defaultNumberValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
      prefixIcon: const Icon(Icons.numbers_outlined),
    );
  }

  List<TextInputFormatter> _buildInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if (allowDecimal && allowNegative) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      );
    } else if (allowDecimal) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')));
    } else if (allowNegative) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')));
    } else {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return formatters;
  }

  String? _defaultNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      if (isRequired) {
        return '数値を入力してください';
      }
      return null;
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return '正しい数値を入力してください';
    }

    if (minValue != null && numValue < minValue!) {
      return '$minValue以上の値を入力してください';
    }

    if (maxValue != null && numValue > maxValue!) {
      return '$maxValue以下の値を入力してください';
    }

    return null;
  }
}
