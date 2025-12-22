import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';

/// Chef reviews screen showing customer reviews
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefReviewsScreen extends ConsumerWidget {
  const ChefReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsState = ref.watch(reviewsProvider);
    final reviews = reviewsState.reviews;
    final averageRating = reviewsState.averageRating;
    final distribution = reviewsState.ratingDistribution;

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
            text: 'التقييمات',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(AppDimensions.spacing20),
          children: [
            // Rating summary
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Column(
                children: [
                  ArabicText(
                    text: averageRating.toStringAsFixed(1),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < averageRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.white,
                        size: AppDimensions.iconLarge,
                      );
                    }),
                  ),
                  SizedBox(height: AppDimensions.spacing8),
                  ArabicText(
                    text: '${reviews.length} تقييم',
                    fontSize: 16,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppDimensions.spacing24),

            // Rating distribution
            SectionHeader(title: 'توزيع التقييمات'),
            SizedBox(height: AppDimensions.spacing12),
            ...List.generate(5, (index) {
              final rating = 5 - index;
              final count = distribution[rating] ?? 0;
              final percentage = reviews.isEmpty ? 0.0 : (count / reviews.length);
              
              return Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spacing8),
                child: Row(
                  children: [
                    ArabicText(
                      text: '$rating',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: AppDimensions.spacing12),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerRight,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacing12),
                    ArabicText(
                      text: '$count',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: AppDimensions.spacing24),

            // Reviews list
            SectionHeader(title: 'جميع التقييمات'),
            SizedBox(height: AppDimensions.spacing12),
            if (reviews.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacing32),
                  child: ArabicText(
                    text: 'لا توجد تقييمات بعد',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ...reviews.map((review) => Container(
                margin: EdgeInsets.only(bottom: AppDimensions.spacing16),
                padding: EdgeInsets.all(AppDimensions.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: ArabicText(
                            text: review.customerName[0],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ArabicText(
                                text: review.customerName,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: AppDimensions.spacing4),
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    return Icon(
                                      index < review.rating.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.warning,
                                      size: 16,
                                    );
                                  }),
                                  SizedBox(width: AppDimensions.spacing8),
                                  ArabicText(
                                    text: _formatDate(review.date),
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacing12),
                    ArabicText(
                      text: review.comment,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
