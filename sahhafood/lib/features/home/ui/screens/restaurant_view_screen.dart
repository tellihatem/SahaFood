import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/food_item_card.dart';
import '../../providers/providers.dart';
import 'food_details_screen.dart';

/// Restaurant view screen - displays restaurant details and menu
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class RestaurantViewScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  
  const RestaurantViewScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  ConsumerState<RestaurantViewScreen> createState() => _RestaurantViewScreenState();
}

class _RestaurantViewScreenState extends ConsumerState<RestaurantViewScreen> {
  int selectedCategoryIndex = 0;
  int currentImageIndex = 0;
  
  final List<String> categories = [
    'برجر',
    'ساندويتش',
    'بيتزا',
    'سومو',
  ];
  
  final List<String> restaurantImages = [
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
  ];

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final menuState = ref.watch(menuProvider);
    
    final restaurant = restaurantState.getRestaurantById(widget.restaurantId);
    final menuItems = menuState.getItemsByRestaurantId(widget.restaurantId);

    if (restaurant == null) {
      return Scaffold(
        body: Center(
          child: ArabicText(
            text: 'المطعم غير موجود',
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Restaurant image header with swipe
            Stack(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      // Swiped right
                      setState(() {
                        currentImageIndex = (currentImageIndex - 1) % restaurantImages.length;
                        if (currentImageIndex < 0) currentImageIndex = restaurantImages.length - 1;
                      });
                    } else if (details.primaryVelocity! < 0) {
                      // Swiped left
                      setState(() {
                        currentImageIndex = (currentImageIndex + 1) % restaurantImages.length;
                      });
                    }
                  },
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          restaurantImages[currentImageIndex],
                          width: double.infinity,
                          height: double.infinity,
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
                            return const SizedBox();
                          },
                        ),
                        
                        // Image indicators
                        Positioned(
                          bottom: AppDimensions.spacing16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              restaurantImages.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
                                width: currentImageIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentImageIndex == index
                                      ? AppColors.primary
                                      : AppColors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Back button and more button
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            size: AppDimensions.iconLarge,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Dots indicator
                Positioned(
                  bottom: AppDimensions.spacing16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
                        decoration: BoxDecoration(
                          color: index == 2 
                              ? AppColors.white 
                              : AppColors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            
            // Restaurant info
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppDimensions.spacing24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating, delivery, time
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
                          
                          SizedBox(height: AppDimensions.spacing16),
                          
                          // Restaurant name
                          ArabicText(
                            text: restaurant.name,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing8),
                          
                          // Description
                          ArabicText(
                            text: restaurant.description ?? 'مطعم فاخر يقدم أطباق لذيذة ومبتكرة مصنوعة من مكونات طازجة وعضوية.',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            maxLines: 2,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Categories
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final isSelected = selectedCategoryIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: AppDimensions.spacing12),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: AppDimensions.spacing12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? AppColors.primary
                                          : AppColors.backgroundGrey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: ArabicText(
                                        text: categories[index],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected 
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Menu items section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ArabicText(
                            text: 'برجر (${menuItems.length})',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing16),
                          
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppDimensions.spacing16,
                              mainAxisSpacing: AppDimensions.spacing16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              final item = menuItems[index];
                              return FoodItemCard(
                                name: item.name,
                                restaurant: restaurant.name,
                                price: '\$${item.price.toStringAsFixed(0)}',
                                imageUrl: item.imageUrl,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetailsScreen(
                                        itemId: item.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
}
