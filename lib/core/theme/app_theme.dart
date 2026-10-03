import 'package:flutter/material.dart';
import 'package:movie_app/core/app_style.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData themeOfApp = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blackColor),
    scaffoldBackgroundColor: AppColors.blackColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.blackColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.yellowColor),
      
      titleTextStyle: TextStyle(
        color: AppColors.yellowColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: AppStyle.white36bold,
      titleMedium: AppStyle.white20normal,
      labelMedium: AppStyle.black20bold
    )
  );
}
