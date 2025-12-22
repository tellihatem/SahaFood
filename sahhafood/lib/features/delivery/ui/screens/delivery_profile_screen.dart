import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';

/// Delivery profile screen
/// Shows driver info, stats, and settings
class DeliveryProfileScreen extends ConsumerWidget {
  const DeliveryProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryState = ref.watch(deliveryProvider);
    final person = deliveryState.deliveryPerson;

    if (person == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: ArabicText(
            text: 'الملف الشخصي',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            children: [
              // Profile header
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        size: AppDimensions.iconXXLarge,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: person.name,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: AppDimensions.spacing8),
                    ArabicText(
                      text: person.phone,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.delivery_dining,
                      title: 'إجمالي التوصيلات',
                      value: person.totalDeliveries.toString(),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star,
                      title: 'التقييم',
                      value: person.rating.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.spacing16),

              _buildStatCard(
                icon: Icons.attach_money,
                title: 'إجمالي الأرباح',
                value: '${person.totalEarnings.toStringAsFixed(0)} دج',
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Availability toggle
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.toggle_on,
                          color: AppColors.primary,
                          size: AppDimensions.iconLarge,
                        ),
                        SizedBox(width: AppDimensions.spacing12),
                        ArabicText(
                          text: 'متاح للتوصيل',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                    Switch(
                      value: person.isAvailable,
                      onChanged: (value) {
                        ref.read(deliveryProvider.notifier).toggleAvailability();
                      },
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Menu items
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: 'المعلومات الشخصية',
                onTap: () {
                  Navigator.pushNamed(context, '/delivery/personal-info');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.attach_money,
                title: 'الأرباح',
                onTap: () {
                  Navigator.pushNamed(context, '/delivery/earnings');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.history,
                title: 'سجل التوصيلات',
                onTap: () {
                  Navigator.pushNamed(context, '/delivery/history');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.settings,
                title: 'الإعدادات',
                onTap: () {
                  Navigator.pushNamed(context, '/delivery/settings');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.support_agent,
                title: 'الدعم',
                onTap: () {
                  Navigator.pushNamed(context, '/delivery/support');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: 'تسجيل الخروج',
                onTap: () {
                  // Logout logic
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: AppDimensions.iconLarge),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: AppDimensions.spacing4),
          ArabicText(
            text: title,
            fontSize: 12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.spacing16,
          horizontal: AppDimensions.spacing16,
        ),
        margin: EdgeInsets.only(bottom: AppDimensions.spacing8),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.textSecondary,
              size: AppDimensions.iconLarge,
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: ArabicText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
              ),
            ),
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
