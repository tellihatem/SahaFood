import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/category_card.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../../cart/ui/screens/cart_screen.dart';
import '../../../favorites/ui/screens/favorites_screen.dart';
import '../../../promo/ui/screens/promo_codes_screen.dart';
import 'search_screen.dart';
import 'restaurant_view_screen.dart';

/// Home screen - main screen with categories and restaurants
/// Follows architecture rules: uses Riverpod, constants, shared widgets
/// Enhanced with: banners, quick filters, near you section, pull-to-refresh
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _handleRefresh() async {
    // Refresh all data
    await Future.wait([
      ref.read(bannerProvider.notifier).refresh(),
      ref.read(restaurantProvider.notifier).loadRestaurants(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryProvider);
    final restaurantState = ref.watch(restaurantProvider);
    final bannerState = ref.watch(bannerProvider);
    final quickFilterState = ref.watch(quickFilterProvider);

    // Apply quick filter if selected
    final displayRestaurants = quickFilterState.selectedFilter != null
        ? ref.read(restaurantProvider.notifier)
            .filterByQuickFilter(quickFilterState.selectedFilter)
        : restaurantState.restaurants;

    // Separate near you restaurants (within 2km)
    final nearYouRestaurants = restaurantState.restaurants
        .where((r) => (r.distanceKm ?? 999) <= 2.0)
        .toList()
      ..sort((a, b) => (a.distanceKm ?? 999).compareTo(b.distanceKm ?? 999));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),
              
              // Content Section with pull-to-refresh
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppDimensions.spacing16),
                        
                        // Banner Carousel
                        if (bannerState.banners.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing24,
                            ),
                            child: BannerCarousel(
                              banners: bannerState.banners.map((banner) {
                                return BannerItem(
                                  title: banner.title,
                                  subtitle: banner.subtitle,
                                  imageUrl: banner.imageUrl,
                                );
                              }).toList(),
                            ),
                          ),
                        
                        SizedBox(height: AppDimensions.spacing16),
                        
                        // Promo Codes Banner
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PromoCodesScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppDimensions.spacing16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: AppDimensions.spacing12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ArabicText(
                                          text: 'عروض وخصومات حصرية',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(height: 2),
                                        ArabicText(
                                          text: 'اكتشف أفضل العروض',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white.withOpacity(0.9),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.spacing24),
                        
                        // Quick Filters
                        _buildQuickFilters(quickFilterState),
                        
                        SizedBox(height: AppDimensions.spacing24),
                        
                        // All Categories Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ArabicText(
                                text: 'التصنيفات',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SearchScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    ArabicText(
                                      text: 'مشاهدة الكل',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: AppDimensions.spacing4),
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.spacing16),
                        
                        // Categories horizontal scroll
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing24,
                            ),
                            itemCount: categoryState.categories.length,
                            itemBuilder: (context, index) {
                              final category = categoryState.categories[index];
                              return CategoryCard(
                                name: category.name,
                                imageUrl: category.imageUrl,
                                backgroundColor: category.color,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SearchScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.spacing24),
                        
                        // Near You Section
                        if (nearYouRestaurants.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing24,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: AppDimensions.spacing8),
                                ArabicText(
                                  text: 'قريب منك',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.spacing16),
                          
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing24,
                              ),
                              itemCount: nearYouRestaurants.take(5).length,
                              itemBuilder: (context, index) {
                                final restaurant = nearYouRestaurants[index];
                                return _NearYouCard(restaurant: restaurant);
                              },
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                        ],
                        
                        // Open Restaurants Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ArabicText(
                                text: quickFilterState.selectedFilter != null
                                    ? quickFilterState.selectedFilter!.displayName
                                    : 'المطاعم المفتوحة',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              Row(
                                children: [
                                  ArabicText(
                                    text: 'مشاهدة الكل',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: AppDimensions.spacing4),
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: AppDimensions.spacing16),
                        
                        // Restaurant cards
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing24,
                          ),
                          itemCount: displayRestaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = displayRestaurants[index];
                            return _buildRestaurantCard(context, restaurant);
                          },
                        ),
                        
                        SizedBox(height: AppDimensions.spacing24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing24),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              // Location with icon
              Icon(
                Icons.location_on,
                size: 20,
                color: AppColors.primary,
              ),
              SizedBox(width: AppDimensions.spacing8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicText(
                      text: 'التوصيل إلى',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: ArabicText(
                            text: 'مكتب حلال لاب',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Favorites, Cart and Notification icons
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  size: AppDimensions.iconLarge,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: AppDimensions.iconLarge,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: AppDimensions.iconLarge,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          // Greeting
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'مرحباً حلال، ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  TextSpan(
                    text: 'مساء الخير!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Search bar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: ArabicText(
                      text: 'ابحث عن أطباق أو مطاعم',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters(QuickFilterState quickFilterState) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
        itemCount: quickFilterState.filters.length,
        itemBuilder: (context, index) {
          final filter = quickFilterState.filters[index];
          return GestureDetector(
            onTap: () {
              ref.read(quickFilterProvider.notifier).toggleFilter(filter.type);
            },
            child: Container(
              margin: EdgeInsets.only(left: AppDimensions.spacing12),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing8,
              ),
              decoration: BoxDecoration(
                color: filter.isSelected
                    ? AppColors.primary
                    : AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: filter.isSelected
                      ? AppColors.primary
                      : AppColors.borderLight,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getFilterIcon(filter.type, filter.isSelected),
                  SizedBox(width: AppDimensions.spacing6),
                  ArabicText(
                    text: filter.label,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: filter.isSelected
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getFilterIcon(QuickFilterType type, bool isSelected) {
    IconData iconData;
    switch (type) {
      case QuickFilterType.fastDelivery:
        iconData = Icons.delivery_dining;
        break;
      case QuickFilterType.topRated:
        iconData = Icons.star;
        break;
      case QuickFilterType.freeDelivery:
        iconData = Icons.money_off;
        break;
      case QuickFilterType.nearYou:
        iconData = Icons.near_me;
        break;
      case QuickFilterType.openNow:
        iconData = Icons.schedule;
        break;
      case QuickFilterType.newRestaurants:
        iconData = Icons.new_releases;
        break;
    }

    return Icon(
      iconData,
      size: 16,
      color: isSelected ? AppColors.white : AppColors.primary,
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLarge),
                  topRight: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLarge),
                  topRight: Radius.circular(AppDimensions.radiusLarge),
                ),
                child: Image.network(
                  restaurant.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Restaurant info
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing16),
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
                      SizedBox(width: 10),
                      Icon(
                        Icons.access_time,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 3),
                      Flexible(
                        child: ArabicText(
                          text: restaurant.deliveryTime,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: restaurant.tags
                        .map((tag) => ArabicText(
                              text: tag,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ))
                        .toList(),
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

/// Near you card widget
class _NearYouCard extends ConsumerWidget {
  final Restaurant restaurant;

  const _NearYouCard({required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        width: 200,
        margin: EdgeInsets.only(left: AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
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
            // Restaurant image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLarge),
                  topRight: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusLarge),
                      topRight: Radius.circular(AppDimensions.radiusLarge),
                    ),
                    child: Image.network(
                      restaurant.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
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
                  // Distance badge
                  if (restaurant.distanceKm != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 2),
                            ArabicText(
                              text: '${restaurant.distanceKm!.toStringAsFixed(1)} كم',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Restaurant info
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArabicText(
                    text: restaurant.name,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 3),
                      ArabicText(
                        text: restaurant.rating.toString(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: ArabicText(
                          text: restaurant.deliveryTime,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: ArabicText(
                          text: restaurant.deliveryFee,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          maxLines: 1,
                        ),
                      ),
                    ],
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
