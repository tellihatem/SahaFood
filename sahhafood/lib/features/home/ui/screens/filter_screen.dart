import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';

/// Filter screen - filter restaurants by criteria
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    final criteria = filterState.criteria;

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
            text: 'تصفية',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                ref.read(filterProvider.notifier).resetFilters();
              },
              child: ArabicText(
                text: 'إعادة تعيين',
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort by
                    ArabicText(
                      text: 'ترتيب حسب',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    ...SortBy.values.map((sortBy) {
                      return RadioListTile<SortBy>(
                        contentPadding: EdgeInsets.zero,
                        title: ArabicText(
                          text: sortBy.displayName,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        value: sortBy,
                        groupValue: criteria.sortBy,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(filterProvider.notifier).updateSortBy(value);
                          }
                        },
                      );
                    }).toList(),
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Rating filter
                    ArabicText(
                      text: 'التقييم',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    Wrap(
                      spacing: AppDimensions.spacing12,
                      children: [4.5, 4.0, 3.5, 3.0].map((rating) {
                        final isSelected = criteria.minRating == rating;
                        return GestureDetector(
                          onTap: () {
                            ref.read(filterProvider.notifier).updateMinRating(
                              isSelected ? null : rating,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing16,
                              vertical: AppDimensions.spacing12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: isSelected ? AppColors.white : AppColors.warning,
                                ),
                                SizedBox(width: 4),
                                ArabicText(
                                  text: rating.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Free delivery
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: ArabicText(
                        text: 'توصيل مجاني فقط',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      value: criteria.freeDeliveryOnly,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        ref.read(filterProvider.notifier).toggleFreeDelivery();
                      },
                    ),
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Cuisine types
                    ArabicText(
                      text: 'نوع المطبخ',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    Wrap(
                      spacing: AppDimensions.spacing12,
                      runSpacing: AppDimensions.spacing12,
                      children: ['بيتزا', 'برجر', 'سوشي', 'شاورما', 'دجاج', 'سلطات'].map((type) {
                        final isSelected = criteria.cuisineTypes.contains(type);
                        return GestureDetector(
                          onTap: () {
                            ref.read(filterProvider.notifier).toggleCuisineType(type);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing16,
                              vertical: AppDimensions.spacing12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ArabicText(
                              text: type,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.white : AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Apply button
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing24),
              child: CustomButton(
                text: 'تطبيق الفلاتر',
                onPressed: () async {
                  await ref.read(filterProvider.notifier).applyFilters();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
