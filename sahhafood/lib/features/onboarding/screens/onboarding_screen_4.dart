import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/widgets.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40.h),
        
        // Food Image
        Container(
          width: 240.w,
          height: 240.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xFFFF7622),
          ),
          child: const Icon(
            Icons.celebration,
            size: 80,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 40.h),
        
        // Title
        ArabicText(
          text: 'اطلب الآن واستمتع',
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF32343E),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: 16.h),
        
        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ArabicText(
            text: 'ابدأ رحلتك معنا واستمتع بأفضل الأطعمة من مطاعمك المفضلة',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF646982),
            textAlign: TextAlign.center,
            height: 1.5,
          ),
        ),
        
        SizedBox(height: 40.h),
      ],
    );
  }
}
