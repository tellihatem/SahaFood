import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/ui/screens/screens.dart';
import '../../order/ui/screens/orders_screen.dart';
import '../../profile/ui/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFF7622),
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24.w),
              activeIcon: Icon(Icons.home, size: 24.w),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 24.w),
              activeIcon: Icon(Icons.search, size: 24.w),
              label: 'بحث',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined, size: 24.w),
              activeIcon: Icon(Icons.receipt_long, size: 24.w),
              label: 'الطلبات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24.w),
              activeIcon: Icon(Icons.person, size: 24.w),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }
}
