import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'delivery_order_details_screen.dart';

/// Delivery history screen with completed deliveries
/// Shows statistics and filterable history list
class DeliveryHistoryScreen extends ConsumerStatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  ConsumerState<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends ConsumerState<DeliveryHistoryScreen> {
  String selectedFilter = 'all'; // all, today, week, month

  @override
  Widget build(BuildContext context) {
    final deliveryState = ref.watch(deliveryProvider);
    final filteredHistory = deliveryState.completedOrders;

    final totalDeliveries = filteredHistory.length;
    final totalEarnings = filteredHistory.fold<double>(
      0,
      (sum, order) => sum + order.totalAmount,
    );
    final avgRating = totalDeliveries > 0 ? 4.5 : 0.0; // Mock rating

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textPrimary,
              size: AppDimensions.iconMedium,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: ArabicText(
            text: 'سجل التوصيل',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Filter buttons
            Container(
              margin: EdgeInsets.all(AppDimensions.spacing16),
              padding: EdgeInsets.all(AppDimensions.spacing4),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  _buildFilterButton('الكل', 'all'),
                  _buildFilterButton('اليوم', 'today'),
                  _buildFilterButton('أسبوع', 'week'),
                  _buildFilterButton('شهر', 'month'),
                ],
              ),
            ),

            // Statistics cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.delivery_dining,
                      value: '$totalDeliveries',
                      label: 'توصيلة',
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.attach_money,
                      value: '${totalEarnings.toStringAsFixed(0)} دج',
                      label: 'الأرباح',
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star,
                      value: avgRating.toStringAsFixed(1),
                      label: 'التقييم',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.spacing16),

            // History list
            Expanded(
              child: filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: AppDimensions.iconXXLarge,
                            color: AppColors.borderLight,
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          ArabicText(
                            text: 'لا يوجد سجل توصيل',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final delivery = filteredHistory[index];
                        return _buildHistoryCard(delivery);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, String filter) {
    final isSelected = selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = filter;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Center(
            child: ArabicText(
              text: title,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensions.iconLarge,
          ),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: value,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 2.h),
          ArabicText(
            text: label,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(DeliveryOrder delivery) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryOrderDetailsScreen(order: delivery),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArabicText(
                  text: '#${delivery.id}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing8,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12.w,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: 'تم التوصيل',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 14.w,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppDimensions.spacing6),
                Expanded(
                  child: ArabicText(
                    text: delivery.restaurantName,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing6),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14.w,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppDimensions.spacing6),
                Expanded(
                  child: ArabicText(
                    text: delivery.customerName,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppDimensions.spacing4),
                    ArabicText(
                      text: _formatDateTime(delivery.orderTime),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < 5 ? Icons.star : Icons.star_border,
                      size: 14.w,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing8),
            Divider(color: AppColors.borderLight, height: 1),
            SizedBox(height: AppDimensions.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ArabicText(
                      text: 'المبلغ: ',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    ArabicText(
                      text: '${delivery.totalAmount.toStringAsFixed(0)} دج',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
