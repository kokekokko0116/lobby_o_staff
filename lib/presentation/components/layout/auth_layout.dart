import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import 'lobby_logo.dart';
import 'background_layout.dart';

/// 認証画面用の共通レイアウト（ログイン・登録画面で再利用）
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.children,
    this.bottomText,
    this.onBottomTextTap,
    this.showLogo = true,
  });

  final List<Widget> children;
  final String? bottomText;
  final VoidCallback? onBottomTextTap;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundLayout(
        backgroundImage: AppImages.authBackground,
        overlayColor: backgroundOverlay,
        overlayBlendMode: BlendMode.darken,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          100, // AppBarやその他の高さを考慮
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ロゴ部分
                          if (showLogo) ...[
                            const LobbyLogo(),
                            const SizedBox(height: 60),
                          ],

                          // コンテンツ部分
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 下部のテキスト（アカウント作成はこちら等）
              if (bottomText != null) ...[
                GestureDetector(
                  onTap: onBottomTextTap,
                  child: Text(
                    bottomText!,
                    style: const TextStyle(
                      color: Colors.white, // 黒背景なので白文字
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),

    );
  }
}
