import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: AppTextStyles.fontFamily,

    primaryColor: AppColors.green,

    textTheme:
        const TextTheme(
          titleLarge: AppTextStyles.title1,
          bodyMedium: AppTextStyles.body,
        ).apply(
          bodyColor: AppColors.textPrimaryLight,
          displayColor: AppColors.textPrimaryLight,
        ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.green,
      selectionColor: AppColors.green.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.green,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    fontFamily: AppTextStyles.fontFamily,

    primaryColor: AppColors.green,

    textTheme:
        const TextTheme(
          titleLarge: AppTextStyles.title1,
          bodyMedium: AppTextStyles.body,
        ).apply(
          bodyColor: AppColors.textPrimaryDark,
          displayColor: AppColors.textPrimaryDark,
        ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.green,
      selectionColor: AppColors.green.withValues(alpha: 0.25),
      selectionHandleColor: AppColors.green,
    ),
  );
}
