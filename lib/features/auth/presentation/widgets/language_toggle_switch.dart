import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_Assets.dart';
import '../../../../core/provider/language_provider.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageToggleSwitch extends StatelessWidget {
  const LanguageToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isArabic = languageProvider.appLanguage == 'ar';

    return Center(
      child: GestureDetector(
        onTap: () {
          languageProvider.changeLanguage(isArabic ? 'en' : 'ar');
        },
        child: Container(
          width: 80,
          height: 38,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.yellowColor,
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment:
                    isArabic ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    isArabic ? AppAssets.egyptFlag : AppAssets.usFlag,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment:
                    isArabic ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      isArabic ? AppAssets.usFlag : AppAssets.egyptFlag,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
