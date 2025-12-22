/// Promo codes screen - displays available promotional offers
/// Follows architecture rules: uses Riverpod, constants, shared widgets

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'dart:async';

class PromoCodesScreen extends ConsumerWidget {
  const PromoCodesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promoState = ref.watch(promoProvider);
    final activePromos = promoState.activePromoCodes;
    final expiredPromos = promoState.expiredPromoCodes;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: ArabicText(
            text: 'العروض والخصومات',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(promoProvider.notifier).refresh(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimensions.spacing16),

                // Active Promos Section
                if (activePromos.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        ArabicText(
                          text: 'العروض النشطة',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: AppDimensions.spacing8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing12,
                            vertical: AppDimensions.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ArabicText(
                            text: activePromos.length.toString(),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  ...activePromos.map((promo) => _PromoCard(promo: promo)),
                ],

                // Expired Promos Section
                if (expiredPromos.isNotEmpty) ...[
                  SizedBox(height: AppDimensions.spacing24),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing16,
                    ),
                    child: ArabicText(
                      text: 'العروض المنتهية',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing12),
                  ...expiredPromos.map((promo) => _PromoCard(
                        promo: promo,
                        isExpired: true,
                      )),
                ],

                SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Promo card widget
class _PromoCard extends ConsumerStatefulWidget {
  final PromoCode promo;
  final bool isExpired;

  const _PromoCard({
    required this.promo,
    this.isExpired = false,
  });

  @override
  ConsumerState<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends ConsumerState<_PromoCard> {
  Timer? _timer;
  Duration? _timeRemaining;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (widget.promo.expiryDate == null || widget.isExpired) return;

    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    if (widget.promo.expiryDate == null) return;

    final now = DateTime.now();
    final difference = widget.promo.expiryDate!.difference(now);

    if (difference.isNegative) {
      _timer?.cancel();
      setState(() {
        _timeRemaining = null;
      });
    } else {
      setState(() {
        _timeRemaining = difference;
      });
    }
  }

  String _formatTimeRemaining() {
    if (_timeRemaining == null) return '';

    final hours = _timeRemaining!.inHours;
    final minutes = _timeRemaining!.inMinutes.remainder(60);
    final seconds = _timeRemaining!.inSeconds.remainder(60);

    if (hours > 24) {
      final days = (hours / 24).floor();
      return 'ينتهي خلال $days ${days == 1 ? "يوم" : "أيام"}';
    } else if (hours > 0) {
      return 'ينتهي خلال ${hours}س ${minutes}د';
    } else {
      return 'ينتهي خلال ${minutes}د ${seconds}ث';
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.promo.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ArabicText(
          text: 'تم نسخ الكود',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = widget.promo.remainingDays != null &&
        widget.promo.remainingDays! <= 1 &&
        !widget.isExpired;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: isUrgent
            ? Border.all(color: AppColors.error, width: 2)
            : null,
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
          // Promo image and discount badge
          Stack(
            children: [
              // Background image
              if (widget.promo.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                  child: Image.network(
                    widget.promo.imageUrl!,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: AppColors.backgroundGrey,
                      );
                    },
                  ),
                ),

              // Gradient overlay
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // Discount badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isExpired
                        ? AppColors.textSecondary
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ArabicText(
                    text: widget.isExpired ? 'منتهي' : widget.promo.discountText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),

              // Urgent badge
              if (isUrgent)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing8,
                      vertical: AppDimensions.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 4),
                        ArabicText(
                          text: 'ينتهي قريباً',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Promo details
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArabicText(
                  text: widget.promo.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.isExpired
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  maxLines: 2,
                ),
                SizedBox(height: AppDimensions.spacing8),
                ArabicText(
                  text: widget.promo.description,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  maxLines: 2,
                ),

                // Minimum order amount
                if (widget.promo.minOrderAmount != null) ...[
                  SizedBox(height: AppDimensions.spacing8),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      ArabicText(
                        text:
                            'الحد الأدنى للطلب: ${widget.promo.minOrderAmount!.toInt()} دج',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],

                SizedBox(height: AppDimensions.spacing12),

                // Code and copy button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing12,
                          vertical: AppDimensions.spacing12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ArabicText(
                              text: widget.promo.code,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: widget.isExpired
                                  ? AppColors.textSecondary
                                  : AppColors.primary,
                            ),
                            if (!widget.isExpired)
                              GestureDetector(
                                onTap: _copyCode,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.spacing6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Countdown timer
                if (_timeRemaining != null && !widget.isExpired) ...[
                  SizedBox(height: AppDimensions.spacing8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing8,
                      vertical: AppDimensions.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isUrgent ? AppColors.error : AppColors.primary,
                        ),
                        SizedBox(width: 4),
                        ArabicText(
                          text: _formatTimeRemaining(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isUrgent ? AppColors.error : AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
