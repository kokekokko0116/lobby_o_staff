import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceCommentWidget extends StatefulWidget {
  const ServiceCommentWidget({
    super.key,
    this.comment = '',

    this.onCommentChanged,
  });

  final String comment;

  final Function(String)? onCommentChanged;

  @override
  State<ServiceCommentWidget> createState() => _ServiceCommentWidgetState();
}

class _ServiceCommentWidgetState extends State<ServiceCommentWidget> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentTitle(),
        const SizedBox(height: 24),
        Expanded(child: _buildCommentField()),
      ],
    );
  }

  Widget _buildCommentTitle() {
    return Text('気になる点などございましたらご記入ください。', style: AppTextStyles.bodyLarge);
  }

  Widget _buildCommentField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
        color: backgroundDefault,
      ),
      child: TextField(
        controller: _commentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        onChanged: (value) {
          widget.onCommentChanged?.call(value);
        },
        decoration: InputDecoration(
          hintText: 'ご感想をお聞かせください...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          color: textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}
