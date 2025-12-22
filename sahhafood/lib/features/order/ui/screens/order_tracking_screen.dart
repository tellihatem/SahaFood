import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'chat_screen.dart';

/// Order tracking screen - displays order progress and driver info
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final order = orderState.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        body: Center(
          child: ArabicText(
            text: 'الطلب غير موجود',
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Map section
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.spacing24),
                  bottomRight: Radius.circular(AppDimensions.spacing24),
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder for map
                  Center(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?w=800',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.backgroundGrey,
                          child: Center(
                            child: Icon(
                              Icons.map,
                              size: 60,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Back button
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textPrimary.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Delivery person card
                  if (order.driverName != null)
                    Positioned(
                      bottom: AppDimensions.spacing16,
                      left: AppDimensions.spacing16,
                      right: AppDimensions.spacing16,
                      child: _DriverCard(order: order),
                    ),
                ],
              ),
            ),
            
            // Order tracking details
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: 'تتبع الطلب',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing8),
                    
                    ArabicText(
                      text: 'رقم الطلب: ${order.orderNumber}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Order steps
                    _OrderSteps(status: order.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Driver card widget
class _DriverCard extends ConsumerWidget {
  final Order order;

  const _DriverCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: order.driverImageUrl != null
                  ? Image.network(
                      order.driverImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: AppColors.textSecondary,
                          size: 30,
                        );
                      },
                    )
                  : Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 30,
                    ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacing12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: order.driverName ?? 'السائق',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: AppDimensions.spacing4),
                    ArabicText(
                      text: '4.8',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Call button
          GestureDetector(
            onTap: () {
              // Call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('الاتصال بـ ${order.driverName}'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                Icons.phone,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacing8),
          
          // Message button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(orderId: order.id),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                Icons.message,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Order steps widget
class _OrderSteps extends StatelessWidget {
  final OrderStatus status;

  const _OrderSteps({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step['completed']
                        ? AppColors.primary
                        : AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: step['completed']
                          ? AppColors.primary
                          : AppColors.borderLight,
                      width: 2,
                    ),
                  ),
                  child: step['completed']
                      ? Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 14,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: step['completed']
                        ? AppColors.primary
                        : AppColors.borderLight,
                  ),
              ],
            ),
            
            SizedBox(width: AppDimensions.spacing12),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: step['title'],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: step['completed']
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    if (step['time'] != null && step['time'].isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: AppDimensions.spacing4),
                        child: ArabicText(
                          text: step['time'],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getSteps() {
    final now = DateTime.now();
    
    return [
      {
        'title': 'تم استلام الطلب',
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        'completed': status.index >= OrderStatus.confirmed.index,
      },
      {
        'title': 'جاري التحضير',
        'time': status.index >= OrderStatus.preparing.index 
            ? '${now.hour}:${(now.minute + 15).toString().padLeft(2, '0')}'
            : '',
        'completed': status.index >= OrderStatus.preparing.index,
      },
      {
        'title': 'في الطريق',
        'time': status.index >= OrderStatus.onTheWay.index
            ? '${now.hour}:${(now.minute + 30).toString().padLeft(2, '0')}'
            : '',
        'completed': status.index >= OrderStatus.onTheWay.index,
      },
      {
        'title': 'تم التوصيل',
        'time': '',
        'completed': status == OrderStatus.delivered,
      },
    ];
  }
}
