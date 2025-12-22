import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'chef_food_details_screen.dart';
import 'chef_add_item_screen.dart';

/// Chef food list screen with menu items
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefFoodListScreen extends ConsumerWidget {
  const ChefFoodListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodState = ref.watch(foodProvider);
    final filteredItems = foodState.filteredItems;

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
            text: 'قائمة الطعام',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: AppColors.primary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChefAddItemScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Category tabs
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.spacing12,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                child: Row(
                  children: FoodCategory.values.map((category) {
                    final isSelected = foodState.selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        ref.read(foodProvider.notifier).setCategory(category);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing16,
                          vertical: AppDimensions.spacing8,
                        ),
                        margin: EdgeInsets.only(left: AppDimensions.spacing8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        ),
                        child: ArabicText(
                          text: category.displayName,
                          fontSize: 14,
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Food items grid
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: AppDimensions.iconXXLarge,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppDimensions.spacing16),
                          ArabicText(
                            text: 'لا توجد عناصر',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(AppDimensions.spacing20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: AppDimensions.spacing16,
                        mainAxisSpacing: AppDimensions.spacing16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _FoodItemCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChefFoodDetailsScreen(item: item),
                              ),
                            );
                          },
                          onToggleAvailability: () {
                            ref.read(foodProvider.notifier).toggleAvailability(item.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Food item card widget
class _FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final VoidCallback onToggleAvailability;

  const _FoodItemCard({
    required this.item,
    required this.onTap,
    required this.onToggleAvailability,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusMedium),
                    topRight: Radius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120.h,
                        color: AppColors.backgroundGrey,
                        child: Icon(
                          Icons.restaurant,
                          size: AppDimensions.iconXLarge,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                // Availability toggle
                Positioned(
                  top: AppDimensions.spacing8,
                  right: AppDimensions.spacing8,
                  child: GestureDetector(
                    onTap: onToggleAvailability,
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.spacing8),
                      decoration: BoxDecoration(
                        color: item.isAvailable 
                            ? AppColors.success.withOpacity(0.9)
                            : AppColors.error.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Icon(
                        item.isAvailable ? Icons.check : Icons.close,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArabicText(
                    text: item.name,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: item.rating.toStringAsFixed(1),
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      ArabicText(
                        text: '(${item.reviewsCount})',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  ArabicText(
                    text: '${item.price.toStringAsFixed(0)} دج',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
