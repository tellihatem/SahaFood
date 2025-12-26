import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sahhafood/features/onboarding/screens/onboarding_screen.dart';
import 'package:sahhafood/features/auth/ui/screens/location_access_screen.dart';
import 'package:sahhafood/features/auth/ui/screens/role_selection_screen.dart';
import 'package:sahhafood/features/auth/ui/screens/login_screen.dart';
import 'package:sahhafood/features/auth/providers/auth_provider.dart';
import 'package:sahhafood/features/navigation/screens/main_navigation_screen.dart';
import 'package:sahhafood/features/chef/navigation/chef_navigation_screen.dart';
import 'package:sahhafood/features/chef/ui/screens/chef_add_item_screen.dart';
import 'package:sahhafood/features/chef/ui/screens/chef_running_orders_screen.dart';
import 'package:sahhafood/features/chef/ui/screens/chef_messages_screen.dart';
import 'package:sahhafood/features/chef/ui/screens/chef_reviews_screen.dart';
import 'package:sahhafood/features/delivery/navigation/delivery_navigation.dart';
import 'package:sahhafood/features/delivery/ui/screens/delivery_personal_info_screen.dart';
import 'package:sahhafood/features/delivery/ui/screens/delivery_earnings_screen.dart';
import 'package:sahhafood/features/delivery/ui/screens/delivery_history_screen.dart';
import 'package:sahhafood/features/delivery/ui/screens/delivery_settings_screen.dart';
import 'package:sahhafood/features/delivery/ui/screens/delivery_support_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load the Sen font
  await GoogleFonts.pendingFonts([
    GoogleFonts.getFont('Sen'),
    GoogleFonts.getFont('Tajawal'),
  ]);
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard iPhone 11 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Pre-cache the font to prevent FOUT (Flash of Unstyled Text)
        final textTheme = Theme.of(context).textTheme;
        GoogleFonts.tajawalTextTheme(textTheme);
        GoogleFonts.senTextTheme(textTheme);
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          title: 'Sahha Food',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: GoogleFonts.tajawalTextTheme(
              Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFF32343E),
                displayColor: const Color(0xFF32343E),
                fontFamily: 'Tajawal',
              ),
            ),
            fontFamily: 'Tajawal',
          ),
          locale: const Locale('ar', 'SA'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'),
          ],
          routes: {
            '/login': (context) => const LoginScreen(),
            '/location': (context) => const LocationAccessScreen(),
            '/home': (context) => const MainNavigationScreen(),
            '/role-selection': (context) => const RoleSelectionScreen(),
            '/chef/home': (context) => const ChefNavigationScreen(),
            '/chef/add-item': (context) => const ChefAddItemScreen(),
            '/chef/running-orders': (context) => const ChefRunningOrdersScreen(),
            '/chef/messages': (context) => const ChefMessagesScreen(),
            '/chef/reviews': (context) => const ChefReviewsScreen(),
            '/delivery/home': (context) => const DeliveryNavigation(),
            '/delivery/personal-info': (context) => const DeliveryPersonalInfoScreen(),
            '/delivery/earnings': (context) => const DeliveryEarningsScreen(),
            '/delivery/history': (context) => const DeliveryHistoryScreen(),
            '/delivery/settings': (context) => const DeliverySettingsScreen(),
            '/delivery/support': (context) => const DeliverySupportScreen(),
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure fonts are loaded before checking auth and navigating
    _loadFontsAndNavigate();
  }

  Future<void> _loadFontsAndNavigate() async {
    // Force load fonts by creating text with them
    // This ensures fonts are downloaded and cached before navigation
    await Future.wait([
      // Load Tajawal font variants
      GoogleFonts.tajawal(fontWeight: FontWeight.w400).fontFamily,
      GoogleFonts.tajawal(fontWeight: FontWeight.w500).fontFamily,
      GoogleFonts.tajawal(fontWeight: FontWeight.w600).fontFamily,
      GoogleFonts.tajawal(fontWeight: FontWeight.w700).fontFamily,
      // Load Sen font variants
      GoogleFonts.sen(fontWeight: FontWeight.w400).fontFamily,
      GoogleFonts.sen(fontWeight: FontWeight.w600).fontFamily,
      GoogleFonts.sen(fontWeight: FontWeight.w700).fontFamily,
    ].map((e) => Future.value(e)));

    // Initialize auth state - check for existing tokens
    await ref.read(authProvider.notifier).initialize();

    // Add minimum splash time
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.user.isLoggedIn) {
      // User is logged in - navigate based on role
      if (authState.user.role.requiresRoleSelection) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RoleSelectionScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    } else {
      // User is not logged in - show onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: 0.8.sw, // 80% of screen width
                height: 0.8.sw, // Maintain aspect ratio
                padding: EdgeInsets.all(20.w), // Responsive padding
                child: Image.asset(
                  'assets/images/Sahha-removebg.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading image: $error');
                    return const Center(
                      child: Text(
                        'خطأ في تحميل الصورة',
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Hidden text to preload fonts
            Positioned(
              left: -1000,
              top: -1000,
              child: Opacity(
                opacity: 0.0,
                child: Column(
                  children: [
                    Text('مرحبا', style: GoogleFonts.tajawal(fontWeight: FontWeight.w400)),
                    Text('مرحبا', style: GoogleFonts.tajawal(fontWeight: FontWeight.w500)),
                    Text('مرحبا', style: GoogleFonts.tajawal(fontWeight: FontWeight.w600)),
                    Text('مرحبا', style: GoogleFonts.tajawal(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
