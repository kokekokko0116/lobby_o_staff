import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input_field_config.dart';
import '../../../../core/constants/app_colors.dart';

/// 全てのInputFieldの基本となるウィジェット
class BaseInputField extends StatefulWidget {
  const BaseInputField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.labelColor, // ラベルの色を指定可能
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool isEnabled;
  final bool isReadOnly;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final Color? labelColor; // ラベルの色

  @override
  State<BaseInputField> createState() => _BaseInputFieldState();
}

class _BaseInputFieldState extends State<BaseInputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Focus state changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[_buildLabel(), const SizedBox(height: 8)],
        _buildTextField(),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          _buildHelperText(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: InputFieldConfig.labelTextStyle.copyWith(
          color: widget.labelColor, // カスタム色が指定されていれば使用
        ),
        children: [
          if (widget.isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: textError, // カスタム色が指定されていれば使用
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      height: widget.maxLines == 1 ? InputFieldConfig.height : null,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization,
        style: InputFieldConfig.inputTextStyle.copyWith(
          color: widget.isEnabled ? textPrimary : textDisabled,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: InputFieldConfig.hintTextStyle,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          contentPadding: InputFieldConfig.contentPadding,
          border: InputFieldConfig.defaultBorder,
          enabledBorder: InputFieldConfig.defaultBorder,
          focusedBorder: InputFieldConfig.focusedBorder,
          errorBorder: InputFieldConfig.errorBorder,
          focusedErrorBorder: InputFieldConfig.errorBorder,
          disabledBorder: InputFieldConfig.disabledBorder,
          filled: true,
          fillColor: widget.isEnabled ? backgroundDefault : backgroundMuted,
          counterText: '', // maxLengthカウンターを非表示
          errorText: widget.errorText,
          errorStyle: InputFieldConfig.errorTextStyle,
        ),
      ),
    );
  }

  Widget _buildHelperText() {
    if (widget.errorText != null) {
      return Text(widget.errorText!, style: InputFieldConfig.errorTextStyle);
    }

    if (widget.helperText != null) {
      return Text(
        widget.helperText!,
        style: InputFieldConfig.errorTextStyle.copyWith(color: textSecondary),
      );
    }

    return const SizedBox.shrink();
  }
}
