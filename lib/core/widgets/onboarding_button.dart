import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_theme.dart';

class OnboardingButton extends StatelessWidget {
  final String txt;
  final double? width;
  final VoidCallback ontap;
  final bool? blackbtn;

  const OnboardingButton({
    super.key,
    required this.txt,
    this.width,
    required this.ontap,
    this.blackbtn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 48,
        width: width,
        child: ElevatedButton(
          onPressed: ontap,
          style: ElevatedButton.styleFrom(
            backgroundColor: blackbtn == null
                ? AppColors.yellowColor
                : AppColors.darkBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(txt, style: AppTheme.themeOfApp.textTheme.labelMedium),
        ),
      ),
    );
  }
}