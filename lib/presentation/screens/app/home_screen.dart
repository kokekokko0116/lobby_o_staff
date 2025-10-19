import 'package:flutter/material.dart';
import 'package:lobby_o_staff/presentation/screens/bottom_sheets/training_documents.dart';
import '../../../core/state/app_layout_state.dart';
import '../../widgets/app/footer.dart';
import '../../widgets/app/footer_item.dart';
import '../../../core/routes/route_names.dart';
import '../bottom_sheets/base/custom_bottom_sheet.dart';
import '../bottom_sheets/location.dart';
import '../bottom_sheets/work_history.dart';
import '../bottom_sheets/employment_contract.dart';
import '../bottom_sheets/coordinator.dart';
import '../schedule/schedule_screen.dart';
import '../bottom_sheets/service_detail.dart';
import '../bottom_sheets/review.dart';
import '../bottom_sheets/customer_list.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

// 予約データモデル（仮）
class BookingItem {
  final String startTime;
  final String endTime;
  final String customerName;
  final String nearestStation;
  final String serviceType;
  final String coordinatorName;

  BookingItem({
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.nearestStation,
    required this.serviceType,
    required this.coordinatorName,
  });
}

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

  // サンプルデータ（実際はAPIから取得）
  Map<DateTime, List<BookingItem>> get _bookings {
    return {
      DateTime(_yesterday.year, _yesterday.month, _yesterday.day): [
        BookingItem(
          startTime: '09:00',
          endTime: '11:00',
          customerName: '山田 太郎',
          nearestStation: '博多駅',
          serviceType: 'レギュラー',
          coordinatorName: '田中 花子',
        ),
        BookingItem(
          startTime: '14:00',
          endTime: '16:00',
          customerName: '佐藤 次郎',
          nearestStation: '天神駅',
          serviceType: 'スポット',
          coordinatorName: '田中 花子',
        ),
      ],
      DateTime(_today.year, _today.month, _today.day): [
        BookingItem(
          startTime: '10:00',
          endTime: '12:00',
          customerName: '鈴木 美咲',
          nearestStation: '中洲川端駅',
          serviceType: 'レギュラー',
          coordinatorName: '山本 健太',
        ),
        BookingItem(
          startTime: '13:30',
          endTime: '15:30',
          customerName: '高橋 愛',
          nearestStation: '祇園駅',
          serviceType: 'レギュラー',
          coordinatorName: '山本 健太',
        ),
        BookingItem(
          startTime: '16:00',
          endTime: '18:00',
          customerName: '伊藤 誠',
          nearestStation: '博多駅',
          serviceType: 'スポット',
          coordinatorName: '田中 花子',
        ),
      ],
      DateTime(_tomorrow.year, _tomorrow.month, _tomorrow.day): [
        BookingItem(
          startTime: '09:30',
          endTime: '11:30',
          customerName: '渡辺 優子',
          nearestStation: '天神南駅',
          serviceType: 'レギュラー',
          coordinatorName: '山本 健太',
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLayout(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: backgroundPrimary,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildDateSelector(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: [
                      _buildBookingList(_yesterday),
                      _buildBookingList(_today),
                      _buildBookingList(_tomorrow),
                    ],
                  ),
                ),
              ],
            ),
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

  // ヘッダー
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '稼働予定',
            style: AppTextStyles.h4.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _buildHeaderIconButton(
                icon: Icons.calendar_today,
                label: 'Schedule',
                onPressed: () {
                  // ボトムシートではなく画面遷移に変更
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ScheduleScreen(showDetailDirectly: false),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(
                icon: Icons.check_circle_outline,
                label: 'Report',
                onPressed: () {
                  CustomBottomSheet.show(
                    context: context,
                    title: '実施確認と完了報告',
                    content: const ReviewBottomSheet(),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(
                icon: Icons.person_outline,
                label: 'Customer',
                onPressed: () {
                  // Customer 担当顧客の処理
                  CustomBottomSheet.show(
                    context: context,
                    title: '担当顧客',
                    content: const CustomerList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: textPrimary, size: 24),
          const SizedBox(height: 1),
          Text(
            label,
            style: AppTextStyles.labelXSmall.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
    // Container(
    // decoration: BoxDecoration(
    //   color: backgroundDefault,
    //   borderRadius: BorderRadius.circular(8),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.black.withOpacity(0.05),
    //       blurRadius: 4,
    //       offset: const Offset(0, 2),
    //     ),
    //   ],
    // ),

    // IconButton(
    //   icon: Icon(icon, color: textPrimary, size: 24),
    //   onPressed: onPressed,
    //   padding: const EdgeInsets.all(8),
    //   constraints: const BoxConstraints(),
    // ),
    // );
  }

  // 日付セレクター
  Widget _buildDateSelector() {
    final dates = [_yesterday, _today, _tomorrow];
    final labels = ['昨日', '今日', '明日'];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final date = dates[index];
          final isActive = _currentPageIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? buttonAccent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // 昨日、今日、明日
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isActive ? textPrimary : textSecondary,
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isActive ? textPrimary : textSecondary,
                        fontSize: 16,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 予約リスト
  Widget _buildBookingList(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final bookings = _bookings[dateKey] ?? [];

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: textSecondary),
            const SizedBox(height: 16),
            Text(
              'この日の予約はありません',
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  // 予約カード
  Widget _buildBookingCard(BookingItem booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundDefault,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 時間
                  Text(
                    '${booking.startTime}〜${booking.endTime}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 顧客名と最寄駅
                  Row(
                    children: [
                      Text(
                        '${booking.customerName}様',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '@${booking.nearestStation}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // サービス種別
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: booking.serviceType == 'レギュラー'
                          ? backgroundAccent.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      booking.serviceType,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: booking.serviceType == 'レギュラー'
                            ? backgroundAccent
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildSmallIconButton(
                      icon: Icons.place,
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          title: '利用場所',
                          content: const LocationBottomSheet(
                            address: '福岡市博多区冷泉町2-34',
                            postalCode: '812-0039',
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildSmallIconButton(
                      icon: Icons.cleaning_services,
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          title: 'サービス内容詳細',
                          content: const ServiceDetailBottomSheet(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildSmallIconButton(
                      icon: Icons.support_agent,
                      onPressed: () {
                        CustomBottomSheet.show(
                          context: context,
                          title: '担当コーディネーター',
                          content: const CoordinatorBottomSheet(),
                          contentPadding: EdgeInsets.all(0),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '担当C：${booking.coordinatorName}',
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundPrimary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, color: textAccent, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
