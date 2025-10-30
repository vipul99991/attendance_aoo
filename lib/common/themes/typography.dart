/// Define text styles and typography system
import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';
import 'color_palette.dart';

class TypographyUtils {
  // Headline styles
 static const TextStyle headlineLargeStyle = TextStyle(
    fontSize: ThemeConstants.headlineFontSize,
    fontWeight: ThemeConstants.boldFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle headlineMediumStyle = TextStyle(
    fontSize: ThemeConstants.titleFontSize,
    fontWeight: ThemeConstants.semiBoldFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle headlineSmallStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  // Title styles
  static const TextStyle titleLargeStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle titleMediumStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle titleSmallStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  // Body styles
  static const TextStyle bodyLargeStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle bodyMediumStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle bodySmallStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.lightOnSurfaceVariant,
 );

  // Label styles
  static const TextStyle labelLargeStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle labelMediumStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle labelSmallStyle = TextStyle(
    fontSize: ThemeConstants.extraSmallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  // Display styles
  static const TextStyle displayLargeStyle = TextStyle(
    fontSize: ThemeConstants.displayFontSize,
    fontWeight: ThemeConstants.boldFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle displayMediumStyle = TextStyle(
    fontSize: ThemeConstants.headlineFontSize,
    fontWeight: ThemeConstants.semiBoldFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  static const TextStyle displaySmallStyle = TextStyle(
    fontSize: ThemeConstants.titleFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.lightOnSurface,
  );

  // App-specific styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.semiBoldFontWeight,
    color: ColorPalette.onPrimary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.onPrimary,
  );

  static const TextStyle chipTextStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.onPrimary,
  );

  static const TextStyle tabTextStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.semiBoldFontWeight,
    color: ColorPalette.onSurface,
  );

  static const TextStyle drawerTextStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.onSurface,
  );

  static const TextStyle listTileTitleStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.onSurface,
  );

  static const TextStyle listTileSubtitleStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.onSurfaceVariant,
  );

 // Form element styles
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.onSurface,
  );

  static const TextStyle inputHintStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.lightOnSurfaceVariant,
 );

  static const TextStyle inputLabelStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.primary,
  );

  // Card styles
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: ThemeConstants.largeFontSize,
    fontWeight: ThemeConstants.semiBoldFontWeight,
    color: ColorPalette.onSurface,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.onSurfaceVariant,
  );

 static const TextStyle cardContentStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.onSurface,
  );

 // Status text styles
  static const TextStyle statusActiveStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.success,
  );

  static const TextStyle statusInactiveStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.regularFontWeight,
    color: ColorPalette.gray600,
  );

  static const TextStyle statusWarningStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.warning,
  );

 static const TextStyle statusErrorStyle = TextStyle(
    fontSize: ThemeConstants.smallFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.danger,
  );

  // Attendance-specific text styles
 static const TextStyle attendanceCheckInStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.checkIn,
  );

  static const TextStyle attendanceCheckOutStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.checkOut,
  );

  static const TextStyle attendanceLateStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.late,
  );

  static const TextStyle attendanceAbsentStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.absent,
  );

  static const TextStyle attendanceOnLeaveStyle = TextStyle(
    fontSize: ThemeConstants.mediumFontSize,
    fontWeight: ThemeConstants.mediumFontWeight,
    color: ColorPalette.onLeave,
  );

  // App text theme
  static TextTheme get appTextTheme {
    return const TextTheme(
      displayLarge: displayLargeStyle,
      displayMedium: displayMediumStyle,
      displaySmall: displaySmallStyle,
      headlineLarge: headlineLargeStyle,
      headlineMedium: headlineMediumStyle,
      headlineSmall: headlineSmallStyle,
      titleLarge: titleLargeStyle,
      titleMedium: titleMediumStyle,
      titleSmall: titleSmallStyle,
      bodyLarge: bodyLargeStyle,
      bodyMedium: bodyMediumStyle,
      bodySmall: bodySmallStyle,
      labelLarge: labelLargeStyle,
      labelMedium: labelMediumStyle,
      labelSmall: labelSmallStyle,
    );
 }

  // Get text style by size
  static TextStyle getTextStyleBySize(double fontSize) {
    switch (fontSize) {
      case ThemeConstants.extraSmallFontSize:
        return bodySmallStyle;
      case ThemeConstants.smallFontSize:
        return bodySmallStyle;
      case ThemeConstants.mediumFontSize:
        return bodyMediumStyle;
      case ThemeConstants.largeFontSize:
        return bodyLargeStyle;
      case ThemeConstants.extraLargeFontSize:
        return headlineSmallStyle;
      case ThemeConstants.extraExtraLargeFontSize:
        return headlineMediumStyle;
      case ThemeConstants.titleFontSize:
        return titleMediumStyle;
      case ThemeConstants.headlineFontSize:
        return headlineLargeStyle;
      case ThemeConstants.displayFontSize:
        return displayLargeStyle;
      default:
        return bodyMediumStyle;
    }
  }

  // Get text style by weight
  static TextStyle getTextStyleByWeight(FontWeight fontWeight) {
    switch (fontWeight) {
      case ThemeConstants.regularFontWeight:
        return bodyMediumStyle;
      case ThemeConstants.mediumFontWeight:
        return titleMediumStyle;
      case ThemeConstants.semiBoldFontWeight:
        return titleLargeStyle;
      case ThemeConstants.boldFontWeight:
        return headlineSmallStyle;
      default:
        return bodyMediumStyle;
    }
 }

  // Get text style by size and weight
  static TextStyle getTextStyle({double? fontSize, FontWeight? fontWeight}) {
    TextStyle baseStyle = fontSize != null ? getTextStyleBySize(fontSize) : bodyMediumStyle;
    FontWeight weight = fontWeight ?? baseStyle.fontWeight ?? ThemeConstants.regularFontWeight;
    
    return baseStyle.copyWith(fontWeight: weight);
  }
}