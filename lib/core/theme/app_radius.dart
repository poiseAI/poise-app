import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double none = 0.0;
  static const double xs = 2.0; // Figma base — near-square
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 999.0;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius cardRadiusLg =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillRadius =
      BorderRadius.all(Radius.circular(full));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  // Chat bubble radii — large corner on the outer side, small on connecting side
  static const BorderRadius bubbleOutgoing = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(sm),
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(xl),
  );
  static const BorderRadius bubbleIncoming = BorderRadius.only(
    topLeft: Radius.circular(sm),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(xl),
  );

  // Radial context-menu item pill
  static const BorderRadius menuRadius = BorderRadius.all(Radius.circular(xl));
}
