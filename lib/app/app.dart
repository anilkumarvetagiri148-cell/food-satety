import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_routes.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/scan_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/scan_food_screen.dart';
import '../screens/scan_analysis_screen.dart';
import '../screens/scan_result_screen.dart';
import '../screens/scan_history_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/nutrition_details_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/eat_healthy_screen.dart';

class FoodSafeApp extends StatelessWidget {
  const FoodSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FoodSafe AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.onboarding: (context) => const OnboardingScreen(),
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.signup: (context) => const SignupScreen(),
              AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
              AppRoutes.scan: (context) => const ScanFoodScreen(),
              AppRoutes.scanAnalysis: (context) => const ScanAnalysisScreen(),
              AppRoutes.scanResult: (context) => const ScanResultScreen(),
              AppRoutes.history: (context) => const ScanHistoryScreen(),
              AppRoutes.alerts: (context) => const AlertsScreen(),
              AppRoutes.nutrition: (context) => const NutritionDetailsScreen(),
              AppRoutes.profile: (context) => const ProfileScreen(),
              AppRoutes.settings: (context) => const SettingsScreen(),
              AppRoutes.eatHealthy: (context) => const EatHealthyScreen(),
            },
          );
        },
      ),
    );
  }
}
