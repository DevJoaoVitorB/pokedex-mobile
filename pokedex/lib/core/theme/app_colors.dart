import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF6F6F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFE3350D);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textMuted = Color(0xFF8E8E8E);
  static const Color textSecondary = textMuted;
  static const Color numberColor = Color(0xFFDBDDDD);
  static const Color border = Color(0xFFEAEAEA);
  static const Color cardAccent = Color(0xFFF2F3F7);

  static const Color chipNeutral = Color(0xFFEDEDED);

  static const Map<String, Color> typeColors = <String, Color>{
    'grass': Color(0xFF49D0B0),
    'poison': Color(0xFFA55DB4),
    'fire': Color(0xFFFF8A65),
    'water': Color(0xFF5AB1FF),
    'electric': Color(0xFFF7D02C),
    'ghost': Color(0xFF7C5AB8),
    'dragon': Color(0xFF6F7BFF),
    'flying': Color(0xFF90CAF9),
    'psychic': Color(0xFFF48FB1),
    'normal': Color(0xFFBDBDBD),
    'ice': Color(0xFF81D4FA),
    'rock': Color(0xFFBCAAA4),
    'ground': Color(0xFFA1887F),
    'bug': Color(0xFFAED581),
    'fighting': Color(0xFFE57373),
    'dark': Color(0xFF8D6E63),
    'steel': Color(0xFF90A4AE),
    'fairy': Color(0xFFF8BBD0),
  };

  static Color typeColor(String name) {
    return typeColors[name.toLowerCase()] ?? chipNeutral;
  }
}
