import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../widgets/phone_input_field.dart';

/// Signup screen for new user registration
/// Follows architecture rules: local state only, uses constants, clean UI
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال الاسم';
    }
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != _passwordController.text) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate local validation delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إنشاء الحساب بنجاح'),
            backgroundColor: AppColors.primary,
          ),
        );

        // Navigate to home screen after successful signup
        Navigator.of(context).pushNamed('/home');
      }
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ArabicText(
                            text: 'إنشاء حساب',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textOnDark,
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          ArabicText(
                            text: 'يرجى التسجيل للبدء',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textOnDarkSubtle,
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppDimensions.spacing40),
                          
                          // Name field
                          ArabicText(
                            text: 'الاسم',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'أدخل اسمك الكامل',
                            validator: _validateName,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Phone field
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
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Password field
                          ArabicText(
                            text: 'كلمة المرور',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          _buildPasswordField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                            validator: _validatePassword,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Confirm password field
                          ArabicText(
                            text: 'تأكيد كلمة المرور',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            validator: _validateConfirmPassword,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing32),
                          
                          // Signup button
                          CustomButton(
                            text: 'إنشاء حساب',
                            onPressed: _handleSignup,
                            width: double.infinity,
                            height: AppDimensions.buttonHeight,
                            isLoading: _isLoading,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          hintText: '**********',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textHint,
          ),
          filled: true,
          fillColor: AppColors.backgroundGrey,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.inputPaddingHorizontal,
            vertical: AppDimensions.inputPaddingVertical,
          ),
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
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textHint,
              size: AppDimensions.iconMedium,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
