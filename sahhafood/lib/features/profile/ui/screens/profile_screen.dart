import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'personal_info_screen.dart';
import 'addresses_screen.dart';
import '../../../cart/ui/screens/cart_screen.dart';

/// Profile screen - main profile menu
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'المعلومات الشخصية',
        'screen': const PersonalInfoScreen(),
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'عناويني',
        'screen': const AddressesScreen(),
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'طلباتي',
        'screen': null,
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'طرق الدفع',
        'screen': null,
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'المفضلة',
        'screen': null,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'الإشعارات',
        'screen': null,
      },
      {
        'icon': Icons.help_outline,
        'title': 'المساعدة',
        'screen': null,
      },
      {
        'icon': Icons.info_outline,
        'title': 'حول',
        'screen': null,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: ArabicText(
            text: 'الملف الشخصي',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textPrimary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spacing24),
              
              // Profile header
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: profile?.profileImageUrl != null
                      ? Image.network(
                          profile!.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primary,
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              ArabicText(
                text: profile?.name ?? 'المستخدم',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              
              SizedBox(height: AppDimensions.spacing4),
              
              ArabicText(
                text: profile?.email ?? 'user@example.com',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              
              SizedBox(height: AppDimensions.spacing32),
              
              // Menu items
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.borderLight,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppDimensions.spacing12,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppColors.primary,
                        size: AppDimensions.iconMedium,
                      ),
                    ),
                    title: ArabicText(
                      text: item['title'],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    trailing: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    onTap: () {
                      if (item['screen'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['screen'] as Widget,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              
              SizedBox(height: AppDimensions.spacing24),
              
              // Logout button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                child: CustomButton(
                  text: 'تسجيل الخروج',
                  onPressed: () => _showLogoutDialog(context, ref),
                  backgroundColor: AppColors.error,
                ),
              ),
              
              SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ArabicText(
            text: 'تسجيل الخروج',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: ArabicText(
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
              onPressed: () async {
                await ref.read(profileProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pop(context);
                  // Navigate to login screen
                  // Navigator.pushReplacementNamed(context, '/login');
                }
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
