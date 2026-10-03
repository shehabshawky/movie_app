import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/api/dio_helper.dart';
import 'package:movie_app/core/provider/app_provider.dart';
import 'package:movie_app/core/provider/language_provider.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/auth/presentation/controller/auth_provider.dart';
import 'package:movie_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/login_screen.dart';
import 'package:movie_app/features/auth/presentation/screens/register_screen.dart';
import 'package:movie_app/features/movies/data/api/dio_movie_helper.dart';
import 'package:movie_app/features/movies/presentation/view/home/home_tab_view.dart';
import 'package:movie_app/features/movies/presentation/view/movie_details/film_details.dart';
import 'package:movie_app/features/movies/presentation/view/movie_details/movie_player.dart';
import 'package:movie_app/features/movies/presentation/view/profile/editProfile_screen.dart';
import 'package:movie_app/features/onboarding/onboarding_screen.dart';
import 'package:movie_app/features/onboarding/presentation/controller/onboarding_provider.dart';
import 'package:movie_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movie_app/features/splash/splash_screen.dart';
import 'package:movie_app/features/tabs/main_layout.dart';
import 'package:movie_app/firebase_options.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DioHelper.init();
  await DioMovieHelper.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
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
        AppRoutes.homeRoute: (context) => MainLayout(),
        AppRoutes.filmDetails: (context) => FilmDetails(),
        AppRoutes.moviePlayer: (context) => MoviePlayer(),
        AppRoutes.editProfileScreen: (context) => EditProfileScreen(),
        AppRoutes.mainLayoutRoute: (context) => MainLayout(),
        AppRoutes.forgetPasswordRoute: (context) =>
            const ForgetPasswordScreen(),
        AppRoutes.registerRoute: (context) => const RegisterScreen(),
        AppRoutes.loginRoute: (context) => const LoginScreen(),
      },
    );
  }
}
