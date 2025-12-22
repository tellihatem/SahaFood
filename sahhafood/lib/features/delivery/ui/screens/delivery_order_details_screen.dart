import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'delivery_chat_screen.dart';

/// Delivery order details screen with map and actions
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class DeliveryOrderDetailsScreen extends ConsumerWidget {
  final DeliveryOrder order;

  const DeliveryOrderDetailsScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  void _openMaps() async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(order.customerAddress)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _makePhoneCall() async {
    final url = Uri.parse('tel:${order.customerPhone}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Map section
            Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusLarge),
                  bottomRight: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
              child: Stack(
                children: [
                  // Map from online source
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppDimensions.radiusLarge),
                      bottomRight: Radius.circular(AppDimensions.radiusLarge),
                    ),
                    child: Image.network(
                      'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/3.0588,36.7538,12,0/400x300@2x?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppColors.primary,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.map,
                            size: AppDimensions.iconXXLarge,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  // Back button and navigation
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: AppDimensions.iconButtonSize,
                              height: AppDimensions.iconButtonSize,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: AppDimensions.iconSmall,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openMaps,
                            child: Container(
                              width: AppDimensions.iconButtonSize,
                              height: AppDimensions.iconButtonSize,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.navigation,
                                size: AppDimensions.iconMedium,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Order details
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ArabicText(
                          text: '#${order.id}',
                          fontSize: 20,
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

                    SizedBox(height: AppDimensions.spacing24),

                    // Restaurant info
                    _buildInfoSection(
                      icon: Icons.restaurant,
                      title: 'المطعم',
                      value: order.restaurantName,
                    ),

                    SizedBox(height: AppDimensions.spacing16),

                    // Customer info with contact buttons
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: AppDimensions.iconMedium,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: AppDimensions.spacing8),
                              ArabicText(
                                text: 'معلومات العميل',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          ArabicText(
                            text: order.customerName,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: AppDimensions.spacing8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: AppDimensions.iconSmall,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: AppDimensions.spacing4),
                              Expanded(
                                child: ArabicText(
                                  text: order.customerAddress,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'اتصال',
                                  onPressed: _makePhoneCall,
                                  height: 44,
                                  width: double.infinity,
                                ),
                              ),
                              SizedBox(width: AppDimensions.spacing12),
                              Expanded(
                                child: CustomButton(
                                  text: 'محادثة',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeliveryChatScreen(
                                          customerName: order.customerName,
                                          orderId: '#${order.id}',
                                        ),
                                      ),
                                    );
                                  },
                                  height: 44,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacing16),

                    // Order details
                    _buildInfoSection(
                      icon: Icons.access_time,
                      title: 'وقت الطلب',
                      value: _formatTime(order.orderTime),
                    ),

                    SizedBox(height: AppDimensions.spacing16),

                    _buildInfoSection(
                      icon: Icons.shopping_bag_outlined,
                      title: 'عدد العناصر',
                      value: '${order.items.length} عناصر',
                    ),

                    SizedBox(height: AppDimensions.spacing16),

                    _buildInfoSection(
                      icon: Icons.attach_money,
                      title: 'المبلغ الإجمالي',
                      value: '${order.totalAmount.toStringAsFixed(0)} دج',
                    ),

                    SizedBox(height: AppDimensions.spacing24),

                    // Status update buttons
                    if (order.status != DeliveryOrderStatus.delivered) ...[
                      ArabicText(
                        text: 'تحديث حالة الطلب',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppDimensions.spacing16),
                      if (order.status == DeliveryOrderStatus.pending)
                        CustomButton(
                          text: 'قبول الطلب',
                          onPressed: () {
                            ref.read(deliveryProvider.notifier).acceptOrder(order.id);
                            Navigator.pop(context);
                          },
                          width: double.infinity,
                        ),
                      if (order.status == DeliveryOrderStatus.accepted)
                        CustomButton(
                          text: 'تم الاستلام',
                          onPressed: () {
                            ref.read(deliveryProvider.notifier).markAsPickedUp(order.id);
                            Navigator.pop(context);
                          },
                          width: double.infinity,
                        ),
                      if (order.status == DeliveryOrderStatus.pickedUp)
                        CustomButton(
                          text: 'في الطريق',
                          onPressed: () {
                            ref.read(deliveryProvider.notifier).markAsOnTheWay(order.id);
                            Navigator.pop(context);
                          },
                          width: double.infinity,
                        ),
                      if (order.status == DeliveryOrderStatus.onTheWay)
                        CustomButton(
                          text: 'تم التوصيل',
                          onPressed: () {
                            ref.read(deliveryProvider.notifier).completeDelivery(order.id);
                            Navigator.pop(context);
                          },
                          width: double.infinity,
                        ),
                    ],

                    if (order.status == DeliveryOrderStatus.delivered) ...[
                      Container(
                        padding: EdgeInsets.all(AppDimensions.spacing16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: AppDimensions.iconLarge,
                            ),
                            SizedBox(width: AppDimensions.spacing12),
                            Expanded(
                              child: ArabicText(
                                text: 'تم توصيل الطلب بنجاح',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconMedium,
          color: AppColors.primary,
        ),
        SizedBox(width: AppDimensions.spacing12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArabicText(
              text: title,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 2.h),
            ArabicText(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ],
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

