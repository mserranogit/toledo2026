import 'package:flutter/material.dart';

abstract class ToledoColors {
  // Paleta Imperial Toledana
  static const Color primary = Color(0xFF852221);       // Carmesí Imperial
  static const Color primaryDark = Color(0xFF631716);   // Granate Profundo
  static const Color primaryLight = Color(0xFFFBEEED);  // Tinte Suave Carmesí

  // Damasquinado y Oro Viejo
  static const Color accent = Color(0xFFC28833);        // Oro Toledano
  static const Color accentDark = Color(0xFF92400E);    // Oro Bronce
  static const Color accentLight = Color(0xFFFCF6EB);   // Fondo Crema Áureo

  // Fondos y Superficies
  static const Color bgBody = Color(0xFFF8FAFC);        // Fondo general (Slate 50)
  static const Color surface = Color(0xFFFFFFFF);       // Superficie de tarjetas
  static const Color surfaceAlt = Color(0xFFF1F5F9);    // Superficie alterna (Slate 100)
  static const Color darkSlate = Color(0xFF111827);     // Pizarra Nocturna Imperial
  static const Color darkCard = Color(0xFF1E293B);      // Tarjeta en modo oscuro

  // Textos y Lectura
  static const Color textMain = Color(0xFF1E293B);      // Texto principal alto contraste
  static const Color textMuted = Color(0xFF64748B);     // Subtítulos y metadatos
  static const Color textLight = Color(0xFF94A3B8);     // Leyendas y bordes tenues

  // Bordes y Divisores
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFFCBD5E1);

  // Insignias y Píldoras Semánticas (Badges)
  static const Color badgeFreeBg = Color(0xFFECFDF5);
  static const Color badgeFreeText = Color(0xFF065F46);
  static const Color badgeFreeBorder = Color(0xFFA7F3D0);

  static const Color badgeTourBg = Color(0xFFF5F3FF);
  static const Color badgeTourText = Color(0xFF5B21B6);
  static const Color badgeTourBorder = Color(0xFFDDD6FE);

  static const Color badgePriceBg = Color(0xFFFFFBEB);
  static const Color badgePriceText = Color(0xFF92400E);
  static const Color badgePriceBorder = Color(0xFFFDE68A);

  static const Color badgeWarnBg = Color(0xFFFEF2F2);
  static const Color badgeWarnText = Color(0xFF991B1B);
  static const Color badgeWarnBorder = Color(0xFFFECACA);
}
