import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';

/// Phone input field widget specific to Algerian phone numbers
/// Includes country code (+213) and validates 9-digit phone numbers starting with 6 or 7
class PhoneInputField extends StatefulWidget {
  /// Text controller for the phone number
  final TextEditingController? controller;
  
  /// Validation function
  final String? Function(String?)? validator;
  
  /// Callback when text changes
  final void Function(String)? onChanged;

  const PhoneInputField({
    Key? key,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Country Code Container
        Container(
          height: AppDimensions.inputHeight,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🇩🇿',
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(width: AppDimensions.spacing8),
              Text(
                '+213',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: AppDimensions.spacing12),
        
        // Phone Number Input
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  if (widget.validator != null) {
                    setState(() {
                      _errorText = widget.validator!(value);
                    });
                  }
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                maxLength: 9,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: '6xxxxxxxx',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing16,
                    vertical: AppDimensions.spacing16,
                  ),
                  counterText: '',
                ),
              ),
              if (_errorText != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: AppDimensions.spacing8,
                    right: AppDimensions.spacing12,
                  ),
                  child: Text(
                    _errorText!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
