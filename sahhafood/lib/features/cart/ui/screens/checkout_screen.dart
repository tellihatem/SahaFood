import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../order/ui/screens/order_tracking_screen.dart';

/// Checkout screen - payment and order confirmation
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class CheckoutScreen extends ConsumerStatefulWidget {
  final double subtotal;
  
  const CheckoutScreen({
    super.key,
    required this.subtotal,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPayment = 'card';

  @override
  Widget build(BuildContext context) {
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
            text: 'الدفع',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: ArabicText(
                text: 'تم',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.success,
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
                    // Delivery Address
                    ArabicText(
                      text: 'عنوان التوصيل',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    Container(
                      padding: EdgeInsets.all(AppDimensions.spacing16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1D2B),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ArabicText(
                              text: '2118 Thornridge Cir. Syracuse',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
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
                    
                    SizedBox(height: AppDimensions.spacing24),
                    
                    // Payment Method
                    ArabicText(
                      text: 'طريقة الدفع',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    // Card payment
                    _PaymentOption(
                      icon: Icons.credit_card,
                      title: 'بطاقة ائتمان',
                      value: 'card',
                      selectedValue: selectedPayment,
                      onTap: () {
                        setState(() {
                          selectedPayment = 'card';
                        });
                      },
                    ),
                    
                    SizedBox(height: AppDimensions.spacing12),
                    
                    // Cash payment
                    _PaymentOption(
                      icon: Icons.money,
                      title: 'نقداً',
                      value: 'cash',
                      selectedValue: selectedPayment,
                      onTap: () {
                        setState(() {
                          selectedPayment = 'cash';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom section
            Container(
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
                        text: '\$${widget.subtotal.toStringAsFixed(0)}',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppDimensions.spacing16),
                  
                  CustomButton(
                    text: 'تقديم الطلب',
                    onPressed: () {
                      // TODO: Get actual order ID from cart provider after placing order
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderTrackingScreen(
                            orderId: '1', // Mock ID - replace with actual order ID
                          ),
                        ),
                      );
                    },
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

/// Payment option widget
class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String selectedValue;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1D2B),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A3C),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: ArabicText(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
          ],
        ),
      ),
    );
  }
}
