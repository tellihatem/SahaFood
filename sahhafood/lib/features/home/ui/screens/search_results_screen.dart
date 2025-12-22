import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'filter_screen.dart';
import 'restaurant_view_screen.dart';

/// Search results screen - displays search results with filters
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class SearchResultsScreen extends ConsumerWidget {
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    
    // Apply search and filters
    var results = ref.read(restaurantProvider.notifier).searchRestaurants(searchQuery);
    if (filterState.criteria.hasActiveFilters) {
      results = ref.read(restaurantProvider.notifier).filterRestaurants(filterState.criteria);
    }

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
            text: searchQuery,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: AppColors.textPrimary,
                size: AppDimensions.iconLarge,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: results.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: AppDimensions.spacing16),
                    ArabicText(
                      text: 'لا توجد نتائج',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(AppDimensions.spacing24),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final restaurant = results[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantViewScreen(
                            restaurantId: restaurant.id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Restaurant image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundGrey,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(AppDimensions.radiusLarge),
                                bottomRight: Radius.circular(AppDimensions.radiusLarge),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(AppDimensions.radiusLarge),
                                bottomRight: Radius.circular(AppDimensions.radiusLarge),
                              ),
                              child: Image.network(
                                restaurant.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.restaurant,
                                    size: 40,
                                    color: AppColors.textSecondary,
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          // Restaurant info
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.spacing12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ArabicText(
                                    text: restaurant.name,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 13,
                                        color: AppColors.warning,
                                      ),
                                      SizedBox(width: 3),
                                      ArabicText(
                                        text: restaurant.rating.toString(),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.delivery_dining,
                                        size: 13,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 3),
                                      Flexible(
                                        child: ArabicText(
                                          text: restaurant.deliveryFee,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  ArabicText(
                                    text: restaurant.tags.join(' • '),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
