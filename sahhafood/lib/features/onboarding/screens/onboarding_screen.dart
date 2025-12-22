import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/widgets.dart';
import '../../../core/widgets/slider_indicator.dart';
import 'package:sahhafood/features/onboarding/screens/onboarding_screen_1.dart';
import 'package:sahhafood/features/onboarding/screens/onboarding_screen_2.dart';
import 'package:sahhafood/features/onboarding/screens/onboarding_screen_3.dart';
import 'package:sahhafood/features/onboarding/screens/onboarding_screen_4.dart';
import 'package:sahhafood/features/auth/ui/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _onboardingScreens = [
    const OnboardingScreen1(),
    const OnboardingScreen2(),
    const OnboardingScreen3(),
    const OnboardingScreen4(),
  ];

  void _nextPage() {
    if (_currentPage < _onboardingScreens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _skipOnboarding() {
    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Force LTR for the entire screen
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingScreens.length,
                  itemBuilder: (context, index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: _onboardingScreens[index],
                                  ),
                                  
                                  SizedBox(height: 20.h),
                                  
                                  // Slider Indicator
                                  SliderIndicator(
                                    currentIndex: _currentPage,
                                    itemCount: _onboardingScreens.length,
                                    activeColor: const Color(0xFFFF7622),
                                    inactiveColor: const Color(0xFFFFE1CE),
                                    dotSize: 10.w,
                                    spacing: 12.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                ),
              ),
              
              // Bottom Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  children: [
                    // Next Button
                    CustomButton(
                      text: _currentPage == _onboardingScreens.length - 1 ? 'ابدأ الآن' : 'التالي',
                      onPressed: _nextPage,
                      width: double.infinity,
                      height: 56.h,
                      backgroundColor: const Color(0xFFFF7622),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Skip Button
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: ArabicText(
                        text: 'تخطي',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF646982),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
