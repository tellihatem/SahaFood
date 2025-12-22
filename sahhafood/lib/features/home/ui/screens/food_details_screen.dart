import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../../cart/ui/screens/cart_screen.dart';

/// Food details screen - displays food item details and add to cart
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class FoodDetailsScreen extends ConsumerStatefulWidget {
  final String itemId;
  
  const FoodDetailsScreen({
    super.key,
    required this.itemId,
  });

  @override
  ConsumerState<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  int quantity = 2;
  String selectedSize = '14"';
  
  final List<String> sizes = ['10"', '14"', '16"'];
  
  final List<Map<String, dynamic>> addons = [
    {'icon': Icons.local_pizza, 'label': 'بيبر'},
    {'icon': Icons.restaurant, 'label': 'جبن'},
    {'icon': Icons.egg, 'label': 'بيض'},
    {'icon': Icons.lunch_dining, 'label': 'لحم'},
    {'icon': Icons.fastfood, 'label': 'بصل'},
  ];

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final restaurantState = ref.watch(restaurantProvider);
    
    final item = menuState.getItemById(widget.itemId);
    final restaurant = item != null 
        ? restaurantState.getRestaurantById(item.restaurantId)
        : null;

    if (item == null) {
      return Scaffold(
        body: Center(
          child: ArabicText(
            text: 'الطبق غير موجود',
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
            // Food image header
            Stack(
              children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                  ),
                  child: Image.network(
                    item.imageUrl,
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
                      return const SizedBox();
                    },
                  ),
                ),
                
                // Back button and favorite button
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
                            Icons.favorite,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Food details
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food name
                      ArabicText(
                        text: item.name,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing8),
                      
                      // Restaurant name
                      ArabicText(
                        text: restaurant?.name ?? 'مطعم',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing16),
                      
                      // Rating, delivery, time
                      if (restaurant != null)
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
                      
                      // Description
                      ArabicText(
                        text: item.description,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        maxLines: 2,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing24),
                      
                      // Size selection
                      ArabicText(
                        text: 'الحجم',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing12),
                      
                      Row(
                        children: sizes.map((size) {
                          final isSelected = selectedSize == size;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: AppDimensions.spacing12),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primary
                                    : AppColors.backgroundGrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: ArabicText(
                                  text: size,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected 
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      SizedBox(height: AppDimensions.spacing24),
                      
                      // Ingredients
                      ArabicText(
                        text: 'المكونات',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing12),
                      
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: addons.map((addon) {
                            return Container(
                              margin: EdgeInsets.only(left: AppDimensions.spacing12),
                              width: 58,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    child: Icon(
                                      addon['icon'],
                                      size: 26,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  ArabicText(
                                    text: addon['label'],
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Price and quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArabicText(
                            text: '\$${item.price.toStringAsFixed(0)}',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                                ArabicText(
                                  text: quantity.toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: AppDimensions.spacing24),
                      
                      // Add to cart button
                      CustomButton(
                        text: 'إضافة إلى السلة',
                        onPressed: () {
                          // TODO: Add item to cart with quantity and size
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
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
    );
  }
}
