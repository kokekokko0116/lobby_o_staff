// background_layout.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';

/// 背景画像付きの共通レイアウト
class BackgroundLayout extends StatelessWidget {
  const BackgroundLayout({
    super.key,
    required this.child,
    this.backgroundImage,
    this.gradientColors,
    this.overlayColor,
    this.overlayBlendMode = BlendMode.darken,
    this.fit = BoxFit.cover,
  });

  final Widget child;
  final String? backgroundImage;
  final List<Color>? gradientColors;
  final Color? overlayColor;
  final BlendMode overlayBlendMode;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // フォールバック用グラデーション
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              gradientColors ??
              [
                const Color(0xFF2C3E50), // ダークブルーグレー
                const Color(0xFF34495E), // 少し明るいブルーグレー
              ],
        ),
        // 背景画像（オプション）
        image: backgroundImage != null
            ? DecorationImage(
                image: AssetImage(backgroundImage!),
                fit: fit,
                onError: (error, stackTrace) {
                  debugPrint('Background image loading failed: $error');
                },
                // オーバーレイの適用
                colorFilter: overlayColor != null
                    ? ColorFilter.mode(overlayColor!, overlayBlendMode)
                    : null,
              )
            : null,
      ),
      child: child,
    );
  }
}
