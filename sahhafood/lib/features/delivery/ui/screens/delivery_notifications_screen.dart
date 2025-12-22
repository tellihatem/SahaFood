import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import 'delivery_chat_screen.dart';

/// Delivery notifications screen with different notification types
/// Shows unread count and allows clearing all notifications
class DeliveryNotificationsScreen extends StatefulWidget {
  const DeliveryNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryNotificationsScreen> createState() => _DeliveryNotificationsScreenState();
}

class _DeliveryNotificationsScreenState extends State<DeliveryNotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'new_order',
      'title': 'طلب جديد',
      'message': 'لديك طلب جديد من مطعم البيت العربي',
      'time': 'منذ 5 دقائق',
      'isRead': false,
      'icon': Icons.delivery_dining,
      'color': AppColors.primary,
    },
    {
      'id': '2',
      'type': 'rating',
      'title': 'تقييم جديد',
      'message': 'حصلت على تقييم 5 نجوم من محمد أحمد',
      'time': 'منذ 30 دقيقة',
      'isRead': false,
      'icon': Icons.star,
      'color': AppColors.warning,
    },
    {
      'id': '3',
      'type': 'message',
      'title': 'رسالة جديدة',
      'message': 'أرسلت لك سارة محمود رسالة',
      'time': 'منذ ساعة',
      'isRead': true,
      'icon': Icons.message,
      'color': AppColors.info,
    },
    {
      'id': '4',
      'type': 'order_completed',
      'title': 'تم إكمال الطلب',
      'message': 'تم تسليم الطلب #123450 بنجاح',
      'time': 'منذ ساعتين',
      'isRead': true,
      'icon': Icons.check_circle,
      'color': AppColors.success,
    },
    {
      'id': '5',
      'type': 'new_order',
      'title': 'طلب جديد',
      'message': 'لديك طلب جديد من مطعم الشام',
      'time': 'منذ 3 ساعات',
      'isRead': true,
      'icon': Icons.delivery_dining,
      'color': AppColors.primary,
    },
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification = notifications.firstWhere((notif) => notif['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم مسح جميع الإشعارات'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'] as String;
    
    switch (type) {
      case 'message':
        // Navigate to chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryChatScreen(
              customerName: 'سارة محمود',
            ),
          ),
        );
        break;
      case 'rating':
        // Show rating details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('عرض التقييم'),
            backgroundColor: AppColors.warning,
          ),
        );
        break;
      case 'new_order':
      case 'order_completed':
        // Could navigate to order details if we had the order
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('عرض تفاصيل الطلب'),
            backgroundColor: AppColors.primary,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((notif) => !notif['isRead']).length;

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
            text: 'الإشعارات',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            if (notifications.isNotEmpty)
              TextButton(
                onPressed: _clearAll,
                child: ArabicText(
                  text: 'مسح الكل',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        body: notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: AppDimensions.iconXXLarge,
                      color: AppColors.borderLight,
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: 'لا توجد إشعارات',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (unreadCount > 0)
                    Container(
                      margin: EdgeInsets.all(AppDimensions.spacing16),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing16,
                        vertical: AppDimensions.spacing12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          ArabicText(
                            text: 'لديك $unreadCount إشعار غير مقروء',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;

    return GestureDetector(
      onTap: () {
        _markAsRead(notification['id']);
        _handleNotificationTap(notification);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isRead ? AppColors.borderLight : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: (notification['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                notification['icon'],
                color: notification['color'],
                size: AppDimensions.iconLarge,
              ),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        text: notification['title'],
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      if (!isRead)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: notification['message'],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  ArabicText(
                    text: notification['time'],
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

