import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'edit_profile_screen.dart';

/// Personal info screen - displays user profile information
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

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
            text: 'المعلومات الشخصية',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              child: ArabicText(
                text: 'تعديل',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spacing24),
              
              // Profile picture
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
              
              SizedBox(height: AppDimensions.spacing32),
              
              // Information fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                child: Column(
                  children: [
                    _InfoField(
                      label: 'الاسم الكامل',
                      value: profile?.name ?? 'غير متوفر',
                      icon: Icons.person_outline,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing16),
                    
                    _InfoField(
                      label: 'البريد الإلكتروني',
                      value: profile?.email ?? 'غير متوفر',
                      icon: Icons.email_outlined,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing16),
                    
                    _InfoField(
                      label: 'رقم الهاتف',
                      value: profile?.phone ?? 'غير متوفر',
                      icon: Icons.phone_outlined,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing16),
                    
                    _InfoField(
                      label: 'الجنس',
                      value: profile?.gender ?? 'غير محدد',
                      icon: Icons.wc_outlined,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing16),
                    
                    _InfoField(
                      label: 'تاريخ الميلاد',
                      value: profile?.dateOfBirth != null
                          ? '${profile!.dateOfBirth!.day}/${profile.dateOfBirth!.month}/${profile.dateOfBirth!.year}'
                          : 'غير محدد',
                      icon: Icons.cake_outlined,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppDimensions.spacing32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info field widget
class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconMedium,
            ),
          ),
          SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: label,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: value,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
