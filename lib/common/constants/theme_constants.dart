/// Theme-related constants
import 'package:flutter/material.dart';

class ThemeConstants {
  // Typography Scales
  static const double extraSmallFontSize = 10.0;
  static const double smallFontSize = 12.0;
  static const double mediumFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double extraLargeFontSize = 18.0;
  static const double extraExtraLargeFontSize = 22.0;
  static const double titleFontSize = 24.0;
  static const double headlineFontSize = 28.0;
  static const double displayFontSize = 32.0;
  
  // Font Weights
  static const FontWeight thinFontWeight = FontWeight.w100;
 static const FontWeight extraLightFontWeight = FontWeight.w200;
 static const FontWeight lightFontWeight = FontWeight.w300;
  static const FontWeight regularFontWeight = FontWeight.w400;
  static const FontWeight mediumFontWeight = FontWeight.w500;
  static const FontWeight semiBoldFontWeight = FontWeight.w600;
  static const FontWeight boldFontWeight = FontWeight.w700;
  static const FontWeight extraBoldFontWeight = FontWeight.w800;
  static const FontWeight blackFontWeight = FontWeight.w900;
  
  // Spacing
  static const double extraSmallSpacing = 4.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 12.0;
 static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 24.0;
  static const double extraExtraLargeSpacing = 32.0;
  static const double hugeSpacing = 48.0;
  static const double massiveSpacing = 64.0;
  
  // Border Radius
  static const double extraSmallBorderRadius = 2.0;
  static const double smallBorderRadius = 4.0;
  static const double mediumBorderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  static const double extraLargeBorderRadius = 16.0;
  static const double circularBorderRadius = 50.0;
  
  // Elevation
  static const double noElevation = 0.0;
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;
  static const double veryHighElevation = 16.0;
  
  // Opacity
  static const double lowOpacity = 0.2;
  static const double mediumOpacity = 0.5;
  static const double highOpacity = 0.8;
  static const double fullOpacity = 1.0;
  
  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 150);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
  static const Duration extraLongDuration = Duration(milliseconds: 1000);
  
  // Breakpoints
  static const double smallBreakpoint = 600.0;
  static const double mediumBreakpoint = 900.0;
  static const double largeBreakpoint = 1200.0;
  static const double extraLargeBreakpoint = 1400.0;
  
  // Theme Modes
  static const String lightThemeMode = 'light';
  static const String darkThemeMode = 'dark';
  static const String systemThemeMode = 'system';
  
  // Theme Keys
  static const String primarySwatchKey = 'primary_swatch';
  static const String accentColorKey = 'accent_color';
  static const String backgroundColorKey = 'background_color';
  static const String scaffoldBackgroundColorKey = 'scaffold_background_color';
  static const String cardColorKey = 'card_color';
  static const String dividerColorKey = 'divider_color';
  
  // Default Theme Values
  static const bool defaultUseMaterial3 = true;
  static const bool defaultApplyElevationOverlayColor = true;
  static const bool defaultUseTextSelectionTheme = true;
}