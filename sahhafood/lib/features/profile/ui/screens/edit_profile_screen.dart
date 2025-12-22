import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';

/// Edit profile screen - form to update user profile information
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    selectedGender = profile?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            text: 'تعديل الملف الشخصي',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppDimensions.spacing24),
              
              // Profile picture with edit button
              Stack(
                children: [
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppDimensions.spacing32),
              
              // Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArabicText(
                        text: 'الاسم الكامل',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'أدخل اسمك الكامل',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      ArabicText(
                        text: 'البريد الإلكتروني',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'أدخل بريدك الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'بريد إلكتروني غير صحيح';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      ArabicText(
                        text: 'رقم الهاتف',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      CustomTextField(
                        controller: _phoneController,
                        hintText: 'أدخل رقم هاتفك',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      ArabicText(
                        text: 'الجنس',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppDimensions.spacing8),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _GenderOption(
                              label: 'ذكر',
                              isSelected: selectedGender == 'ذكر',
                              onTap: () => setState(() => selectedGender = 'ذكر'),
                            ),
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          Expanded(
                            child: _GenderOption(
                              label: 'أنثى',
                              isSelected: selectedGender == 'أنثى',
                              onTap: () => setState(() => selectedGender = 'أنثى'),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: AppDimensions.spacing32),
                      
                      if (profileState.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        CustomButton(
                          text: 'حفظ التغييرات',
                          onPressed: _saveProfile,
                        ),
                      
                      SizedBox(height: AppDimensions.spacing24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تحميل الصورة قريباً'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = ref.read(profileProvider).profile;
      if (profile == null) return;

      final updatedProfile = profile.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: selectedGender,
      );

      final success = await ref
          .read(profileProvider.notifier)
          .updateProfile(updatedProfile);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم حفظ التغييرات بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('حدث خطأ أثناء حفظ التغييرات'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

/// Gender option widget
class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Center(
          child: ArabicText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
