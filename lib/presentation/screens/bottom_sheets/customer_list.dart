import 'package:flutter/material.dart';
import 'package:lobby_o_staff/core/constants/app_colors.dart';
import 'package:lobby_o_staff/core/constants/app_text_styles.dart';

import '../bottom_sheets/base/custom_bottom_sheet.dart';
import 'location.dart';
import 'service_detail.dart';
import 'coordinator.dart';

// サンプルデータモデル
class CustomerItem {
  final String name;
  final String nearestStation;
  final String startDate;
  final String endDate;
  final String coordinatorName;

  CustomerItem({
    required this.name,
    required this.nearestStation,
    required this.startDate,
    required this.endDate,
    required this.coordinatorName,
  });
}

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  // サンプルデータ
  final List<CustomerItem> customers = [
    CustomerItem(
      name: '山田太郎',
      nearestStation: '博多駅',
      startDate: '2025/10/01',
      endDate: '2026/03/31',
      coordinatorName: '田中',
    ),
    CustomerItem(
      name: '佐藤花子',
      nearestStation: '天神駅',
      startDate: '2025/09/15',
      endDate: '2026/02/28',
      coordinatorName: '鈴木',
    ),
    CustomerItem(
      name: '鈴木一郎',
      nearestStation: '西新駅',
      startDate: '2025/08/20',
      endDate: '2025/12/31',
      coordinatorName: '山田',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: 400,
      ),
      child: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return _buildCustomerCard(customers[index]);
        },
      ),
    );
  }

  // 顧客カード
  Widget _buildCustomerCard(CustomerItem customer) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顧客名と最寄駅
          Row(
            children: [
              Text(
                '${customer.name}様',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '@${customer.nearestStation}',
                style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // アイコンボタン三つ
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
          const SizedBox(height: 12),
          // 開始日・終了日
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '開始日：${customer.startDate}',
                style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '終了日：${customer.endDate}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textSecondary,
                    ),
                  ),
                  Text(
                    '担当C：${customer.coordinatorName}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 担当C
        ],
      ),
    );
  }

  // 小さいアイコンボタン
  Widget _buildSmallIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: backgroundAccent,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
