import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';

/// Reusable text field widget with consistent styling
/// Supports RTL for Arabic text and includes validation
class CustomTextField extends StatelessWidget {
  /// Placeholder text
  final String hintText;
  
  /// Text controller
  final TextEditingController? controller;
  
  /// Keyboard type
  final TextInputType keyboardType;
  
  /// Hide text (for passwords)
  final bool obscureText;
  
  /// Icon shown at the start of the field
  final Widget? prefixIcon;
  
  /// Icon shown at the end of the field
  final Widget? suffixIcon;
  
  /// Validation function
  final String? Function(String?)? validator;
  
  /// Callback when text changes
  final void Function(String)? onChanged;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Maximum character length
  final int? maxLength;
  
  /// Input formatters for custom validation
  final List<TextInputFormatter>? inputFormatters;
  
  /// Text direction
  final TextDirection textDirection;
  
  /// Border color when field has error
  final Color? errorBorderColor;
  
  /// Border color when field is focused
  final Color? focusBorderColor;
  
  /// Maximum lines for text field
  final int? maxLines;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.textDirection = TextDirection.rtl,
    this.errorBorderColor,
    this.focusBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.backgroundGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(
              color: focusBorderColor ?? AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(
              color: errorBorderColor ?? AppColors.error,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(
              color: errorBorderColor ?? AppColors.error,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.inputPaddingHorizontal,
            vertical: AppDimensions.inputPaddingVertical,
          ),
          counterText: '',
        ),
      ),
    );
  }
}
