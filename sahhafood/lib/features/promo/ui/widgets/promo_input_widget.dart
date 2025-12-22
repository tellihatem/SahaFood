/// Promo code input widget for cart/checkout
/// Follows architecture rules: reusable, stateful for input

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../providers/providers.dart';
import '../screens/promo_codes_screen.dart';

class PromoInputWidget extends ConsumerStatefulWidget {
  final double orderAmount;

  const PromoInputWidget({
    super.key,
    required this.orderAmount,
  });

  @override
  ConsumerState<PromoInputWidget> createState() => _PromoInputWidgetState();
}

class _PromoInputWidgetState extends ConsumerState<PromoInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    final success = ref.read(promoProvider.notifier).applyPromoCode(
          code,
          widget.orderAmount,
        );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ArabicText(
            text: 'تم تطبيق كود الخصم بنجاح',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
      _controller.clear();
      setState(() {
        _isExpanded = false;
      });
    } else {
      final error = ref.read(promoProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ArabicText(
            text: error ?? 'فشل تطبيق كود الخصم',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final promoState = ref.watch(promoProvider);
    final appliedPromo = promoState.appliedPromo;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: appliedPromo != null
              ? AppColors.success
              : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              if (appliedPromo == null) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.spacing8),
                    decoration: BoxDecoration(
                      color: appliedPromo != null
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_offer,
                      size: 20,
                      color: appliedPromo != null
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ArabicText(
                          text: appliedPromo != null
                              ? 'تم تطبيق الخصم'
                              : 'لديك كود خصم؟',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        if (appliedPromo != null) ...[
                          SizedBox(height: 2),
                          ArabicText(
                            text: appliedPromo.code,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (appliedPromo != null)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        ref.read(promoProvider.notifier).removePromo();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: ArabicText(
                              text: 'تم إزالة كود الخصم',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                            backgroundColor: AppColors.textPrimary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    )
                  else
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ),
          ),

          // Input field (when expanded)
          if (_isExpanded && appliedPromo == null) ...[
            Divider(height: 1, color: AppColors.borderLight),
            Padding(
              padding: EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'أدخل كود الخصم',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              fontFamily: 'Tajawal',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing12,
                              vertical: AppDimensions.spacing12,
                            ),
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing8),
                      ElevatedButton(
                        onPressed: _applyPromo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing16,
                            vertical: AppDimensions.spacing12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium,
                            ),
                          ),
                        ),
                        child: ArabicText(
                          text: 'تطبيق',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PromoCodesScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArabicText(
                          text: 'عرض جميع العروض',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4),
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
          ],
        ],
      ),
    );
  }
}
