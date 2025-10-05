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
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      label: '研修資料',
    ),
    const FooterItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
      label: '雇用契約',
    ),
    const FooterItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      label: '稼働実績',
    ),
    const FooterItem(
      icon: Icons.phone_outlined,
      activeIcon: Icons.phone,
      label: '電話発信',
    ),
  ];

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
