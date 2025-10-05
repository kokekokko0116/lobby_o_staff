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
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                    onTilePressed: (key) {
                      _handleTilePressed(key);
                    },
                    onIconPressed: (key) {
                      _handleIconPressed(key);
                    },
                  ),
                  HomeLayout(
                    onTilePressed: (key) {
                      _handleTilePressed(key);
                    },
                    onIconPressed: (key) {
                      _handleIconPressed(key);
                    },
                  ),
                  HomeLayout(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDotIndicators(),
        ),
      ),
    );
  }

  List<Widget> _buildDotIndicators() {
    return List.generate(3, (index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _currentPageIndex == index ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: _currentPageIndex == index
              ? Colors.white
              : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4),
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
