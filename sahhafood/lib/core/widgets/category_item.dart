import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/widgets.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String? imagePath;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const CategoryItem({
    super.key,
    required this.title,
    this.imagePath,
    required this.backgroundColor,
    required this.textColor,
    this.isSelected = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 80.w,
        height: height ?? 80.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular((width ?? 80.w) / 2),
          border: isSelected 
            ? Border.all(color: const Color(0xFFFF7622), width: 2)
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                width: 32.w,
                height: 32.w,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fastfood,
                    size: 32.w,
                    color: textColor,
                  );
                },
              ),
              SizedBox(height: 4.h),
            ],
            ArabicText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
