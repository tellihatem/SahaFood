import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'delivery_order_details_screen.dart';
import 'delivery_notifications_screen.dart';

/// Delivery home screen showing orders by status
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class DeliveryHomeScreen extends ConsumerStatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  ConsumerState<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends ConsumerState<DeliveryHomeScreen> {
  String selectedTab = 'pending'; // pending, in_progress, completed

  @override
  Widget build(BuildContext context) {
    final deliveryState = ref.watch(deliveryProvider);
    final currentOrders = _getCurrentOrders(deliveryState);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: ArabicText(
            text: 'طلبات التوصيل',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeliveryNotificationsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Status tabs
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing24,
                vertical: AppDimensions.spacing16,
              ),
              padding: EdgeInsets.all(AppDimensions.spacing4),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  _buildTabButton('قيد الانتظار', 'pending'),
                  _buildTabButton('جاري التوصيل', 'in_progress'),
                  _buildTabButton('مكتمل', 'completed'),
                ],
              ),
            ),

            // Orders list
            Expanded(
              child: currentOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing24,
                      ),
                      itemCount: currentOrders.length,
                      itemBuilder: (context, index) {
                        final order = currentOrders[index];
                        return _buildOrderCard(order);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<DeliveryOrder> _getCurrentOrders(DeliveryState state) {
    switch (selectedTab) {
      case 'pending':
        return state.activeOrders
            .where((o) => o.status == DeliveryOrderStatus.pending)
            .toList();
      case 'in_progress':
        return state.activeOrders
            .where((o) =>
                o.status == DeliveryOrderStatus.accepted ||
                o.status == DeliveryOrderStatus.pickedUp ||
                o.status == DeliveryOrderStatus.onTheWay)
            .toList();
      case 'completed':
        return state.completedOrders;
      default:
        return state.activeOrders;
    }
  }

  Widget _buildTabButton(String title, String tab) {
    final isSelected = selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tab;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
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

  Widget _buildOrderCard(DeliveryOrder order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryOrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(
            color: AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
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
                  text: '#${order.id}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: ArabicText(
                    text: order.status.displayName,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.spacing12),

            // Restaurant name
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: AppDimensions.iconSmall,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppDimensions.spacing8),
                Expanded(
                  child: ArabicText(
                    text: order.restaurantName,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.spacing8),

            // Customer info
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: AppDimensions.iconSmall,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppDimensions.spacing8),
                Expanded(
                  child: ArabicText(
                    text: order.customerName,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.spacing8),

            // Address
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: AppDimensions.iconSmall,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: AppDimensions.spacing8),
                Expanded(
                  child: ArabicText(
                    text: order.customerAddress,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.spacing12),

            // Order details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: AppDimensions.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppDimensions.spacing4),
                    ArabicText(
                      text: _formatTime(order.orderTime),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: AppDimensions.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppDimensions.spacing4),
                    ArabicText(
                      text: '${order.items.length} عناصر',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: AppDimensions.iconSmall,
                      color: AppColors.success,
                    ),
                    SizedBox(width: AppDimensions.spacing4),
                    ArabicText(
                      text: '${order.totalAmount.toStringAsFixed(0)} دج',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delivery_dining,
            size: AppDimensions.iconXXLarge,
            color: AppColors.borderLight,
          ),
          SizedBox(height: AppDimensions.spacing16),
          ArabicText(
            text: 'لا توجد طلبات',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: 'سيتم عرض الطلبات الجديدة هنا',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.pending:
        return AppColors.warning;
      case DeliveryOrderStatus.accepted:
      case DeliveryOrderStatus.pickedUp:
      case DeliveryOrderStatus.onTheWay:
        return AppColors.info;
      case DeliveryOrderStatus.delivered:
        return AppColors.success;
      case DeliveryOrderStatus.cancelled:
        return AppColors.error;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
