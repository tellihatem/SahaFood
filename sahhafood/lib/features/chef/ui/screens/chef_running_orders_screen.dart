import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

/// Chef running orders screen showing active orders
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefRunningOrdersScreen extends ConsumerStatefulWidget {
  const ChefRunningOrdersScreen({super.key});

  @override
  ConsumerState<ChefRunningOrdersScreen> createState() => _ChefRunningOrdersScreenState();
}

class _ChefRunningOrdersScreenState extends ConsumerState<ChefRunningOrdersScreen> {
  ChefOrderStatus _selectedStatus = ChefOrderStatus.pending;

  @override
  Widget build(BuildContext context) {
    final chefState = ref.watch(chefProvider);
    final filteredOrders = _selectedStatus == ChefOrderStatus.pending
        ? chefState.orders.where((o) => 
            o.status == ChefOrderStatus.pending ||
            o.status == ChefOrderStatus.preparing ||
            o.status == ChefOrderStatus.ready ||
            o.status == ChefOrderStatus.outForDelivery
          ).toList()
        : chefState.orders.where((o) => o.status == _selectedStatus).toList();

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
            text: 'الطلبات الجارية',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Status filter tabs
            Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                children: [
                  _StatusChip(
                    label: 'الكل',
                    isSelected: _selectedStatus == ChefOrderStatus.pending,
                    onTap: () => setState(() => _selectedStatus = ChefOrderStatus.pending),
                  ),
                  _StatusChip(
                    label: 'قيد التحضير',
                    isSelected: _selectedStatus == ChefOrderStatus.preparing,
                    onTap: () => setState(() => _selectedStatus = ChefOrderStatus.preparing),
                  ),
                  _StatusChip(
                    label: 'جاهز',
                    isSelected: _selectedStatus == ChefOrderStatus.ready,
                    onTap: () => setState(() => _selectedStatus = ChefOrderStatus.ready),
                  ),
                  _StatusChip(
                    label: 'في الطريق',
                    isSelected: _selectedStatus == ChefOrderStatus.outForDelivery,
                    onTap: () => setState(() => _selectedStatus = ChefOrderStatus.outForDelivery),
                  ),
                ],
              ),
            ),

            // Orders list
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: AppDimensions.iconXXLarge,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          ArabicText(
                            text: 'لا توجد طلبات',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppDimensions.spacing20),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return _OrderCard(
                          order: order,
                          onAccept: () {
                            ref.read(chefProvider.notifier).acceptOrder(order.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('تم قبول الطلب'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          onReady: () {
                            ref.read(chefProvider.notifier).markAsReady(order.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('الطلب جاهز للتوصيل'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          onCancel: () {
                            _showCancelDialog(context, order.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const ArabicText(
            text: 'إلغاء الطلب',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: const ArabicText(
            text: 'هل أنت متأكد من إلغاء هذا الطلب؟',
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ArabicText(
                text: 'رجوع',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(chefProvider.notifier).cancelOrder(orderId, 'تم الإلغاء من قبل الشيف');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم إلغاء الطلب'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              child: ArabicText(
                text: 'إلغاء الطلب',
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Status chip widget
class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing8,
        ),
        margin: EdgeInsets.only(left: AppDimensions.spacing8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: ArabicText(
          text: label,
          fontSize: 14,
          color: isSelected ? AppColors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

/// Order card widget
class _OrderCard extends StatelessWidget {
  final ChefOrder order;
  final VoidCallback onAccept;
  final VoidCallback onReady;
  final VoidCallback onCancel;

  const _OrderCard({
    required this.order,
    required this.onAccept,
    required this.onReady,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                text: order.orderNumber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: ArabicText(
                  text: order.status.displayName,
                  fontSize: 12,
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spacing12),

          // Customer info
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: AppDimensions.iconMedium,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppDimensions.spacing8),
              ArabicText(
                text: order.customerName,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spacing8),

          // Order items
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing12),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.spacing4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        text: '${item.quantity}x ${item.foodName}',
                        fontSize: 14,
                      ),
                      ArabicText(
                        text: '${item.price.toStringAsFixed(0)} دج',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: AppDimensions.spacing12),

          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                text: 'المجموع',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              ArabicText(
                text: '${order.totalPrice.toStringAsFixed(0)} دج',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spacing16),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (order.status == ChefOrderStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'رفض',
              onPressed: onCancel,
              backgroundColor: AppColors.error.withOpacity(0.1),
              textColor: AppColors.error,
              height: 44,
            ),
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: CustomButton(
              text: 'قبول',
              onPressed: onAccept,
              height: 44,
            ),
          ),
        ],
      );
    } else if (order.status == ChefOrderStatus.preparing) {
      return CustomButton(
        text: 'جاهز للتوصيل',
        onPressed: onReady,
        height: 44,
        width: double.infinity,
      );
    } else if (order.status == ChefOrderStatus.ready) {
      return Container(
        padding: EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: AppDimensions.iconMedium,
            ),
            SizedBox(width: AppDimensions.spacing8),
            ArabicText(
              text: 'بانتظار التوصيل',
              fontSize: 14,
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    } else if (order.status == ChefOrderStatus.outForDelivery) {
      return Container(
        padding: EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delivery_dining,
              color: AppColors.primary,
              size: AppDimensions.iconMedium,
            ),
            SizedBox(width: AppDimensions.spacing8),
            ArabicText(
              text: 'في الطريق - ${order.deliveryPersonName}',
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(ChefOrderStatus status) {
    switch (status) {
      case ChefOrderStatus.pending:
        return AppColors.warning;
      case ChefOrderStatus.preparing:
        return AppColors.primary;
      case ChefOrderStatus.ready:
        return AppColors.success;
      case ChefOrderStatus.outForDelivery:
        return AppColors.info;
      case ChefOrderStatus.completed:
        return AppColors.success;
      case ChefOrderStatus.cancelled:
        return AppColors.error;
    }
  }
}
