import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Delivery settings screen with preferences
/// Manages notifications, alerts, and work preferences
class DeliverySettingsScreen extends StatefulWidget {
  const DeliverySettingsScreen({super.key});

  @override
  State<DeliverySettingsScreen> createState() => _DeliverySettingsScreenState();
}

class _DeliverySettingsScreenState extends State<DeliverySettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _orderAlerts = true;
  bool _messageAlerts = true;
  bool _ratingAlerts = true;
  bool _locationTracking = true;
  bool _autoAcceptOrders = false;

  @override
  Widget build(BuildContext context) {
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
            text: 'الإعدادات',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications Section
              SectionHeader(title: 'الإشعارات'),
              SizedBox(height: AppDimensions.spacing12),
              _buildSwitchTile(
                icon: Icons.notifications_active,
                title: 'إشعارات الدفع',
                subtitle: 'تلقي إشعارات فورية على الجهاز',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: 'إشعارات البريد الإلكتروني',
                subtitle: 'تلقي التحديثات عبر البريد',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.sms_outlined,
                title: 'إشعارات الرسائل النصية',
                subtitle: 'تلقي رسائل نصية للطلبات',
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Alert Preferences
              SectionHeader(title: 'تفضيلات التنبيهات'),
              SizedBox(height: AppDimensions.spacing12),
              _buildSwitchTile(
                icon: Icons.delivery_dining,
                title: 'تنبيهات الطلبات',
                subtitle: 'إشعار عند وصول طلب جديد',
                value: _orderAlerts,
                onChanged: (value) {
                  setState(() {
                    _orderAlerts = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.message_outlined,
                title: 'تنبيهات الرسائل',
                subtitle: 'إشعار عند وصول رسالة جديدة',
                value: _messageAlerts,
                onChanged: (value) {
                  setState(() {
                    _messageAlerts = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.star_outline,
                title: 'تنبيهات التقييمات',
                subtitle: 'إشعار عند الحصول على تقييم',
                value: _ratingAlerts,
                onChanged: (value) {
                  setState(() {
                    _ratingAlerts = value;
                  });
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Work Preferences
              SectionHeader(title: 'تفضيلات العمل'),
              SizedBox(height: AppDimensions.spacing12),
              _buildSwitchTile(
                icon: Icons.location_on_outlined,
                title: 'تتبع الموقع',
                subtitle: 'السماح بتتبع موقعك أثناء التوصيل',
                value: _locationTracking,
                onChanged: (value) {
                  setState(() {
                    _locationTracking = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.auto_awesome,
                title: 'قبول الطلبات تلقائياً',
                subtitle: 'قبول الطلبات الجديدة بشكل تلقائي',
                value: _autoAcceptOrders,
                onChanged: (value) {
                  setState(() {
                    _autoAcceptOrders = value;
                  });
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // App Info
              SectionHeader(title: 'معلومات التطبيق'),
              SizedBox(height: AppDimensions.spacing12),
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'الإصدار',
                value: '1.0.0',
              ),
              _buildInfoTile(
                icon: Icons.privacy_tip_outlined,
                title: 'سياسة الخصوصية',
                value: '',
                onTap: () {},
              ),
              _buildInfoTile(
                icon: Icons.description_outlined,
                title: 'الشروط والأحكام',
                value: '',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppDimensions.iconLarge,
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: AppDimensions.iconLarge,
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: ArabicText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (value.isNotEmpty)
              ArabicText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            if (onTap != null)
              Icon(
                Icons.arrow_back_ios,
                size: AppDimensions.iconSmall,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
