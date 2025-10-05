import 'package:flutter/material.dart';
import '../base/base_input_field.dart';

/// パスワード入力用のInputField
class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    this.controller,
    this.label = 'パスワード',
    this.hintText = 'パスワードを入力',
    this.helperText,
    this.errorText,
    this.isRequired = true,
    this.isEnabled = true,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.showVisibilityToggle = true,
    this.minLength = 8,
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
  final bool showVisibilityToggle;
  final int minLength;
  final Color? labelColor; // ラベルの色

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BaseInputField(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      isRequired: widget.isRequired,
      isEnabled: widget.isEnabled,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.none,
      validator: widget.validator ?? _defaultPasswordValidator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      labelColor: widget.labelColor, // ラベル色を渡す
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: widget.showVisibilityToggle
          ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
          : null,
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }

    if (value.length < widget.minLength) {
      return 'パスワードは${widget.minLength}文字以上で入力してください';
    }

    return null;
  }
}
