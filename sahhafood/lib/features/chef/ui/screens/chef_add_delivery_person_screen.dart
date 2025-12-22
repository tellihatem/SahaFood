import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

/// Chef add delivery person screen
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefAddDeliveryPersonScreen extends ConsumerStatefulWidget {
  const ChefAddDeliveryPersonScreen({super.key});

  @override
  ConsumerState<ChefAddDeliveryPersonScreen> createState() => _ChefAddDeliveryPersonScreenState();
}

class _ChefAddDeliveryPersonScreenState extends ConsumerState<ChefAddDeliveryPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _colorController = TextEditingController();
  
  String _vehicleType = 'دراجة نارية';
  
  final List<String> _vehicleTypes = [
    'دراجة نارية',
    'سيارة',
    'دراجة',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _vehicleModelController.dispose();
    _plateNumberController.dispose();
    _colorController.dispose();
    super.dispose();
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
            text: 'إضافة سائق جديد',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(AppDimensions.spacing20),
            children: [
              // Profile Picture Upload
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Upload photo functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('تحميل الصورة قريباً'),
                              backgroundColor: AppColors.info,
                            ),
                          );
                        },
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
              ),
              
              SizedBox(height: AppDimensions.spacing32),
              
              // Personal info section
              SectionHeader(title: 'المعلومات الشخصية'),
              SizedBox(height: AppDimensions.spacing12),
              
              CustomTextField(
                controller: _nameController,
                hintText: 'الاسم الكامل',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              CustomTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              CustomTextField(
                controller: _emailController,
                hintText: 'البريد الإلكتروني',
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
              
              CustomTextField(
                controller: _idNumberController,
                hintText: 'رقم الهوية',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهوية';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Vehicle info section
              SectionHeader(title: 'معلومات المركبة'),
              SizedBox(height: AppDimensions.spacing12),
              
              // Vehicle type dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _vehicleType,
                    isExpanded: true,
                    items: _vehicleTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(
                              Icons.two_wheeler,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: AppDimensions.spacing12),
                            ArabicText(
                              text: type,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _vehicleType = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              CustomTextField(
                controller: _vehicleModelController,
                hintText: 'الموديل (مثال: Honda, Yamaha)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال موديل المركبة';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              CustomTextField(
                controller: _plateNumberController,
                hintText: 'رقم اللوحة',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم اللوحة';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: AppDimensions.spacing16),
              
              CustomTextField(
                controller: _colorController,
                hintText: 'اللون (اختياري)',
              ),

              SizedBox(height: AppDimensions.spacing32),

              // Info Box
              Container(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: AppDimensions.iconLarge,
                    ),
                    SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: ArabicText(
                        text: 'سيتم إرسال رسالة نصية إلى الموظف تحتوي على بيانات الدخول',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing32),

              // Add button
              CustomButton(
                text: 'إضافة موظف',
                onPressed: _addDeliveryPerson,
                height: 50,
              ),

              SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  void _addDeliveryPerson() {
    if (_formKey.currentState!.validate()) {
      final newPerson = ChefDeliveryPerson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        status: ChefDeliveryPersonStatus.offline,
        vehicle: VehicleInfo(
          type: _vehicleType,
          model: _vehicleModelController.text.trim(),
          plateNumber: _plateNumberController.text.trim(),
          color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        ),
        totalDeliveries: 0,
        rating: 0.0,
        joinedDate: DateTime.now(),
      );

      ref.read(deliveryTeamProvider.notifier).addDeliveryPerson(newPerson);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تمت إضافة السائق بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
