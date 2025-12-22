import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Chef notifications screen
/// Follows architecture rules: uses constants, shared widgets
class ChefNotificationsScreen extends StatefulWidget {
  const ChefNotificationsScreen({super.key});

  @override
  State<ChefNotificationsScreen> createState() => _ChefNotificationsScreenState();
}

class _ChefNotificationsScreenState extends State<ChefNotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'new_order',
      'title': 'طلب جديد',
      'message': 'لديك طلب جديد #1237',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
    {
      'id': '2',
      'type': 'review',
      'title': 'تقييم جديد',
      'message': 'حصلت على تقييم 5 نجوم من أحمد محمد',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': false,
    },
    {
      'id': '3',
      'type': 'delivery',
      'title': 'تم التوصيل',
      'message': 'تم توصيل الطلب #1230 بنجاح',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
    {
      'id': '4',
      'type': 'earnings',
      'title': 'الأرباح اليومية',
      'message': 'أرباحك اليوم: 25,000 دج',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
    },
  ];

  void _markAsRead(String id) {
    setState(() {
      final notif = notifications.firstWhere((n) => n['id'] == id);
      notif['isRead'] = true;
    });
  }

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;

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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          actions: [
            if (notifications.isNotEmpty)
              TextButton(
                onPressed: _clearAll,
                child: ArabicText(
                  text: 'مسح الكل',
                  fontSize: 14,
                  color: AppColors.error,
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
                      Icons.notifications_off_outlined,
                      size: AppDimensions.iconXXLarge,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: 'لا توجد إشعارات',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (unreadCount > 0)
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spacing12),
                      margin: EdgeInsets.all(AppDimensions.spacing20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: AppDimensions.spacing8),
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
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return _buildNotificationCard(notif);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final isRead = notif['isRead'] as bool;
    final type = notif['type'] as String;

    return GestureDetector(
      onTap: () => _markAsRead(notif['id']),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isRead ? AppColors.borderLight : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                _getTypeIcon(type),
                color: _getTypeColor(type),
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
                        text: notif['title'],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  ArabicText(
                    text: notif['message'],
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    maxLines: 2,
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  ArabicText(
                    text: _formatTime(notif['time']),
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'new_order':
        return Icons.receipt_long;
      case 'review':
        return Icons.star;
      case 'delivery':
        return Icons.delivery_dining;
      case 'earnings':
        return Icons.attach_money;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'new_order':
        return AppColors.primary;
      case 'review':
        return AppColors.warning;
      case 'delivery':
        return AppColors.success;
      case 'earnings':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
