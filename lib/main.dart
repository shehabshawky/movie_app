import 'package:flutter/material.dart';
import 'package:movie_app/core/provider/language_provider.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/onboarding/onboarding_screen.dart';
import 'package:movie_app/features/onboarding/presentation/controller/onboarding_provider.dart';
import 'package:movie_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movie_app/features/splash/splash_screen.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
      theme: AppTheme.themeOfApp,
      routes: {
        AppRoutes.splashRoute: (context) => const SplashScreen(),
        AppRoutes.onboardingRoute: (context) => const OnboardingScreen(),
        AppRoutes.onboardingPagesRoute: (context) =>
            const OnboardingPagesScreen(),
        AppRoutes.homeRoute: (context) => const Scaffold(
              body: Center(
                child: Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
      },
    );
  }
}