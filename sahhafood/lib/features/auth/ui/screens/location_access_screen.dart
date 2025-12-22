import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';

/// Location access permission screen
/// Requests user permission to access device location
class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                
                // Location icon illustration
                Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    color: AppColors.textLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      size: 80.w,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                
                SizedBox(height: 60.h),
                
                // Title
                ArabicText(
                  text: 'الوصول للموقع',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundDark,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppDimensions.spacing16),
                
                // Description
                ArabicText(
                  text: 'سيصل إلى موقعك فقط أثناء استخدام التطبيق',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textLight,
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Access Location Button
                CustomButton(
                  text: 'الوصول للموقع',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  width: double.infinity,
                  height: AppDimensions.inputHeight,
                ),
                
                SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
