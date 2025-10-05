import 'package:flutter/material.dart';
import '../base/base_input_field.dart';

/// セレクトボタン用のInputField（タップで選択肢表示）
class SelectInputField<T> extends StatelessWidget {
  const SelectInputField({
    super.key,
    this.controller,
    this.label,
    this.hintText = '選択してください',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.isEnabled = true,
    this.value,
    this.items = const [],
    this.itemBuilder,
    this.validator,
    this.onChanged,
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
  final T? value;
  final List<SelectOption<T>> items;
  final Widget Function(SelectOption<T>)? itemBuilder;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
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
      isReadOnly: true,
      validator: (value) => validator?.call(this.value),
      onTap: isEnabled ? () => _showSelectDialog(context) : null,
      focusNode: focusNode,
      autofocus: autofocus,
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
    );
  }

  Future<void> _showSelectDialog(BuildContext context) async {
    final result = await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label ?? '選択'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: itemBuilder?.call(item) ?? Text(item.label),
                selected: value == item.value,
                onTap: () => Navigator.of(context).pop(item.value),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );

    if (result != null) {
      final selectedItem = items.firstWhere((item) => item.value == result);
      controller?.text = selectedItem.label;
      onChanged?.call(result);
    }
  }
}

/// セレクトオプションのデータクラス
class SelectOption<T> {
  const SelectOption({required this.value, required this.label});

  final T value;
  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectOption<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
