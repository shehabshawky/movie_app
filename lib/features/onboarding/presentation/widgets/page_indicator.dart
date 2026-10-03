import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotWidth;
  final double activeDotWidth;
  final double dotHeight;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = AppColors.yellowColor,
    this.inactiveColor = AppColors.greyColor,
    this.dotWidth = 8.0,
    this.activeDotWidth = 24.0,
    this.dotHeight = 8.0,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? activeDotWidth : dotWidth,
          height: dotHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotHeight / 2),
          ),
        );
      }),
    );
  }
}