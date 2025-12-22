import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/widgets.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String rating;
  final String deliveryInfo;
  final String time;
  final String? imagePath;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.rating,
    required this.deliveryInfo,
    required this.time,
    this.imagePath,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 200.h,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8A9BA8).withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        child: Image.asset(
                          imagePath!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        ),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            
            // Info section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Restaurant name
                    ArabicText(
                      text: name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1D2E),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Rating, delivery, and time info
                    Row(
                      children: [
                        // Rating
                        Icon(
                          Icons.star,
                          size: 14.w,
                          color: const Color(0xFFFF7622),
                        ),
                        SizedBox(width: 4.w),
                        ArabicText(
                          text: rating,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E1D2E),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        // Delivery info
                        Icon(
                          Icons.delivery_dining,
                          size: 14.w,
                          color: const Color(0xFF8A9BA8),
                        ),
                        SizedBox(width: 4.w),
                        ArabicText(
                          text: deliveryInfo,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8A9BA8),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        // Time
                        Icon(
                          Icons.access_time,
                          size: 14.w,
                          color: const Color(0xFF8A9BA8),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ArabicText(
                            text: time,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8A9BA8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF8A9BA8).withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 48.w,
          color: const Color(0xFF8A9BA8).withOpacity(0.5),
        ),
      ),
    );
  }
}
