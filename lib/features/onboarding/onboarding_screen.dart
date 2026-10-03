import 'package:flutter/material.dart';
import 'package:movie_app/core/app_Assets.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/size_utils.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/core/widgets/onboarding_button.dart';
import 'package:movie_app/l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.onboardingPG1),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.width * 0.05),
          child: Column(
            spacing: context.width * 0.05,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.onboardingTitle1,
                style: AppTheme.themeOfApp.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!.onboardingSubtitle1,
                style: AppTheme.themeOfApp.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              OnboardingButton(
                txt: AppLocalizations.of(context)!.exploreNow,
                ontap: () {
                  Navigator.pushNamed(context, AppRoutes.onboardingPagesRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}