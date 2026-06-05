import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFAFBFC);
  static const Color foreground = Color(0xFF282A31);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF6F8FA);

  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF282A31);

  static const Color primary = Color(0xFF32353E);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFF1F3F5);
  static const Color secondaryForeground = Color(0xFF32353E);

  static const Color muted = Color(0xFFEBECEF);
  static const Color mutedForeground = Color(0xFF707585);

  static const Color accent = Color(0xFF1976D2);
  static const Color accentForeground = Color(0xFFFFFFFF);

  static const Color destructive = Color(0xFFE53935);
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF388E3C);

  static const Color border = Color(0xFFDFE1E5);
  static const Color input = Color(0xFFE8EAED);
  static const Color ring = Color(0xFF1976D2);

  static const List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x0A282A31),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x08282A31),
      offset: Offset(0, 1),
      blurRadius: 1,
    ),
  ];

  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x1F282A31),
      offset: Offset(0, 6),
      blurRadius: 24,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x0F282A31),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> shadowFloat = [
    BoxShadow(
      color: Color(0x40282A31),
      offset: Offset(0, 20),
      blurRadius: 50,
      spreadRadius: -20,
    ),
  ];
}
