import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/constants.dart';

/// Reusable custom button widget with loading state
/// Supports Arabic RTL layout and follows Material 3 design
class CustomButton extends StatelessWidget {
  /// Button text label
  final String text;
  
  /// Callback when button is pressed (null disables the button)
  final VoidCallback? onPressed;
  
  /// Background color, defaults to primary brand color
  final Color? backgroundColor;
  
  /// Text color, defaults to white
  final Color? textColor;
  
  /// Button width, defaults to 327
  final double? width;
  
  /// Button height, defaults to app standard
  final double? height;
  
  /// Corner radius
  final double? borderRadius;
  
  /// Horizontal padding around button
  final double horizontalPadding;
  
  /// Vertical padding around button
  final double verticalPadding;
  
  /// Shows loading indicator when true
  final bool isLoading;
  
  /// Optional icon to display before text
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? AppDimensions.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading || onPressed == null ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary,
            disabledBackgroundColor: (backgroundColor ?? AppColors.primary).withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppDimensions.radiusMedium,
              ),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: textColor ?? AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: AppDimensions.spacing8),
                    ],
                    Text(
                      text,
                      style: AppTextStyles.buttonText.copyWith(
                        color: textColor ?? AppColors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
