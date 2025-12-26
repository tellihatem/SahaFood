import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../widgets/phone_input_field.dart';
import 'signup_screen_new.dart';
import 'forgot_password_screen.dart';
import 'otp_verification_screen.dart';

/// Login screen for user authentication
/// Supports phone number and password login with RTL Arabic layout
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Format phone number with country code
      final phone = '+213${_phoneController.text}';
      final password = _passwordController.text;

      final success = await ref.read(authProvider.notifier).login(
        phone: phone,
        password: password,
      );

      if (!mounted) return;

      final authState = ref.read(authProvider);

      if (authState.requiresOtpVerification) {
        // Navigate to OTP verification
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(phoneNumber: phone),
          ),
        );
        return;
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تسجيل الدخول بنجاح'),
            backgroundColor: AppColors.primary,
          ),
        );

        // Navigate based on user role
        final userRole = authState.user.role;
        if (userRole.requiresRoleSelection) {
          Navigator.of(context).pushNamedAndRemoveUntil('/role-selection', (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      } else if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
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
                  // Eclipse pattern - top left
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
                  // Vector pattern - top right
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
                  // Content centered in dark section
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
                              text: 'تسجيل الدخول',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textOnDark,
                            ),
                            SizedBox(height: AppDimensions.spacing16),
                            ArabicText(
                              text: 'يرجى تسجيل الدخول إلى حسابك الحالي',
                              fontSize: 16,
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
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Password Input
                          ArabicText(
                            text: 'كلمة المرور',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          
                          SizedBox(height: AppDimensions.spacing12),
                          
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: _validatePassword,
                              style: AppTextStyles.bodyLarge,
                              decoration: InputDecoration(
                                hintText: '**********',
                                hintStyle: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textHint,
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.inputPaddingHorizontal,
                                  vertical: AppDimensions.inputPaddingVertical,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMedium,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textHint,
                                    size: AppDimensions.iconMedium,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: AppDimensions.spacing16),
                          
                          // Remember me & Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: AppDimensions.iconMedium,
                                    height: AppDimensions.iconMedium,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusSmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppDimensions.spacing8),
                                  ArabicText(
                                    text: 'تذكرني',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textLight,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _navigateToForgotPassword,
                                child: ArabicText(
                                  text: 'نسيت كلمة المرور',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: AppDimensions.spacing32),
                          
                          // Login Button
                          Consumer(
                            builder: (context, ref, child) {
                              final isLoading = ref.watch(authLoadingProvider);
                              return CustomButton(
                                text: 'تسجيل الدخول',
                                onPressed: _handleLogin,
                                width: double.infinity,
                                height: AppDimensions.buttonHeight,
                                isLoading: isLoading,
                              );
                            },
                          ),
                          
                          SizedBox(height: AppDimensions.spacing24),
                          
                          // Sign Up Link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ArabicText(
                                  text: 'ليس لديك حساب؟ ',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                                GestureDetector(
                                  onTap: _navigateToSignup,
                                  child: ArabicText(
                                    text: 'إنشاء حساب',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
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
