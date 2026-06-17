import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Brand blue palette (from Figma Styleguide) ──────────────────────────────
  // Derived from the 004BE9 base color at 10%–100% tint steps
  static const Color brand50 = Color(0xFFCCDBFB); // 10% tint
  static const Color brand100 = Color(0xFFAAC3F8); // 20%
  static const Color brand200 = Color(0xFF80A5F4); // 30%
  static const Color brand300 = Color(0xFF5587F0); // 40%
  static const Color brand400 = Color(0xFF2A69ED); // 50%
  static const Color brand500 = Color(0xFF004BE9); // Base (primary)
  static const Color brand600 = Color(0xFF003FC2); // 60%
  static const Color brand700 = Color(0xFF00329B); // 70%
  static const Color brand800 = Color(0xFF002675); // 80%
  static const Color brand900 = Color(0xFF00194E); // 90%
  static const Color brand950 = Color(0xFF000F2F); // 100%

  // ── Semantic primary ────────────────────────────────────────────────────────
  static const Color primary = brand500;
  static const Color primaryLight = brand400;
  static const Color primaryDark = brand600;
  static const Color accent = primary; // backward-compat alias
  static const Color accentDark = primaryDark;

  // Secondary accent — Figma utility-indigo-500
  static const Color accentPurple = Color(0xFF6366F1);
  static const Color accentPurpleDark = Color(0xFF4F46E5);

  // ── Semantic trading ────────────────────────────────────────────────────────
  static const Color profitGreen = Color(0xFF12B76A); // success-500
  static const Color profitGreenBg = Color(0x1A12B76A);
  static const Color lossRed = Color(0xFFF04438); // error-500
  static const Color lossRedBg = Color(0x1AF04438);
  static const Color warningAmber = Color(0xFFF79009); // warning-500
  static const Color warningAmberBg = Color(0x1AF79009);

  // ── Light mode backgrounds ──────────────────────────────────────────────────
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF9FAFB);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFF9FAFB);
  static const Color bgCardElevated = Color(0xFFF2F4F7);
  static const Color glassOverlay = Color(0x1AFFFFFF);

  // ── Dark mode backgrounds (brand navy) ─────────────────────────────────────
  static const Color bgPrimaryDark = Color(0xFF0C0E1A);
  static const Color bgSecondaryDark = Color(0xFF141829);
  static const Color bgCardDark = Color(0xFF1B2035);
  static const Color bgCardElevatedDark = Color(0xFF232B45);

  // ── Text — light ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF475467);
  static const Color textTertiary = Color(0xFF667085);
  static const Color textDisabled = Color(0xFF98A2B3);

  // ── Text — dark ─────────────────────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF98A2B3);
  static const Color textTertiaryDark = Color(0xFF667085);
  static const Color textDisabledDark = Color(0xFF475467);

  // ── Borders ─────────────────────────────────────────────────────────────────
  static const Color borderLight = Color(0xFFEAECF0);
  static const Color borderDark = Color(0xFF1E2A45);
  static const Color borderGlass = Color(0x1AFFFFFF);
  static const Color borderAccent = primary;

  // ── Risk spectrum ────────────────────────────────────────────────────────────
  static const Color riskLow = profitGreen;
  static const Color riskLowBg = profitGreenBg;
  static const Color riskMedium = warningAmber;
  static const Color riskMediumBg = warningAmberBg;
  static const Color riskHigh = Color(0xFFF97316); // orange-500
  static const Color riskHighBg = Color(0x1AF97316);
  static const Color riskCritical = lossRed;
  static const Color riskCriticalBg = lossRedBg;

  // ── Status ───────────────────────────────────────────────────────────────────
  static const Color statusOpen = profitGreen;
  static const Color statusPending = warningAmber;
  static const Color statusFilled = primary;
  static const Color statusCancelled = Color(0xFF98A2B3);
  static const Color statusRejected = lossRed;

  // ── Misc ─────────────────────────────────────────────────────────────────────
  static const Color transparent = Color(0x00000000);
  static const Color scrim = Color(0x80000000);

  // ── Helpers ──────────────────────────────────────────────────────────────────
  static Color riskColor(double score) {
    if (score < 30) return riskLow;
    if (score < 60) return riskMedium;
    if (score < 80) return riskHigh;
    return riskCritical;
  }

  static Color riskBgColor(double score) {
    if (score < 30) return riskLowBg;
    if (score < 60) return riskMediumBg;
    if (score < 80) return riskHighBg;
    return riskCriticalBg;
  }

  static Color pnlColor(double value) => value >= 0 ? profitGreen : lossRed;
  static Color pnlBgColor(double value) =>
      value >= 0 ? profitGreenBg : lossRedBg;
}
