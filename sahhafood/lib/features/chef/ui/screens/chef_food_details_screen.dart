import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

/// Chef food details screen for viewing/editing food item
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefFoodDetailsScreen extends ConsumerWidget {
  final FoodItem item;

  const ChefFoodDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: CustomScrollView(
          slivers: [
            // App bar with image
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(AppDimensions.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.backgroundGrey,
                      child: Icon(
                        Icons.restaurant,
                        size: AppDimensions.iconXXLarge,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and availability
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ArabicText(
                            text: item.name,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: item.isAvailable,
                          onChanged: (value) {
                            ref.read(foodProvider.notifier).toggleAvailability(item.id);
                          },
                          activeColor: AppColors.success,
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacing8),

                    // Rating and reviews
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        SizedBox(width: AppDimensions.spacing4),
                        ArabicText(
                          text: item.rating.toStringAsFixed(1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        ArabicText(
                          text: '(${item.reviewsCount} تقييم)',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacing16),

                    // Price
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArabicText(
                            text: 'السعر',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                          ArabicText(
                            text: '${item.price.toStringAsFixed(0)} دج',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppDimensions.spacing24),

                    // Description
                    SectionHeader(title: 'الوصف'),
                    SizedBox(height: AppDimensions.spacing12),
                    ArabicText(
                      text: item.description,
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),

                    SizedBox(height: AppDimensions.spacing24),

                    // Category and prep time
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.category,
                            title: 'الفئة',
                            value: item.category.displayName,
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: _InfoCard(
                            icon: Icons.access_time,
                            title: 'وقت التحضير',
                            value: '${item.preparationTime} دقيقة',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacing24),

                    // Ingredients
                    if (item.ingredients.isNotEmpty) ...[
                      SectionHeader(title: 'المكونات'),
                      SizedBox(height: AppDimensions.spacing12),
                      Wrap(
                        spacing: AppDimensions.spacing8,
                        runSpacing: AppDimensions.spacing8,
                        children: item.ingredients.map((ingredient) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing12,
                              vertical: AppDimensions.spacing8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundGrey,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                            ),
                            child: ArabicText(
                              text: ingredient,
                              fontSize: 14,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.spacing24),
                    ],

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'حذف',
                            onPressed: () {
                              _showDeleteDialog(context, ref);
                            },
                            backgroundColor: AppColors.error.withOpacity(0.1),
                            textColor: AppColors.error,
                            height: 48,
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: CustomButton(
                            text: 'تعديل',
                            onPressed: () {
                              // Navigate to edit screen
                            },
                            height: 48,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacing24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const ArabicText(
            text: 'حذف العنصر',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: ArabicText(
            text: 'هل أنت متأكد من حذف "${item.name}"؟',
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
                ref.read(foodProvider.notifier).deleteItem(item.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم حذف العنصر'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: ArabicText(
                text: 'حذف',
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

/// Info card widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppDimensions.iconLarge,
          ),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: title,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppDimensions.spacing4),
          ArabicText(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
