import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../providers/auth_provider.dart';

/// OTP Verification screen for phone number verification
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _canResend = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otp.length == 6;

  void _onOtpDigitChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_isOtpComplete) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;

    final success = await ref.read(authProvider.notifier).verifyOtp(
      phone: widget.phoneNumber,
      otp: _otp,
    );

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم التحقق بنجاح'),
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
      // Clear OTP fields on error
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    final success = await ref.read(authProvider.notifier).sendOtp(
      phone: widget.phoneNumber,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إرسال رمز التحقق'),
          backgroundColor: AppColors.primary,
        ),
      );
      _startResendTimer();
    } else {
      final authState = ref.read(authProvider);
      if (authState.error != null) {
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
                            text: 'التحقق من الرمز',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textOnDark,
                          ),
                          SizedBox(height: AppDimensions.spacing12),
                          ArabicText(
                            text: 'أدخل الرمز المرسل إلى',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textOnDarkSubtle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppDimensions.spacing8),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: ArabicText(
                              text: widget.phoneNumber,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textOnDark,
                              textAlign: TextAlign.center,
                            ),
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
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.spacing40),

                        // OTP Input Fields
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => _buildOtpField(index),
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimensions.spacing32),

                        // Verify Button
                        Consumer(
                          builder: (context, ref, child) {
                            final isLoading = ref.watch(authLoadingProvider);
                            return CustomButton(
                              text: 'تحقق',
                              onPressed: _isOtpComplete ? () => _verifyOtp() : null,
                              width: double.infinity,
                              height: AppDimensions.buttonHeight,
                              isLoading: isLoading,
                            );
                          },
                        ),

                        SizedBox(height: AppDimensions.spacing24),

                        // Resend OTP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ArabicText(
                              text: 'لم تستلم الرمز؟ ',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                            GestureDetector(
                              onTap: _canResend ? _resendOtp : null,
                              child: ArabicText(
                                text: _canResend
                                    ? 'إعادة الإرسال'
                                    : 'إعادة الإرسال ($_resendCountdown)',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _canResend
                                    ? AppColors.primary
                                    : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacing40),
                      ],
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

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 48.w,
      height: 56.h,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            _onBackspace(index);
          }
        },
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.backgroundGrey,
            contentPadding: EdgeInsets.zero,
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
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) => _onOtpDigitChanged(value, index),
        ),
      ),
    );
  }
}
