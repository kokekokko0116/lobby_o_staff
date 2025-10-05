import 'package:flutter/material.dart';
import 'package:lobby_o_staff/presentation/screens/bottom_sheets/training_documents.dart';
import '../../../core/state/app_layout_state.dart';
import '../../widgets/app/footer.dart';
import '../../widgets/app/footer_item.dart';
import '../../../core/routes/route_names.dart';
import '../bottom_sheets/base/custom_bottom_sheet.dart';
import '../../components/layout/home_layout.dart';
import '../bottom_sheets/location.dart';
import '../bottom_sheets/work_history.dart';
import '../bottom_sheets/employment_contract.dart';
import '../bottom_sheets/coordinator.dart';
import '../bottom_sheets/schedule/schedule_bottom_sheet.dart';
import '../bottom_sheets/service_detail.dart';
import '../bottom_sheets/completion_report_popup.dart';
import '../bottom_sheets/review.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1); // 今日のページから開始
    _currentPageIndex = 1; // 初期表示も今日に設定
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime get _yesterday => DateTime.now().subtract(const Duration(days: 1));
  DateTime get _today => DateTime.now();
  DateTime get _tomorrow => DateTime.now().add(const Duration(days: 1));

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

  // void _showBottomSheet(BuildContext context, int index) {
  //   CustomBottomSheet.show(
  //     context: context,
  //     child: _buildBottomSheetContent(context, index),
  //     showDragHandle: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLayout(),
      builder: (context, child) {
        return Scaffold(
          // appBar: AppBar(
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.pushReplacementNamed(context, RouteNames.login);
          //     },
          //   ),
          //   title: const Text('ホーム'),
          //   automaticallyImplyLeading: false,
          // ),
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  HomeLayout(
                    displayDate: _yesterday,
                    onTilePressed: (key) {
                      _handleTilePressed(key);
                    },
                    onIconPressed: (key) {
                      _handleIconPressed(key);
                    },
                  ),
                  HomeLayout(
                    displayDate: _today,
                    onTilePressed: (key) {
                      _handleTilePressed(key);
                    },
                    onIconPressed: (key) {
                      _handleIconPressed(key);
                    },
                  ),
                  HomeLayout(
                    displayDate: _tomorrow,
                    onTilePressed: (key) {
                      _handleTilePressed(key);
                    },
                    onIconPressed: (key) {
                      _handleIconPressed(key);
                    },
                  ),
                ],
              ),
              _buildTopIndicator(),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AppFooter(
              items: _footerItems,
              type: FooterType.custom,
              enableSwipeGestures: true,
              onTap: (index) {
                if (index == 3) {
                  Navigator.pushNamed(context, RouteNames.call);
                } else if (index == 2) {
                  CustomBottomSheet.show(
                    context: context,
                    title: '稼働実績',
                    content: const WorkHistoryBottomSheet(),
                  );
                } else if (index == 0) {
                  CustomBottomSheet.show(
                    context: context,
                    title: '研修資料',
                    content: const TrainingDocumentsBottomSheet(),
                  );
                } else if (index == 1) {
                  CustomBottomSheet.show(
                    context: context,
                    title: '雇用契約',
                    content: const EmploymentContractBottomSheet(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopIndicator() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildDateIndicators(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDateIndicators() {
    final dates = [_yesterday, _today, _tomorrow];
    final labels = ['昨日', '今日', '明日'];

    return List.generate(3, (index) {
      final date = dates[index];
      final label = labels[index];
      final isActive = _currentPageIndex == index;

      return GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$label\n${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black87 : Colors.white,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              height: 1.2,
            ),
          ),
        ),
      );
    });
  }

  void _handleTilePressed(String key) {
    switch (key) {
      case 'schedule_list':
        // 一覧表示でScheduleボトムシートを開く
        CustomBottomSheet.show(
          context: context,
          title: '予定の確認と変更',
          content: const ScheduleBottomSheet(showDetailDirectly: false),
        );
        break;
      case 'review':
        CustomBottomSheet.show(
          context: context,
          title: '実施の確認と評価',
          content: const ReviewBottomSheet(),
        );
        break;
      case 'service':
        CustomBottomSheet.show(
          context: context,
          title: 'サービス内容詳細',
          content: const ServiceDetailBottomSheet(),
        );
        break;
      case 'coordinator':
        CustomBottomSheet.show(
          context: context,
          title: '担当コーディネーター',
          content: const CoordinatorBottomSheet(),
          contentPadding: EdgeInsets.all(0),
        );
        break;
    }
  }

  void _handleIconPressed(String key) {
    switch (key) {
      case 'location':
        CustomBottomSheet.show(
          context: context,
          title: '利用場所',
          content: const LocationBottomSheet(
            address: '福岡市博多区冷泉町2-34',
            postalCode: '812-0039',
          ),
        );
        break;
      case 'service':
        CustomBottomSheet.show(
          context: context,
          title: 'サービス内容詳細',
          content: const ServiceDetailBottomSheet(),
        );
        break;
      case 'phone':
        Navigator.pushNamed(context, RouteNames.call);
        break;
      case 'message':
        // メッセージ機能の処理
        break;
      case 'settings':
        // 設定画面への遷移
        break;
      case 'review':
        CompletionReportPopup.show(
          context,
          completionDateTime: DateTime.now(),
          staffName: 'スタッフ名',
        );
        break;
      case 'schedule_detail':
        // 詳細画面直接表示でScheduleボトムシートを開く
        CustomBottomSheet.show(
          context: context,
          title: '予定の詳細',
          content: const ScheduleBottomSheet(showDetailDirectly: true),
        );
        break;
    }
  }
}
