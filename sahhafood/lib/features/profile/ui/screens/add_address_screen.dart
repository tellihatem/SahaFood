import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

/// Add address screen - form to add new delivery address
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _instructionsController = TextEditingController();
  
  String selectedLabel = 'المنزل';

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Map section
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.spacing24),
                  bottomRight: Radius.circular(AppDimensions.spacing24),
                ),
              ),
              child: Stack(
                children: [
                  // Map placeholder
                  Center(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?w=800',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.backgroundGrey,
                          child: Center(
                            child: Icon(
                              Icons.map,
                              size: 60,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Back button
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textPrimary.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Form section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArabicText(
                        text: 'نوع العنوان',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing12),
                      
                      // Label selector
                      Row(
                        children: [
                          _LabelChip(
                            label: 'المنزل',
                            icon: Icons.home_outlined,
                            isSelected: selectedLabel == 'المنزل',
                            onTap: () => setState(() => selectedLabel = 'المنزل'),
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          _LabelChip(
                            label: 'العمل',
                            icon: Icons.work_outline,
                            isSelected: selectedLabel == 'العمل',
                            onTap: () => setState(() => selectedLabel = 'العمل'),
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          _LabelChip(
                            label: 'آخر',
                            icon: Icons.location_on_outlined,
                            isSelected: selectedLabel == 'آخر',
                            onTap: () => setState(() => selectedLabel = 'آخر'),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: AppDimensions.spacing24),
                      
                      ArabicText(
                        text: 'تفاصيل العنوان',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing12),
                      
                      CustomTextField(
                        controller: _addressController,
                        hintText: 'العنوان الكامل',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال العنوان';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _buildingController,
                              hintText: 'المبنى',
                            ),
                          ),
                          SizedBox(width: AppDimensions.spacing12),
                          Expanded(
                            child: CustomTextField(
                              controller: _floorController,
                              hintText: 'الطابق',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      CustomTextField(
                        controller: _apartmentController,
                        hintText: 'رقم الشقة',
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      CustomTextField(
                        controller: _instructionsController,
                        hintText: 'ملاحظات إضافية (اختياري)',
                        maxLines: 3,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing32),
                      
                      CustomButton(
                        text: 'حفظ العنوان',
                        onPressed: _saveAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: selectedLabel,
        fullAddress: _addressController.text,
        building: _buildingController.text.isEmpty ? null : _buildingController.text,
        floor: _floorController.text.isEmpty ? null : _floorController.text,
        apartment: _apartmentController.text.isEmpty ? null : _apartmentController.text,
        additionalInstructions: _instructionsController.text.isEmpty 
            ? null 
            : _instructionsController.text,
        isDefault: false,
      );

      final success = await ref.read(addressProvider.notifier).addAddress(newAddress);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم إضافة العنوان بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('حدث خطأ أثناء إضافة العنوان'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

/// Label chip widget
class _LabelChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LabelChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
            vertical: AppDimensions.spacing12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconMedium,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              SizedBox(width: AppDimensions.spacing8),
              ArabicText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
