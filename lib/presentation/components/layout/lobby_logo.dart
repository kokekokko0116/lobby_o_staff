import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';

/// LOBBYロゴコンポーネント
class LobbyLogo extends StatelessWidget {
  const LobbyLogo({
    super.key,
    this.size = 240.0,
    this.textSize = 32.0,
    this.showIcon = true,
  });

  final double size;
  final double textSize;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          // 画像ファイルがある場合は画像を使用、ない場合はフォールバック
          Image.asset(
            AppImages.lobbyLogo,
            width: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // 画像が見つからない場合のフォールバック（CSS描画）
              return _buildFallbackIcon();
            },
          ),
        ],
      ],
    );
  }

  /// 画像が見つからない場合のフォールバックアイコン
  Widget _buildFallbackIcon() {
    return Container(
      width: size * 0.6,
      height: size * 0.4,
      decoration: const BoxDecoration(
        color: backgroundAccent, // オレンジ色
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          // 左の花びら
          Positioned(
            left: -10,
            top: 8,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 25,
                height: 35,
                decoration: const BoxDecoration(
                  color: backgroundAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          // 右の花びら
          Positioned(
            right: -10,
            top: 8,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 25,
                height: 35,
                decoration: const BoxDecoration(
                  color: backgroundAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          // 上の花びら
          Positioned(
            top: -5,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 30,
                height: 25,
                decoration: const BoxDecoration(
                  color: backgroundAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
