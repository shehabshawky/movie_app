import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // 1. If user is already logged in, go straight to Home
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeRoute,
        (route) => false,
      );
      return;
    }

    // 2. If onboarding was already seen, go to Login
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('is_onboarding_seen') ?? false;
    if (!mounted) return;

    if (onboardingSeen) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginRoute,
        (route) => false,
      );
    } else {
      // 3. First time, show Onboarding
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onboardingRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              'assets/splash_logo/splash1.png',
              width: 120,
              height: 120,
            ),
            const Spacer(flex: 3),
            Image.asset('assets/splash_logo/splash2.png', width: 160),
            const SizedBox(height: 8),
            const Text(
              'Supervised by Mohamed Nabil',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}