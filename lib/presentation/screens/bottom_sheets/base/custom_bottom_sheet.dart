// core/widgets/custom_bottom_sheet.dart - 汎用ボトムシート
import 'package:flutter/material.dart';
import '/core/constants/app_colors.dart';
import '/core/constants/app_text_styles.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.borderRadius = 20.0,
    this.showDragHandle = true,
    this.maxHeightRatio = 0.8, // 画面の8割
    this.dragHandleColor,
  });

  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final double borderRadius;
  final bool showDragHandle;
  final double maxHeightRatio; // 画面に対する最大高さの割合
  final Color? dragHandleColor;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * maxHeightRatio;
    final effectiveHeight = height != null
        ? (height! > maxHeight ? maxHeight : height!)
        : maxHeight;

    return Container(
      width: double.infinity, // 横幅を最大限に
      constraints: BoxConstraints(maxHeight: effectiveHeight),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ドラッグハンドル
          if (showDragHandle) ...[
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: dragHandleColor ?? Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
          ],
          // スクロール可能なコンテンツ
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// タイトルとコンテンツで簡単にボトムシートを表示
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    double borderRadius = 20.0,
    bool showDragHandle = true,
    double maxHeightRatio = 0.8,
    Color? dragHandleColor = borderPrimary,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showCloseButton = true,
    VoidCallback? onClose,
    // ヘッダーのカスタマイズ
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: false,
      builder: (context) => CustomBottomSheet(
        borderRadius: borderRadius,
        showDragHandle: showDragHandle,
        maxHeightRatio: maxHeightRatio,
        dragHandleColor: dragHandleColor,
        child: _BottomSheetContent(
          title: title,
          content: content,
          showCloseButton: showCloseButton,
          onClose: onClose,
          titleStyle: titleStyle,
          padding: padding,
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}

/// ボトムシートの内容を構成するプライベートウィジェット
class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({
    this.title,
    required this.content,
    this.showCloseButton = true,
    this.onClose,
    this.titleStyle,
    this.padding,
    this.contentPadding,
  });

  final String? title;
  final Widget content;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24);
    final defaultContentPadding =
        contentPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ヘッダー部分
        if (title != null) ...[
          Padding(
            padding: defaultPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title ?? '', style: titleStyle ?? AppTextStyles.h6),

                // if (showCloseButton)
                //   IconButton(
                //     onPressed: () {
                //       onClose?.call();
                //       Navigator.of(context).pop();
                //     },
                //     icon: const Icon(Icons.close),
                //     style: IconButton.styleFrom(
                //       backgroundColor: Colors.grey[100],
                //       foregroundColor: Colors.grey[700],
                //       minimumSize: const Size(36, 36),
                //       padding: EdgeInsets.zero,
                //     ),
                //   ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        // コンテンツ部分
        Flexible(
          child: Padding(padding: defaultContentPadding, child: content),
        ),
      ],
    );
  }
}
