import 'package:flutter/material.dart';
import '../../../core/state/app_layout_state.dart';
import '../../widgets/app/footer.dart';
import '../../widgets/app/footer_item.dart';
import '../../../core/routes/route_names.dart';
import '../../screens/bottom_sheets/base/custom_bottom_sheet.dart';

class AuthenticatedLayout extends StatefulWidget {
  const AuthenticatedLayout({super.key});

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  final List<FooterItem> _footerItems = [
    const FooterItem(
      icon: Icons.info_outline,
      activeIcon: Icons.info,
      label: 'サービス案内',
    ),
    const FooterItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      label: '契約内容',
    ),
    const FooterItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      label: '利用実績',
    ),
    const FooterItem(
      icon: Icons.phone_outlined,
      activeIcon: Icons.phone,
      label: '電話発信',
    ),
  ];

  Widget _buildBottomSheetContent(BuildContext context, int index) {
    String title = _footerItems[index].label;
    Widget content;

    switch (index) {
      case 0: // サービス案内
        content = _buildServiceInfoContent();
        break;
      case 1: // 契約内容
        content = _buildContractContent();
        break;
      case 2: // 利用実績
        content = _buildUsageReportContent();
        break;
      case 3: // 電話発信
        content = _buildPhoneCallContent();
        break;
      default:
        content = const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                content,
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('サービス概要'),
        SizedBox(height: 8),
        Text('こちらはサービス案内の内容です。\nサービスの詳細情報や利用方法について説明します。'),
        Text('こちらはサービス案内の内容です。\nサービスの詳細情報や利用方法について説明します。'),
        Text('こちらはサービス案内の内容です。\nサービスの詳細情報や利用方法について説明します。'),
      ],
    );
  }

  Widget _buildContractContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('契約詳細'),
        SizedBox(height: 8),
        Text('現在の契約内容を表示します。\n契約期間、料金プラン、オプション等の情報です。'),
      ],
    );
  }

  Widget _buildUsageReportContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('利用統計'),
        SizedBox(height: 8),
        Text('月間利用実績：120回\n総利用時間：45時間\n最終利用：2024年12月1日'),
      ],
    );
  }

  Widget _buildPhoneCallContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('電話発信'),
        const SizedBox(height: 8),
        const Text('株式会社ロビー本社に電話をかけます。'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, RouteNames.call);
          },
          icon: const Icon(Icons.phone),
          label: const Text('発信画面へ'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLayout(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            // 戻るボタン
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteNames.login);
              },
            ),
            title: const Text('ロビーオー'),
            automaticallyImplyLeading: false,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ロビーオー',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('フッターをタップして機能を利用してください', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          bottomNavigationBar: AppFooter(
            items: _footerItems,
            type: FooterType.custom,
            enableSwipeGestures: true,
            onTap: (index) {},
          ),
        );
      },
    );
  }
}
