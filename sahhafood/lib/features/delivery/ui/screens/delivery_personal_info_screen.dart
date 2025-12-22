import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';

/// Delivery personal info screen with editable fields
/// Shows driver profile and vehicle information
class DeliveryPersonalInfoScreen extends ConsumerStatefulWidget {
  const DeliveryPersonalInfoScreen({super.key});

  @override
  ConsumerState<DeliveryPersonalInfoScreen> createState() => _DeliveryPersonalInfoScreenState();
}

class _DeliveryPersonalInfoScreenState extends ConsumerState<DeliveryPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehiclePlateController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final person = ref.read(deliveryProvider).deliveryPerson;
    _nameController = TextEditingController(text: person?.name ?? '');
    _phoneController = TextEditingController(text: person?.phone ?? '');
    _vehicleTypeController = TextEditingController(text: person?.vehicleType ?? '');
    _vehiclePlateController = TextEditingController(text: person?.vehicleNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _vehicleTypeController.dispose();
    _vehiclePlateController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ التغييرات بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
            text: 'المعلومات الشخصية',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            if (!_isEditing)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 22.w,
                ),
                onPressed: _toggleEdit,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50.w,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 32.w,
                              height: 32.w,
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
                                size: 16.w,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.spacing32),

                // Personal Information
                SectionHeader(title: 'المعلومات الشخصية'),
                SizedBox(height: AppDimensions.spacing16),

                ArabicText(
                  text: 'الاسم الكامل',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing8),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'أدخل الاسم الكامل',
                  enabled: _isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppDimensions.spacing16),

                ArabicText(
                  text: 'رقم الهاتف',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing8),
                CustomTextField(
                  controller: _phoneController,
                  hintText: 'أدخل رقم الهاتف',
                  enabled: _isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppDimensions.spacing24),

                // Vehicle Information
                SectionHeader(title: 'معلومات المركبة'),
                SizedBox(height: AppDimensions.spacing16),

                ArabicText(
                  text: 'نوع المركبة',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing8),
                CustomTextField(
                  controller: _vehicleTypeController,
                  hintText: 'مثال: دراجة نارية',
                  enabled: _isEditing,
                ),

                SizedBox(height: AppDimensions.spacing16),

                ArabicText(
                  text: 'رقم اللوحة',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: AppDimensions.spacing8),
                CustomTextField(
                  controller: _vehiclePlateController,
                  hintText: 'أدخل رقم اللوحة',
                  enabled: _isEditing,
                ),

                SizedBox(height: AppDimensions.spacing32),

                // Save button (only visible when editing)
                if (_isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'حفظ',
                          onPressed: _saveChanges,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _toggleEdit,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                            padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
                          ),
                          child: ArabicText(
                            text: 'إلغاء',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
