//* THEMES
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wajanja/utils/constants/app_colors.dart';
import 'package:wajanja/utils/constants/app_typography.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primaryLight,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.bgLight,
      surface: AppColors.bgLight,
      onSurface: AppColors.bgDark,
      error: AppColors.red,
      secondary: AppColors.deepSlateLight,
      onSecondary: AppColors.bgDark,
      secondaryContainer: AppColors.smokeyGrayLight,
      onSecondaryContainer: AppColors.bgDark,
      tertiary: AppColors.gray500,
      outline: AppColors.gray500Light,
      surfaceTint: AppColors.yellowGreenLight,
    ),
    useMaterial3: false,

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        ),
      ),
    ),

    //* My text themes
    textTheme: TextTheme(
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.bgDark,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.bgDark),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.bgDark),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.bgDark),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.bgDark),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.bgDark),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.smokeyGrayLight,
      thickness: 0.5,
    ),

    //*My list tile theme
    listTileTheme: ListTileThemeData(
      titleAlignment: ListTileTitleAlignment.top,
      minVerticalPadding: 10.h,
    ),

    //* My button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(1.0),
        minimumSize: WidgetStatePropertyAll(Size(0, 54.h)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          // if (states.contains(WidgetState.disabled)) {
          //   return AppColors.lightGrey;
          // }

          return AppColors.primaryLight;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyMedium.copyWith(
            color: AppColors.bgLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyMedium.copyWith(color: AppColors.primaryLight),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 48.h)),
        side: const WidgetStatePropertyAll(
          BorderSide(color: Colors.transparent),
        ),
      ),
    ),

    //* Scaffold theme
    scaffoldBackgroundColor: AppColors.bgLight,
    checkboxTheme: CheckboxThemeData(
      splashRadius: 0,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }

        return Colors.transparent;
      }),
      side: BorderSide(width: 0.5, color: AppColors.gray500Light),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),

    //* My app bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarHeight: 54.h,
      backgroundColor: AppColors.bgLight,
      // shadowColor: AppColors.lavenderGrey,
      iconTheme: IconThemeData(size: 24.r, weight: 1, color: AppColors.bgDark),
      titleTextStyle: AppTypography.headlineMedium.copyWith(
        color: AppColors.bgDark,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: false,
    ),

    //* Input slider theme
    // sliderTheme: SliderThemeData(
    //     minThumbSeparation: 0,
    //     trackHeight: 0.2.h,
    //     activeTrackColor: AppColors.royalPurple,
    //     thumbColor: AppColors.royalPurple,
    //     overlayColor: AppColors.royalPurple.withOpacity(0.2),
    //     inactiveTrackColor: AppColors.lavenderMist),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.gray500, // Cursor color
      selectionColor: AppColors.gray500Light, // Text highlight color
      selectionHandleColor: AppColors.gray500, // Selection handle color
    ),

    //* Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.hintLight),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),

      //* padding
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return AppColors.red.withValues(alpha: 0.4);
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.smokeyGrayLight;
        }

        return AppColors.smokeyGrayLight.withValues(alpha: 0.8);
      }),

      filled: true,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    // useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primaryDark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.bgDark,
      surface: AppColors.bgDark,
      onSurface: AppColors.bgLight,
      error: AppColors.red,
      secondary: AppColors.deepSlateDark,
      onSecondary: AppColors.bgLight,
      secondaryContainer: AppColors.smokeyGrayDark,
      onSecondaryContainer: AppColors.white,
      tertiary: AppColors.gray500,
      outline: AppColors.gray500,
      surfaceTint: AppColors.yellowGreenLight,
    ),
    useMaterial3: false,

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        ),
      ),
    ),

    //* My text themes
    textTheme: TextTheme(
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.bgLight,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.bgLight),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.bgLight),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.bgLight),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.bgLight),
      labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.bgLight),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.smokeyGrayDark,
      thickness: 0.5,
    ),

    //*My list tile theme
    listTileTheme: ListTileThemeData(
      titleAlignment: ListTileTitleAlignment.top,
      minVerticalPadding: 10.h,
    ),

    //* My button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0.0),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          // if (states.contains(WidgetState.disabled)) {
          //   return AppColors.lightGrey;
          // }

          return AppColors.primaryDark;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyMedium.copyWith(
            color: AppColors.bgDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyMedium.copyWith(color: AppColors.primaryDark),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, 48.h)),
        side: const WidgetStatePropertyAll(
          BorderSide(color: Colors.transparent),
        ),
      ),
    ),

    //* Scaffold theme
    scaffoldBackgroundColor: AppColors.bgDark,
    checkboxTheme: CheckboxThemeData(
      splashRadius: 0,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }

        return Colors.transparent;
      }),
      side: BorderSide(width: 0.5, color: AppColors.gray500),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),

    //* My app bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarHeight: 54.h,
      backgroundColor: AppColors.bgDark,

      // shadowColor: AppColors.lavenderGrey,
      iconTheme: IconThemeData(size: 24.r, weight: 1, color: AppColors.bgLight),
      titleTextStyle: AppTypography.headlineMedium.copyWith(
        color: AppColors.bgLight,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: false,
    ),

    //* Input slider theme
    // sliderTheme: SliderThemeData(
    //     minThumbSeparation: 0,
    //     trackHeight: 0.2.h,
    //     activeTrackColor: AppColors.royalPurple,
    //     thumbColor: AppColors.royalPurple,
    //     overlayColor: AppColors.royalPurple.withOpacity(0.2),
    //     inactiveTrackColor: AppColors.lavenderMist),

    //* Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.hintDark.withValues(alpha: 0.5),
      ),

      //* padding
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return AppColors.red.withValues(alpha: 0.4);
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.smokeyGrayDark;
        }

        return AppColors.smokeyGrayDark.withValues(alpha: 0.8);
      }),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),

      filled: true,
    ),
  );
}
