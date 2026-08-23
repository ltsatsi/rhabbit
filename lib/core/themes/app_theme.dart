// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productivity_app/core/constants/app_color.dart';

class AppTheme {
  // app light theme
  static final lightTheme = ThemeData(
    // application yheme config
    useMaterial3: true,
    brightness: Brightness.light,

    // primary rheme
    scaffoldBackgroundColor: AppColor.lightBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.seedColor,
      brightness: Brightness.light,
      outline: AppColor.borderLight,
    ),

    // text theme
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.seedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // dialog theme
    dialogTheme: DialogThemeData(backgroundColor: AppColor.lightFill),

    // input theme
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColor.lightFill,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.enabledBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // snack bar theme
    snackBarTheme: SnackBarThemeData(backgroundColor: AppColor.darkFill),

    // card theme
    cardTheme: CardThemeData(color: AppColor.lightBg, elevation: 8),

    // pop-up menu / dropdown theme
    popupMenuTheme: PopupMenuThemeData(
      color: AppColor.lightBg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
    ),

    // switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }

        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColor.seedColor;
        }

        return Colors.grey.shade300;
      }),
    ),
  );

  // app dark theme
  static final darkTheme = ThemeData(
    // application theme config
    useMaterial3: true,
    brightness: Brightness.dark,

    // primary theme
    scaffoldBackgroundColor: AppColor.darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.seedColor,
      brightness: Brightness.dark,
      outline: AppColor.borderDark,
    ),

    // text theme w/ google fonts
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.seedColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // dialog theme
    dialogTheme: DialogThemeData(backgroundColor: AppColor.darkFill),

    // input theme
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColor.darkFill,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.enabledBorderDark),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderDark),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderDark),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.focusedBorderDark),
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // snackbar theme
    snackBarTheme: SnackBarThemeData(backgroundColor: AppColor.darkFill),

    // card theme
    cardTheme: CardThemeData(color: AppColor.darkBg, elevation: 8),

    // pop-up menu / dropdown theme
    popupMenuTheme: PopupMenuThemeData(
      color: AppColor.darkBg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
    ),

    // switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }

        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColor.seedColor;
        }

        return Colors.grey.shade300;
      }),
    ),
  );
} // end class
