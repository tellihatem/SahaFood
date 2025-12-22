import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/constants.dart';

/// Reusable section header widget with title and optional action button
/// Used throughout the app for consistent section headings
class SectionHeader extends StatelessWidget {
  /// Main title text
  final String title;
  
  /// Optional action text (e.g., "See All")
  final String? actionText;
  
  /// Callback when action is tapped
  final VoidCallback? onActionTap;
  
  /// Title text style override
  final TextStyle? titleStyle;
  
  /// Action text style override
  final TextStyle? actionStyle;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.titleStyle,
    this.actionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing24,
        vertical: AppDimensions.spacing16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? AppTextStyles.headlineSmall,
          ),
          if (actionText != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: actionStyle ?? AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
