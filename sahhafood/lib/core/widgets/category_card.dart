import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/widgets.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(right: 16.w),
        child: Column(
          children: [
            // Image container with gradient overlay
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background color
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  
                  // Image with gradient overlay
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: backgroundColor,
                              child: Icon(
                                Icons.fastfood,
                                size: 40.w,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            );
                          },
                        ),
                        
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                backgroundColor.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 8.h),
            
            // Category name with shadow for better visibility
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ArabicText(
                text: name,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF32343E),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
