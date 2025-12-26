import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../../navigation/screens/main_navigation_screen.dart';
import '../../../chef/navigation/chef_navigation_screen.dart';
import '../../../delivery/navigation/delivery_navigation.dart';

/// Role selection screen for restaurant and delivery users
/// Allows switching between client and their professional interface
class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userRole = authState.user.role;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing24,
              vertical: AppDimensions.spacing24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 80.w,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppDimensions.spacing24),
                Text(
                  'اختر نوع الحساب',
                  style: AppTextStyles.displayMedium,
                ),
                SizedBox(height: AppDimensions.spacing12),
                Text(
                  'مرحباً ${authState.user.fullName ?? ""}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppDimensions.spacing48),
                
                // Client role button - always available
                _RoleCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'عميل',
                  description: 'تصفح المطاعم واطلب الطعام',
                  color: AppColors.success,
                  onTap: () {
                    ref.read(authProvider.notifier).setUserRole(UserRole.user);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppDimensions.spacing16),
                
                // Restaurant role button - only for restaurant users
                if (userRole == UserRole.restaurant)
                  _RoleCard(
                    icon: Icons.restaurant,
                    title: 'طاهي / بائع',
                    description: 'إدارة المطعم والطلبات والقائمة',
                    color: AppColors.primary,
                    onTap: () {
                      ref.read(authProvider.notifier).setUserRole(UserRole.restaurant);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ChefNavigationScreen(),
                        ),
                      );
                    },
                  ),
                
                if (userRole == UserRole.restaurant)
                  SizedBox(height: AppDimensions.spacing16),
                
                // Delivery role button - only for delivery users
                if (userRole == UserRole.delivery)
                  _RoleCard(
                    icon: Icons.delivery_dining,
                    title: 'موظف توصيل',
                    description: 'توصيل الطلبات للعملاء',
                    color: AppColors.info,
                    onTap: () {
                      ref.read(authProvider.notifier).setUserRole(UserRole.delivery);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DeliveryNavigation(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconXLarge,
                color: color,
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headlineSmall,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              size: AppDimensions.iconMedium,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
