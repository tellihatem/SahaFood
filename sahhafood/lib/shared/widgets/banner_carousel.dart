/// Banner carousel widget for promotional banners
/// Follows architecture rules: reusable, stateless where possible, uses constants

import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import 'arabic_text.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final Duration autoPlayDuration;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 160,
    this.autoPlayDuration = const Duration(seconds: 4),
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.banners.length <= 1) return;

    Future.delayed(widget.autoPlayDuration, () {
      if (!mounted) return;
      
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      
      _startAutoPlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return _BannerCard(banner: widget.banners[index]);
            },
          ),
        ),
        
        if (widget.banners.length > 1) ...[
          SizedBox(height: AppDimensions.spacing12),
          _BannerIndicator(
            count: widget.banners.length,
            currentIndex: _currentPage,
          ),
        ],
      ],
    );
  }
}

/// Banner card widget
class _BannerCard extends StatelessWidget {
  final BannerItem banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background image
          if (banner.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: Image.network(
                banner.imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.primary.withOpacity(0.1),
                  );
                },
              ),
            ),
          
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(AppDimensions.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArabicText(
                  text: banner.title,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
                SizedBox(height: AppDimensions.spacing8),
                ArabicText(
                  text: banner.subtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white.withOpacity(0.9),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner indicator widget
class _BannerIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _BannerIndicator({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.borderLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Banner item model for carousel
class BannerItem {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;

  const BannerItem({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.onTap,
  });
}
