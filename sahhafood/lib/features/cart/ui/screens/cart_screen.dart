import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import 'checkout_screen.dart';

/// Cart screen - displays shopping cart items
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF252836),
        appBar: AppBar(
          backgroundColor: const Color(0xFF252836),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            iconSize: AppDimensions.iconMedium,
            onPressed: () => Navigator.pop(context),
          ),
          title: ArabicText(
            text: 'السلة',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Edit items functionality
              },
              child: ArabicText(
                text: 'تعديل العناصر',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: cartState.isEmpty
            ? Center(
                child: ArabicText(
                  text: 'السلة فارغة',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withOpacity(0.7),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      itemCount: cartState.items.length,
                      itemBuilder: (context, index) {
                        final item = cartState.items[index];
                        return _CartItemCard(
                          item: item,
                          index: index,
                        );
                      },
                    ),
                  ),
                  
                  // Bottom section
                  _CartBottomSection(
                    deliveryAddress: cartState.deliveryAddress,
                    subtotal: cartState.subtotal,
                  ),
                ],
              ),
      ),
    );
  }
}

/// Cart item card widget
class _CartItemCard extends ConsumerWidget {
  final dynamic item;
  final int index;

  const _CartItemCard({
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
      padding: EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1D2B),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Row(
        children: [
          // Item image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3C),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fastfood,
                    color: AppColors.white.withOpacity(0.3),
                    size: 30,
                  );
                },
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacing12),
          
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: item.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  maxLines: 1,
                ),
                SizedBox(height: AppDimensions.spacing4),
                ArabicText(
                  text: item.description,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white.withOpacity(0.54),
                ),
                SizedBox(height: AppDimensions.spacing8),
                ArabicText(
                  text: '\$${item.price.toStringAsFixed(0)}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          
          // Quantity controls
          Column(
            children: [
              // Delete button
              GestureDetector(
                onTap: () => ref.read(cartProvider.notifier).removeItem(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D67),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacing12),
              
              // Quantity controls
              Row(
                children: [
                  GestureDetector(
                    onTap: () => ref.read(cartProvider.notifier).decrementQuantity(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: AppDimensions.spacing8),
                  
                  ArabicText(
                    text: '${item.quantity}',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  
                  SizedBox(width: AppDimensions.spacing8),
                  
                  GestureDetector(
                    onTap: () => ref.read(cartProvider.notifier).incrementQuantity(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Cart bottom section with address and checkout
class _CartBottomSection extends StatelessWidget {
  final String deliveryAddress;
  final double subtotal;

  const _CartBottomSection({
    required this.deliveryAddress,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1D2B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.spacing24),
          topRight: Radius.circular(AppDimensions.spacing24),
        ),
      ),
      child: Column(
        children: [
          // Delivery address
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              color: const Color(0xFF252836),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArabicText(
                        text: 'عنوان التوصيل',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withOpacity(0.54),
                      ),
                      SizedBox(height: AppDimensions.spacing4),
                      ArabicText(
                        text: deliveryAddress,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Edit address
                  },
                  child: ArabicText(
                    text: 'تعديل',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppDimensions.spacing16),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                text: 'المجموع',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white.withOpacity(0.54),
              ),
              ArabicText(
                text: '\$${subtotal.toStringAsFixed(0)}',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ],
          ),
          
          SizedBox(height: AppDimensions.spacing16),
          
          // Place order button
          CustomButton(
            text: 'تقديم الطلب',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    subtotal: subtotal,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
