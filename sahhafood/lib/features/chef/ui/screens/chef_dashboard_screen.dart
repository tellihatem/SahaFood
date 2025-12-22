import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import 'chef_running_orders_screen.dart';
import 'chef_reviews_screen.dart';
import 'chef_notifications_screen.dart';
import 'chef_food_list_screen.dart';

/// Chef dashboard screen with statistics and overview
/// Follows architecture rules: uses Riverpod, constants, shared widgets
class ChefDashboardScreen extends ConsumerWidget {
  const ChefDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chefState = ref.watch(chefProvider);
    final reviewsState = ref.watch(reviewsProvider);
    final recentReviews = reviewsState.reviews.take(3).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                
                SizedBox(height: AppDimensions.spacing24),
                
                // Stats Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'الطلبات الجارية',
                          value: '${chefState.runningOrdersCount}',
                          subtitle: 'RUNNING ORDERS',
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChefRunningOrdersScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: _StatCard(
                          title: 'طلبات اليوم',
                          value: '${chefState.todayOrdersCount}',
                          subtitle: 'ORDER REQUEST',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppDimensions.spacing24),
                
                // Revenue Chart
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                  child: _RevenueCard(revenue: chefState.todayRevenue),
                ),
                
                SizedBox(height: AppDimensions.spacing24),
                
                // Popular Items Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        text: 'الأطباق الشائعة هذا الأسبوع',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChefFoodListScreen(),
                            ),
                          );
                        },
                        child: ArabicText(
                          text: 'عرض الكل',
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppDimensions.spacing12),
                
                // Popular Items List
                SizedBox(
                  height: 120.h,
                  child: ref.watch(foodProvider).items.isEmpty
                      ? Center(
                          child: ArabicText(
                            text: 'لا توجد أطباق',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                          itemCount: ref.watch(foodProvider).items.length > 5 
                              ? 5 
                              : ref.watch(foodProvider).items.length,
                          itemBuilder: (context, index) {
                            final item = ref.watch(foodProvider).items[index];
                            return _PopularItemCard(item: item);
                          },
                        ),
                ),
                
                SizedBox(height: AppDimensions.spacing24),
                
                // Reviews Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArabicText(
                        text: 'التقييمات',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChefReviewsScreen(),
                            ),
                          );
                        },
                        child: ArabicText(
                          text: 'عرض الكل',
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppDimensions.spacing12),
                
                // Recent Reviews
                if (recentReviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing20),
                    child: Center(
                      child: ArabicText(
                        text: 'لا توجد تقييمات بعد',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  ...recentReviews.map((review) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing20,
                      vertical: AppDimensions.spacing8,
                    ),
                    child: _ReviewCard(
                      customerName: review.customerName,
                      rating: review.rating,
                      comment: review.comment,
                      date: review.date,
                    ),
                  )),
                
                SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu,
                size: AppDimensions.iconLarge,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: AppDimensions.spacing16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ArabicText(
                        text: 'الموقع',
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  ArabicText(
                    text: 'فندق لافيتا',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChefNotificationsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.spacing8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconMedium,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.textSecondary,
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: AppDimensions.iconLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArabicText(
              text: title,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.spacing8),
            ArabicText(
              text: value,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            SizedBox(height: AppDimensions.spacing4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Revenue card widget
class _RevenueCard extends StatelessWidget {
  final double revenue;

  const _RevenueCard({required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ArabicText(
                text: 'إيرادات اليوم',
                fontSize: 16,
                color: AppColors.white,
              ),
              Icon(
                Icons.trending_up,
                color: AppColors.white,
                size: AppDimensions.iconLarge,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing16),
          ArabicText(
            text: '${revenue.toStringAsFixed(0)} دج',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          SizedBox(height: AppDimensions.spacing8),
          ArabicText(
            text: 'زيادة 12% عن الأمس',
            fontSize: 14,
            color: AppColors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}

/// Review card widget
class _ReviewCard extends StatelessWidget {
  final String customerName;
  final double rating;
  final String comment;
  final DateTime date;

  const _ReviewCard({
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: ArabicText(
                  text: customerName[0],
                  fontSize: 18,
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
                      text: customerName,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: AppDimensions.spacing4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.warning,
                            size: 16,
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              ArabicText(
                text: _formatDate(date),
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing12),
          ArabicText(
            text: comment,
            fontSize: 14,
            color: AppColors.textSecondary,
            maxLines: 2,
          ),
        ],
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

/// Popular item card widget
class _PopularItemCard extends StatelessWidget {
  final FoodItem item;

  const _PopularItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(left: AppDimensions.spacing12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: EdgeInsets.all(AppDimensions.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: AppColors.warning,
                ),
                SizedBox(width: AppDimensions.spacing4),
                ArabicText(
                  text: item.rating.toStringAsFixed(1),
                  fontSize: 12,
                  color: AppColors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
