import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../widgets/phone_input_field.dart';
import 'verification_screen.dart';

/// Forgot password screen for password recovery
/// Follows architecture rules: local state only, uses constants, clean UI
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (value.length != 9) {
      return 'رقم الهاتف يجب أن يكون 9 أرقام';
    }
    if (!value.startsWith('6') && !value.startsWith('7')) {
      return 'رقم الهاتف يجب أن يبدأ بالرقم 6 أو 7';
    }
    return null;
  }

  Future<void> _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate local validation delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: '+213${_phoneController.text}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Dark top section with patterns
            Container(
              height: AppDimensions.headerHeight,
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
              ),
              child: Stack(
                children: [
                  // Eclipse pattern
                  Positioned(
                    top: -160.h,
                    left: -120.w,
                    child: SizedBox(
                      width: AppDimensions.patternSize,
                      height: AppDimensions.patternSize,
                      child: SvgPicture.asset(
                        'assets/images/ellipse_pattern.svg',
                        colorFilter: ColorFilter.mode(
                          AppColors.patternOverlay,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Vector pattern
                  Positioned(
                    top: -40.h,
                    right: -125.w,
                    child: SizedBox(
                      width: AppDimensions.patternSize,
                      height: 400.h,
                      child: SvgPicture.asset(
                        'assets/images/vector_pattern.svg',
                        colorFilter: ColorFilter.mode(
                          AppColors.patternOverlayDark,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Back button
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AppDimensions.spacing32,
                        left: AppDimensions.spacing24,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: AppDimensions.iconButtonSize,
                            height: AppDimensions.iconButtonSize,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: AppDimensions.iconSmall,
                              color: AppColors.backgroundDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ArabicText(
                              text: 'نسيت كلمة المرور',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textOnDark,
                            ),
                            SizedBox(height: AppDimensions.spacing16),
                            ArabicText(
                              text: 'أدخل رقم هاتفك لإعادة تعيين كلمة المرور',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textOnDarkSubtle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // White content area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusXLarge),
                    topRight: Radius.circular(AppDimensions.radiusXLarge),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.spacing24,
                      AppDimensions.spacing32,
                      AppDimensions.spacing24,
                      AppDimensions.spacing24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.spacing40),
                          
                          // Info message
                          Container(
                            padding: EdgeInsets.all(AppDimensions.spacing16),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                              border: Border.all(
                                color: AppColors.info.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.info,
                                  size: AppDimensions.iconLarge,
                                ),
                                SizedBox(width: AppDimensions.spacing12),
                                Expanded(
                                  child: ArabicText(
                                    text: 'سنرسل لك رمز التحقق عبر الرسائل القصيرة',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.spacing32),
                          
                          // Phone Input
                          ArabicText(
                            text: 'رقم الهاتف',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing12),
                          
                          PhoneInputField(
                            controller: _phoneController,
                            validator: _validatePhone,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing32),
                          
                          // Send Code Button
                          CustomButton(
                            text: 'إرسال رمز التحقق',
                            onPressed: _handleSendCode,
                            width: double.infinity,
                            height: AppDimensions.buttonHeight,
                            isLoading: _isLoading,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Back to login link
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: AppDimensions.iconSmall,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: AppDimensions.spacing4),
                                  ArabicText(
                                    text: 'العودة لتسجيل الدخول',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.spacing40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
