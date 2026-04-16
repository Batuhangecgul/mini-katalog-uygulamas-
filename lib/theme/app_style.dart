import 'package:flutter/material.dart';

class AppStyle {
  static const Color primary = Color(0xFFD97706);
  static const Color secondary = Color(0xFF0EA5A4);
  static const Color ink = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color backgroundTop = Color(0xFFFFF7ED);
  static const Color backgroundBottom = Color(0xFFE0F2FE);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundTop, backgroundBottom],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}