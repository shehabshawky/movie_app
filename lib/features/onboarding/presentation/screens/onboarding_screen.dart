import 'package:flutter/material.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/onboarding/presentation/controller/onboarding_provider.dart';
import 'package:movie_app/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:movie_app/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OnboardingPagesScreen extends StatelessWidget {
  const OnboardingPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider?>(
      builder: (context, provider, child) {
        if (provider != null) {
          return const _OnboardingPagesContent();
        }
        return ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
          child: const _OnboardingPagesContent(),
        );
      },
    );
  }
}

class _OnboardingPagesContent extends StatelessWidget {
  const _OnboardingPagesContent();

  Future<void> _onFinish(BuildContext context, OnboardingProvider provider) async {
    await provider.finishOnboarding();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final provider = context.watch<OnboardingProvider>();

    if (provider.isLoading || provider.pages.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.yellowColor),
        ),
      );
    }

    final currentPage = provider.pages[provider.currentPage];
    final bool isFirst = provider.isFirstPage;
    final bool isLast = provider.isLastPage;

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: OnboardingPageView(
              controller: provider.pageController,
              pages: provider.pages,
              onPageChanged: provider.onPageChanged,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.blackColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.getLocalizedTitle(currentPage, locale),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        provider.getLocalizedDescription(currentPage, locale),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.lightTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PageIndicator(
                      count: provider.pages.length,
                      currentIndex: provider.currentPage,
                      activeColor: AppColors.yellowColor,
                      inactiveColor: AppColors.greyColor,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLast) {
                            _onFinish(context, provider);
                          } else {
                            provider.nextPage();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellowColor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isLast
                              ? (locale?.finish ?? 'Finish')
                              : (locale?.next ?? 'Next'),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (!isFirst) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: provider.previousPage,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.yellowColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            locale?.back ?? 'Back',
                            style: const TextStyle(
                              color: AppColors.yellowColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}