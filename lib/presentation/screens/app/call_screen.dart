import 'dart:ui';
import 'package:flutter/material.dart';
import '../../components/buttons/info_button.dart';
import '../../components/layout/background_layout.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void _onCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('発信', style: AppTextStyles.h4),
        content: Text(
          '株式会社ロビー本社に発信しますか？',
          style: AppTextStyles.bodyMediumPrimary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'キャンセル',
              style: AppTextStyles.buttonMedium.copyWith(color: textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '発信機能は未実装です',
                    style: AppTextStyles.bodyMediumOnPrimary,
                  ),
                ),
              );
            },
            child: Text(
              '発信',
              style: AppTextStyles.buttonMedium.copyWith(color: textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundLayout(
        backgroundImage: AppImages.callBackground,
        overlayColor: Colors.black.withOpacity(0.2),
        overlayBlendMode: BlendMode.darken,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
              // ここにchildを後で配置する予定
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: AppDimensions.shadowLarge,
                            ),
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                AppImages.lobbyCompany,
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: AppDimensions.borderWidthThick,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space32),

                          Text(
                            '株式会社ロビー本社',
                            style: AppTextStyles.h3OnPrimary.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 下部ボタン領域
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: AppDimensions.paddingAllLarge,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 発信ボタン
                            InfoButton(
                              text: '発信 +81 3-1234-5678',
                              onPressed: _onCall,
                              isEnabled: true,
                              icon: Icons.phone,
                              fontSize:
                                  AppTextStyles.buttonLarge.fontSize ?? 16.0,
                            ),

                            const SizedBox(height: AppDimensions.space16),

                            InfoButton(
                              text: 'キャンセル',
                              onPressed: _onCancel,
                              isEnabled: true,
                              fontSize:
                                  AppTextStyles.buttonLarge.fontSize ?? 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // メインコンテンツ
  }
}
