import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgPrimaryDark : AppColors.bgPrimary;
    final bgCard = isDark ? AppColors.bgCardDark : AppColors.bgCard;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accentPurple,
      onSecondary: Colors.white,
      error: AppColors.lossRed,
      onError: Colors.white,
      surface: bg,
      onSurface: textPrimary,
      surfaceContainerHighest: bgCard,
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: bg,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.28),
        selectionHandleColor: AppColors.primary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTypography.buttonLg,
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
          textStyle: AppTypography.buttonLg,
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.lossRed, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide(color: AppColors.lossRed, width: 2),
        ),
        labelStyle: AppTypography.body.copyWith(color: textSecondary),
        hintStyle: AppTypography.body.copyWith(
          color: isDark ? AppColors.textDisabledDark : AppColors.textDisabled,
        ),
        helperStyle: AppTypography.bodySm.copyWith(color: textSecondary),
        floatingLabelStyle:
            AppTypography.body.copyWith(color: AppColors.primary),
        errorStyle: AppTypography.bodySm.copyWith(color: AppColors.lossRed),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.labelSm,
        unselectedLabelStyle: AppTypography.labelSm,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 0,
      ),

      // List tile
      listTileTheme: ListTileThemeData(
        tileColor: bgCard,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.bgCardDark : AppColors.bgSecondary,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: AppTypography.label,
        side: BorderSide(color: border),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.chipRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: bgCard,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadiusLg,
        ),
        titleTextStyle: AppTypography.h3.copyWith(color: textPrimary),
        contentTextStyle: AppTypography.body.copyWith(color: textSecondary),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: bgCard,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.sheetRadius,
        ),
        constraints: const BoxConstraints(maxWidth: double.infinity),
      ),

      // Snack bar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.bgCardDark : AppColors.textPrimary,
        contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
      ),

      // Progress indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.brand100.withValues(alpha: 0.3),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.brand200.withValues(alpha: 0.3),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.brand500.withValues(alpha: 0.12),
        trackHeight: 3,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textDisabled,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.3)
              : border,
        ),
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
