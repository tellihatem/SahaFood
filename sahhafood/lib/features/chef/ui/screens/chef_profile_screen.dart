import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import 'chef_food_list_screen.dart';
import 'chef_delivery_team_screen.dart';
import 'chef_reviews_screen.dart';

/// Chef profile screen with settings and navigation
/// Follows architecture rules: uses constants, shared widgets
class ChefProfileScreen extends StatelessWidget {
  const ChefProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: EdgeInsets.all(AppDimensions.spacing24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.restaurant,
                          size: AppDimensions.iconXXLarge,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacing16),
                      ArabicText(
                        text: 'مطعم الأصالة',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.white,
                            size: 20,
                          ),
                          SizedBox(width: AppDimensions.spacing4),
                          ArabicText(
                            text: '4.8 (156 تقييم)',
                            fontSize: 16,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.spacing24),

                // Menu items
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.restaurant_menu,
                        title: 'قائمة الطعام',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChefFoodListScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.delivery_dining,
                        title: 'فريق التوصيل',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChefDeliveryTeamScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.star_outline,
                        title: 'التقييمات',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChefReviewsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        title: 'الإعدادات',
                        onTap: () {
                          // Settings screen
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'المساعدة والدعم',
                        onTap: () {
                          // Help screen
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.logout,
                        title: 'تسجيل الخروج',
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ),
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
        padding: EdgeInsets.all(AppDimensions.spacing16),
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const ArabicText(
            text: 'تسجيل الخروج',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: const ArabicText(
            text: 'هل أنت متأكد من تسجيل الخروج؟',
            fontSize: 14,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ArabicText(
                text: 'إلغاء',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: ArabicText(
                text: 'تسجيل الخروج',
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
