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
  final String? endDate; // nullableに変更
  final String coordinatorName;
  final String status; // '契約中' or '休止中'

  CustomerItem({
    required this.name,
    required this.nearestStation,
    required this.startDate,
    this.endDate, // optional
    required this.coordinatorName,
    required this.status,
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
      coordinatorName: '田中 花子',
      status: '契約中',
    ),
    CustomerItem(
      name: '佐藤花子',
      nearestStation: '天神駅',
      startDate: '2025/09/15',
      endDate: null, // 終了日なし
      coordinatorName: '鈴木 太郎',
      status: '契約中',
    ),
    CustomerItem(
      name: '鈴木一郎',
      nearestStation: '西新駅',
      startDate: '2025/08/20',
      endDate: '2025/12/31',
      coordinatorName: '山田 次郎',
      status: '休止中',
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 左側：名前、タグ、アイコンボタン
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顧客名
                  Text(
                    '${customer.name}様',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ステータスタグ
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: customer.status == '契約中'
                          ? backgroundAccent.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      customer.status,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: customer.status == '契約中'
                            ? backgroundAccent
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 右側：開始日、終了日、担当C
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 上部：開始日・終了日
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '開始日：${customer.startDate}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textSecondary,
                      ),
                    ),
                    if (customer.endDate != null) ...[
                      Text(
                        '終了日：${customer.endDate}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                // 下部：担当C
                Text(
                  '担当C：${customer.coordinatorName}',
                  style: AppTextStyles.bodySmall.copyWith(color: textSecondary),
                ),
              ],
            ),
          ],
        ),
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
        color: backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: textAccent,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
