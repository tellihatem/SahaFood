import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/widgets.dart';

class FoodCategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const FoodCategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 28.w,
                color: const Color(0xFFFF7622),
              ),
            ),
            SizedBox(height: 8.h),
            ArabicText(
              text: name,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF32343E),
            ),
          ],
        ),
      ),
    );
  }
}
