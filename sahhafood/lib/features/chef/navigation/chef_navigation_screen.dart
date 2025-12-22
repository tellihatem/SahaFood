import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ui/screens/screens.dart';

class ChefNavigationScreen extends StatefulWidget {
  const ChefNavigationScreen({super.key});

  @override
  State<ChefNavigationScreen> createState() => _ChefNavigationScreenState();
}

class _ChefNavigationScreenState extends State<ChefNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChefDashboardScreen(),
    const ChefFoodListScreen(),
    const Center(child: Text('إضافة')), // Placeholder for add action
    const ChefNotificationsScreen(),
    const ChefProfileScreen(),
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
            if (index == 2) {
              // Show add menu for center button
              _showAddMenu(context);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
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
              icon: Icon(Icons.restaurant_menu_outlined, size: 24.w),
              activeIcon: Icon(Icons.restaurant_menu, size: 24.w),
              label: 'القائمة',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7622),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 24.w),
              activeIcon: Icon(Icons.notifications, size: 24.w),
              label: 'الإشعارات',
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

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _AddMenuBottomSheet(),
    );
  }
}

class _AddMenuBottomSheet extends StatelessWidget {
  const _AddMenuBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'إضافة جديد',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF32343E),
                ),
              ),
              SizedBox(height: 20.h),
              _AddMenuItem(
                icon: Icons.fastfood,
                title: 'إضافة طبق جديد',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chef/add-item');
                },
              ),
              _AddMenuItem(
                icon: Icons.receipt_long,
                title: 'عرض الطلبات الجارية',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chef/running-orders');
                },
              ),
              _AddMenuItem(
                icon: Icons.message,
                title: 'الرسائل',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chef/messages');
                },
              ),
              _AddMenuItem(
                icon: Icons.star,
                title: 'التقييمات',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chef/reviews');
                },
              ),
              _AddMenuItem(
                icon: Icons.delivery_dining,
                title: 'فريق التوصيل',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChefDeliveryTeamScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AddMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7622).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF7622),
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF32343E),
                ),
              ),
            ),
            Icon(
              Icons.arrow_back_ios,
              size: 16.w,
              color: const Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
