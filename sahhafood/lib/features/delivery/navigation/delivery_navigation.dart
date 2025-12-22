import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../ui/screens/delivery_home_screen.dart';
import '../ui/screens/delivery_profile_screen.dart';

class DeliveryNavigation extends ConsumerStatefulWidget {
  const DeliveryNavigation({super.key});

  @override
  ConsumerState<DeliveryNavigation> createState() => _DeliveryNavigationState();
}

class _DeliveryNavigationState extends ConsumerState<DeliveryNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DeliveryHomeScreen(),
    const DeliveryProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.delivery_dining,
                    label: 'الطلبات',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    label: 'الملف الشخصي',
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF7622).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.w,
              color: isSelected
                  ? const Color(0xFFFF7622)
                  : const Color(0xFF9CA3AF),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF7622),
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
