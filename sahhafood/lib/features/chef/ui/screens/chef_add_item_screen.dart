import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

/// Chef add item screen for adding new food items
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefAddItemScreen extends ConsumerStatefulWidget {
  const ChefAddItemScreen({super.key});

  @override
  ConsumerState<ChefAddItemScreen> createState() => _ChefAddItemScreenState();
}

class _ChefAddItemScreenState extends ConsumerState<ChefAddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  FoodCategory _selectedCategory = FoodCategory.lunch;
  bool _isAvailable = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _prepTimeController.dispose();
    _imageUrlController.dispose();
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
            text: 'إضافة عنصر جديد',
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
              // Name
              SectionHeader(title: 'اسم الطبق'),
              SizedBox(height: AppDimensions.spacing12),
              CustomTextField(
                controller: _nameController,
                hintText: 'مثال: برجر لحم',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم الطبق';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Description
              SectionHeader(title: 'الوصف'),
              SizedBox(height: AppDimensions.spacing12),
              CustomTextField(
                controller: _descriptionController,
                hintText: 'وصف الطبق والمكونات',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال وصف الطبق';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Price and prep time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(title: 'السعر (دج)'),
                        SizedBox(height: AppDimensions.spacing12),
                        CustomTextField(
                          controller: _priceController,
                          hintText: '1200',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال السعر';
                            }
                            if (double.tryParse(value) == null) {
                              return 'سعر غير صحيح';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(title: 'وقت التحضير (دقيقة)'),
                        SizedBox(height: AppDimensions.spacing12),
                        CustomTextField(
                          controller: _prepTimeController,
                          hintText: '30',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الوقت';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Category
              SectionHeader(title: 'الفئة'),
              SizedBox(height: AppDimensions.spacing12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FoodCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: FoodCategory.values.where((c) => c != FoodCategory.all).map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: ArabicText(
                          text: category.displayName,
                          fontSize: 16,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacing24),

              // Image URL
              SectionHeader(title: 'رابط الصورة'),
              SizedBox(height: AppDimensions.spacing12),
              CustomTextField(
                controller: _imageUrlController,
                hintText: 'https://example.com/image.jpg',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رابط الصورة';
                  }
                  return null;
                },
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
                    ArabicText(
                      text: 'متاح للطلب',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Switch(
                      value: _isAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                        });
                      },
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacing32),

              // Add button
              CustomButton(
                text: 'إضافة الطبق',
                onPressed: _addItem,
                height: 50,
              ),

              SizedBox(height: AppDimensions.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        imageUrl: _imageUrlController.text.trim(),
        isAvailable: _isAvailable,
        preparationTime: int.parse(_prepTimeController.text.trim()),
        rating: 0.0,
        reviewsCount: 0,
        ingredients: [],
      );

      ref.read(foodProvider.notifier).addItem(newItem);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تمت إضافة الطبق بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
