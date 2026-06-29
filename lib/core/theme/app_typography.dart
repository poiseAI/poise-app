import 'package:flutter/material.dart';
import 'app_colors.dart';

// Orbitron: display/high-impact headlines + OTP inputs (brand guide §4.2/4.5)
// Inter: headings, body, labels, captions, buttons (brand guide §4.3/4.5)

abstract final class AppTypography {
  static const String _inter = 'Inter';
  static const String _orbitron = 'Orbitron';

  // ── Display ──────────────────────────────────────────────────────────────────
  // Figma: Display lg/Bold  48px / 60px line-height / -2% tracking
  static const TextStyle display1 = TextStyle(
    fontFamily: _orbitron,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.25, // 60 / 48
    letterSpacing: -0.96, // -2% × 48
    color: AppColors.textPrimary,
  );

  // Figma: Display md/Bold  36px / 44px line-height / -2% tracking
  static const TextStyle display2 = TextStyle(
    fontFamily: _orbitron,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.222, // 44 / 36
    letterSpacing: -0.72, // -2% × 36
    color: AppColors.textPrimary,
  );

  // ── Headings ─────────────────────────────────────────────────────────────────
  // Figma: Display xs/Bold  24px / 32px
  static const TextStyle h1 = TextStyle(
    fontFamily: _inter,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.333, // 32 / 24
    color: AppColors.textPrimary,
  );

  // Figma: Text xl/Semibold  20px / 30px
  static const TextStyle h2 = TextStyle(
    fontFamily: _inter,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5, // 30 / 20
    color: AppColors.textPrimary,
  );

  // Figma: Text lg/Semibold  18px / 28px
  static const TextStyle h3 = TextStyle(
    fontFamily: _inter,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.556, // 28 / 18
    color: AppColors.textPrimary,
  );

  // Figma: Text md/Semibold  16px / 24px
  static const TextStyle h4 = TextStyle(
    fontFamily: _inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5, // 24 / 16
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────────────────────────
  // Figma: Text md/Regular  16px / 24px
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Figma: Text sm/Regular  14px / 20px
  static const TextStyle body = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.429, // 20 / 14
    color: AppColors.textPrimary,
  );

  // Body with the label tone used in the new billing feature rows
  static const TextStyle bodyLabel = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.429, // 20 / 14
    color: AppColors.textLabel,
  );

  // Figma: Text xs/Regular  12px / 18px
  static const TextStyle bodySm = TextStyle(
    fontFamily: _inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // Figma: Text sm/Medium  14px / 20px
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.429,
    color: AppColors.textPrimary,
  );

  // ── Numeric / trading — Inter with tabular figures ───────────────────────────
  static const TextStyle numericXl = TextStyle(
    fontFamily: _inter,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.5,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static const TextStyle numericLg = TextStyle(
    fontFamily: _inter,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static const TextStyle numeric = TextStyle(
    fontFamily: _inter,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static const TextStyle numericMd = TextStyle(
    fontFamily: _inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static const TextStyle numericSm = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textPrimary,
  );

  static const TextStyle numericXs = TextStyle(
    fontFamily: _inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.textSecondary,
  );

  // ── Labels / captions ────────────────────────────────────────────────────────
  // Figma: Text xs/Medium  12px / 18px
  static const TextStyle label = TextStyle(
    fontFamily: _inter,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: _inter,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _inter,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  // ── Buttons ──────────────────────────────────────────────────────────────────
  // Figma: Text md/Semibold  16px / 24px
  static const TextStyle buttonLg = TextStyle(
    fontFamily: _inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  // Figma: Text sm/Semibold  14px / 20px
  static const TextStyle button = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  // Figma: Text xs/Semibold  12px / 18px
  static const TextStyle buttonSm = TextStyle(
    fontFamily: _inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );
}
