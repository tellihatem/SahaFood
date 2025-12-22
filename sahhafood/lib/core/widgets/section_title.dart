import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/widgets.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArabicText(
          text: title,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF32343E),
        ),
        if (onSeeAllTap != null)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Row(
              children: [
                ArabicText(
                  text: 'مشاهدة الكل',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF7622),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.w,
                  color: const Color(0xFFFF7622),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
