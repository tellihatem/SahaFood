/// Favorites screen - displays user's favorite restaurants and items
/// Follows architecture rules: uses Riverpod, constants, shared widgets

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../../home/providers/providers.dart';
import '../../../home/ui/screens/restaurant_view_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final restaurantState = ref.watch(restaurantProvider);

    // Get favorite restaurants
    final favoriteRestaurantIds = favoritesState
        .getFavoritesByType(FavoriteType.restaurant)
        .map((f) => f.itemId)
        .toList();

    final favoriteRestaurants = restaurantState.restaurants
        .where((r) => favoriteRestaurantIds.contains(r.id))
        .toList();

    // Get favorite menu items
    final favoriteMenuItems = favoritesState
        .getFavoritesByType(FavoriteType.menuItem);

    final hasRestaurants = favoriteRestaurants.isNotEmpty;
    final hasMenuItems = favoriteMenuItems.isNotEmpty;
    final hasAnyFavorites = hasRestaurants || hasMenuItems;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: ArabicText(
            text: 'المفضلة',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          actions: [
            if (hasAnyFavorites)
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  _showClearConfirmation(context);
                },
              ),
          ],
          bottom: hasAnyFavorites
              ? TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  labelStyle: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: 'المطاعم (${favoriteRestaurants.length})',
                    ),
                    Tab(
                      text: 'الأطباق (${favoriteMenuItems.length})',
                    ),
                  ],
                )
              : null,
        ),
        body: hasAnyFavorites
            ? TabBarView(
                controller: _tabController,
                children: [
                  // Restaurants tab
                  _buildRestaurantsTab(favoriteRestaurants),
                  // Menu items tab
                  _buildMenuItemsTab(favoriteMenuItems),
                ],
              )
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildRestaurantsTab(List<dynamic> restaurants) {
    if (restaurants.isEmpty) {
      return _buildEmptyState(
        message: 'لا توجد مطاعم مفضلة',
        subtitle: 'ابدأ بإضافة مطاعمك المفضلة',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return _buildRestaurantCard(restaurant);
      },
    );
  }

  Widget _buildMenuItemsTab(List<FavoriteItem> menuItems) {
    if (menuItems.isEmpty) {
      return _buildEmptyState(
        message: 'لا توجد أطباق مفضلة',
        subtitle: 'ابدأ بإضافة أطباقك المفضلة',
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItemCard(item);
      },
    );
  }

  Widget _buildRestaurantCard(dynamic restaurant) {
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
        margin: EdgeInsets.only(bottom: AppDimensions.spacing12),
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
                    return Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.warning,
                        ),
                        SizedBox(width: 4),
                        ArabicText(
                          text: restaurant.rating.toString(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: ArabicText(
                            text: restaurant.deliveryFee,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Remove button
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: AppColors.error,
                size: 20,
              ),
              onPressed: () {
                ref.read(favoritesProvider.notifier).removeFavorite(restaurant.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: ArabicText(
                      text: 'تم الإزالة من المفضلة',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    backgroundColor: AppColors.textPrimary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(FavoriteItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for menu item image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusMedium),
                  topRight: Radius.circular(AppDimensions.radiusMedium),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.fastfood,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: 'طبق مفضل',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ArabicText(
                      text: '500 دج',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(favoritesProvider.notifier).removeFavorite(item.itemId);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String? message, String? subtitle}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.spacing24),
            ArabicText(
              text: message ?? 'لا توجد عناصر مفضلة',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacing8),
            ArabicText(
              text: subtitle ?? 'ابدأ بإضافة المطاعم والأطباق المفضلة لديك',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(height: AppDimensions.spacing32),
            CustomButton(
              text: 'استكشف المطاعم',
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: ArabicText(
            text: 'مسح جميع المفضلة؟',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          content: ArabicText(
            text: 'هل أنت متأكد من حذف جميع العناصر المفضلة؟',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ArabicText(
                text: 'إلغاء',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).clearAllFavorites();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: ArabicText(
                      text: 'تم مسح جميع المفضلة',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    backgroundColor: AppColors.textPrimary,
                  ),
                );
              },
              child: ArabicText(
                text: 'مسح',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
