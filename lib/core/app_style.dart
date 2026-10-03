import 'package:flutter/painting.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class AppStyle {
  static TextStyle white36bold = TextStyle(
    fontSize: 36,
    color: AppColors.whiteColor,
    fontWeight: .bold,
  );
  static TextStyle white20normal = TextStyle(
    fontSize: 20,
    color: AppColors.lightTextColor,
  );
  static TextStyle black20bold = TextStyle(
    fontSize: 20,
    color: AppColors.lightTextColor,
    fontWeight: .w600
  );
}
