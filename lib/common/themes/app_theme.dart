/// Enhanced theme implementation with light/dark themes
import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'typography.dart';
import '../constants/theme_constants.dart';

class AppTheme {
  // Light theme implementation
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: ThemeConstants.defaultUseMaterial3,
      colorScheme: _lightColorScheme,
      textTheme: TypographyUtils.appTextTheme,
      primaryTextTheme: TypographyUtils.appTextTheme,
      scaffoldBackgroundColor: ColorPalette.lightScaffoldBackground,
      appBarTheme: _appBarTheme,
      bottomAppBarTheme: _bottomAppBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      chipTheme: _chipTheme,
      dividerTheme: _dividerTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      expansionTileTheme: _expansionTileTheme,
    );
 }

  // Dark theme implementation
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: ThemeConstants.defaultUseMaterial3,
      colorScheme: _darkColorScheme,
      textTheme: TypographyUtils.appTextTheme.apply(
        bodyColor: ColorPalette.darkOnSurface,
        displayColor: ColorPalette.darkOnSurface,
      ),
      primaryTextTheme: TypographyUtils.appTextTheme.apply(
        bodyColor: ColorPalette.darkOnPrimary,
        displayColor: ColorPalette.darkOnPrimary,
      ),
      scaffoldBackgroundColor: ColorPalette.darkScaffoldBackground,
      appBarTheme: _darkAppBarTheme,
      bottomAppBarTheme: _darkBottomAppBarTheme,
      floatingActionButtonTheme: _darkFloatingActionButtonTheme,
      elevatedButtonTheme: _darkElevatedButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _darkTextButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      cardTheme: _darkCardTheme,
      chipTheme: _darkChipTheme,
      dividerTheme: _darkDividerTheme,
      dialogTheme: _darkDialogTheme,
      snackBarTheme: _darkSnackBarTheme,
      bottomSheetTheme: _darkBottomSheetTheme,
      tabBarTheme: _darkTabBarTheme,
      expansionTileTheme: _darkExpansionTileTheme,
    );
  }

 // Light color scheme
  static ColorScheme get _lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: ColorPalette.primary,
      brightness: Brightness.light,
    );
  }

  // Dark color scheme
  static ColorScheme get _darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: ColorPalette.primary,
      brightness: Brightness.dark,
    );
  }

  // App bar theme (light)
  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      backgroundColor: ColorPalette.primary,
      foregroundColor: ColorPalette.onPrimary,
      titleTextStyle: TypographyUtils.appBarTitleStyle,
      centerTitle: true,
      elevation: ThemeConstants.mediumElevation,
    );
  }

  // Bottom app bar theme (light)
  static BottomAppBarThemeData get _bottomAppBarTheme {
    return const BottomAppBarThemeData(
      color: ColorPalette.lightSurface,
      elevation: ThemeConstants.mediumElevation,
    );
  }

  // Floating action button theme (light)
  static FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.primary,
      foregroundColor: ColorPalette.onPrimary,
      elevation: ThemeConstants.highElevation,
      focusElevation: ThemeConstants.mediumElevation,
      hoverElevation: ThemeConstants.highElevation,
      disabledElevation: ThemeConstants.lowElevation,
    );
  }

  // Elevated button theme (light)
  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.onPrimary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.mediumBorderRadius),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.largeSpacing,
            vertical: ThemeConstants.mediumSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

  // Outlined button theme (light)
  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: ColorPalette.primary, width: 1.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.mediumBorderRadius),
            side: const BorderSide(color: ColorPalette.primary),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.largeSpacing,
            vertical: ThemeConstants.mediumSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

 // Text button theme (light)
  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.mediumSpacing,
            vertical: ThemeConstants.smallSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

  // Input decoration theme (light)
 static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.lightOutline),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.primary, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.error),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.error, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.mediumSpacing,
        vertical: ThemeConstants.largeSpacing,
      ),
      labelStyle: TypographyUtils.bodyMediumStyle,
      hintStyle: TypographyUtils.bodySmallStyle,
    );
 }

  // Card theme (light)
   static CardThemeData get _cardTheme {
     return CardThemeData(
       color: ColorPalette.lightSurface,
       surfaceTintColor: ColorPalette.lightSurface,
       elevation: ThemeConstants.mediumElevation,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
       ),
       margin: EdgeInsets.all(ThemeConstants.smallSpacing),
     );
   }

 // Chip theme (light)
  static ChipThemeData get _chipTheme {
    return const ChipThemeData(
      backgroundColor: ColorPalette.lightSurfaceVariant,
      deleteIconColor: ColorPalette.onSurfaceVariant,
      disabledColor: ColorPalette.lightSurfaceVariant,
      selectedColor: ColorPalette.primary,
      secondarySelectedColor: ColorPalette.secondary,
      checkmarkColor: ColorPalette.onPrimary,
      shadowColor: ColorPalette.shadow,
      surfaceTintColor: ColorPalette.lightSurface,
      labelStyle: TypographyUtils.labelSmallStyle,
      secondaryLabelStyle: TypographyUtils.labelMediumStyle,
      elevation: ThemeConstants.lowElevation,
      padding: EdgeInsets.all(ThemeConstants.smallSpacing),
      iconTheme: IconThemeData(size: ThemeConstants.smallFontSize),
    );
  }

  // Divider theme (light)
  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: ColorPalette.lightOutline,
      space: ThemeConstants.smallSpacing,
      thickness: 1.0,
      indent: ThemeConstants.mediumSpacing,
      endIndent: ThemeConstants.mediumSpacing,
    );
  }

  // Dialog theme (light)
 static DialogThemeData get _dialogTheme {
   return DialogThemeData(
     backgroundColor: ColorPalette.lightSurface,
     titleTextStyle: TypographyUtils.headlineSmallStyle,
     contentTextStyle: TypographyUtils.bodyMediumStyle,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.largeBorderRadius)),
     ),
     elevation: ThemeConstants.highElevation,
   );
 }

  // SnackBar theme (light)
  static SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: ColorPalette.primary,
      actionTextColor: ColorPalette.onPrimary,
      closeIconColor: ColorPalette.onPrimary,
      contentTextStyle: TypographyUtils.bodyMediumStyle.copyWith(
        color: ColorPalette.onPrimary,
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      elevation: ThemeConstants.mediumElevation,
    );
  }

 // Bottom sheet theme (light)
  static BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: ColorPalette.lightSurface,
      surfaceTintColor: ColorPalette.lightSurface,
      modalBackgroundColor: ColorPalette.lightSurface,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.largeBorderRadius),
          topRight: Radius.circular(ThemeConstants.largeBorderRadius),
        ),
      ),
      elevation: ThemeConstants.highElevation,
    );
  }

  // Tab bar theme (light)
  static TabBarThemeData get _tabBarTheme {
    return TabBarThemeData(
      labelColor: ColorPalette.onSurface,
      unselectedLabelColor: ColorPalette.lightOnSurfaceVariant,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorPalette.primary,
            width: 3.0,
          ),
        ),
      ),
      labelStyle: TypographyUtils.titleMediumStyle,
      unselectedLabelStyle: TypographyUtils.titleSmallStyle,
    );
  }

  // Expansion tile theme (light)
  static ExpansionTileThemeData get _expansionTileTheme {
    return const ExpansionTileThemeData(
      iconColor: ColorPalette.onSurface,
      collapsedIconColor: ColorPalette.onSurface,
      textColor: ColorPalette.onSurface,
      collapsedTextColor: ColorPalette.onSurface,
      tilePadding: EdgeInsets.symmetric(horizontal: ThemeConstants.mediumSpacing),
      childrenPadding: EdgeInsets.all(ThemeConstants.mediumSpacing),
      shape: RoundedRectangleBorder(),
      collapsedShape: RoundedRectangleBorder(),
    );
  }

  // Dark theme variants
  static AppBarTheme get _darkAppBarTheme {
    return const AppBarTheme(
      backgroundColor: ColorPalette.primary,
      foregroundColor: ColorPalette.onPrimary,
      titleTextStyle: TypographyUtils.appBarTitleStyle,
      centerTitle: true,
      elevation: ThemeConstants.mediumElevation,
    );
  }

  static BottomAppBarThemeData get _darkBottomAppBarTheme {
    return const BottomAppBarThemeData(
      color: ColorPalette.darkSurface,
      elevation: ThemeConstants.mediumElevation,
    );
  }

  static FloatingActionButtonThemeData get _darkFloatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.primary,
      foregroundColor: ColorPalette.onPrimary,
      elevation: ThemeConstants.highElevation,
      focusElevation: ThemeConstants.mediumElevation,
      hoverElevation: ThemeConstants.highElevation,
      disabledElevation: ThemeConstants.lowElevation,
    );
  }

  static ElevatedButtonThemeData get _darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.onPrimary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.mediumBorderRadius),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.largeSpacing,
            vertical: ThemeConstants.mediumSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

 static OutlinedButtonThemeData get _darkOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: ColorPalette.primary, width: 1.0),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.mediumBorderRadius),
            side: const BorderSide(color: ColorPalette.primary),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.largeSpacing,
            vertical: ThemeConstants.mediumSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

  static TextButtonThemeData get _darkTextButtonTheme {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(ColorPalette.primary),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: ThemeConstants.mediumSpacing,
            vertical: ThemeConstants.smallSpacing,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(TypographyUtils.buttonTextStyle),
      ),
    );
  }

  static InputDecorationTheme get _darkInputDecorationTheme {
    return InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.darkOutline),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.primary, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.error),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.error, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.mediumSpacing,
        vertical: ThemeConstants.largeSpacing,
      ),
      labelStyle: TypographyUtils.bodyMediumStyle,
      hintStyle: TypographyUtils.bodySmallStyle,
    );
  }

  static CardThemeData get _darkCardTheme {
    return CardThemeData(
      color: ColorPalette.darkSurface,
      surfaceTintColor: ColorPalette.darkSurface,
      elevation: ThemeConstants.mediumElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      margin: EdgeInsets.all(ThemeConstants.smallSpacing),
    );
  }

  static ChipThemeData get _darkChipTheme {
    return const ChipThemeData(
      backgroundColor: ColorPalette.darkSurfaceVariant,
      deleteIconColor: ColorPalette.onSurfaceVariant,
      disabledColor: ColorPalette.darkSurfaceVariant,
      selectedColor: ColorPalette.primary,
      secondarySelectedColor: ColorPalette.secondary,
      checkmarkColor: ColorPalette.onPrimary,
      shadowColor: ColorPalette.shadow,
      surfaceTintColor: ColorPalette.darkSurface,
      labelStyle: TypographyUtils.labelSmallStyle,
      secondaryLabelStyle: TypographyUtils.labelMediumStyle,
      elevation: ThemeConstants.lowElevation,
      padding: EdgeInsets.all(ThemeConstants.smallSpacing),
      iconTheme: IconThemeData(size: ThemeConstants.smallFontSize),
    );
 }

  static DividerThemeData get _darkDividerTheme {
    return const DividerThemeData(
      color: ColorPalette.darkOutline,
      space: ThemeConstants.smallSpacing,
      thickness: 1.0,
      indent: ThemeConstants.mediumSpacing,
      endIndent: ThemeConstants.mediumSpacing,
    );
  }

  static DialogThemeData get _darkDialogTheme {
    return DialogThemeData(
      backgroundColor: ColorPalette.darkSurface,
      titleTextStyle: TypographyUtils.headlineSmallStyle,
      contentTextStyle: TypographyUtils.bodyMediumStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.largeBorderRadius)),
      ),
      elevation: ThemeConstants.highElevation,
    );
  }

  static SnackBarThemeData get _darkSnackBarTheme {
    return SnackBarThemeData(
      backgroundColor: ColorPalette.primary,
      actionTextColor: ColorPalette.onPrimary,
      closeIconColor: ColorPalette.onPrimary,
      contentTextStyle: TypographyUtils.bodyMediumStyle.copyWith(
        color: ColorPalette.onPrimary,
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.mediumBorderRadius)),
      ),
      elevation: ThemeConstants.mediumElevation,
    );
  }

  static BottomSheetThemeData get _darkBottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: ColorPalette.darkSurface,
      surfaceTintColor: ColorPalette.darkSurface,
      modalBackgroundColor: ColorPalette.darkSurface,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.largeBorderRadius),
          topRight: Radius.circular(ThemeConstants.largeBorderRadius),
        ),
      ),
      elevation: ThemeConstants.highElevation,
    );
  }

 static TabBarThemeData get _darkTabBarTheme {
   return TabBarThemeData(
     labelColor: ColorPalette.onSurface,
     unselectedLabelColor: ColorPalette.darkOnSurfaceVariant,
     indicatorSize: TabBarIndicatorSize.tab,
     indicator: BoxDecoration(
       border: Border(
         bottom: BorderSide(
           color: ColorPalette.primary,
           width: 3.0,
         ),
       ),
     ),
     labelStyle: TypographyUtils.titleMediumStyle,
     unselectedLabelStyle: TypographyUtils.titleSmallStyle,
   );
 }

  static ExpansionTileThemeData get _darkExpansionTileTheme {
    return const ExpansionTileThemeData(
      iconColor: ColorPalette.onSurface,
      collapsedIconColor: ColorPalette.onSurface,
      textColor: ColorPalette.onSurface,
      collapsedTextColor: ColorPalette.onSurface,
      tilePadding: EdgeInsets.symmetric(horizontal: ThemeConstants.mediumSpacing),
      childrenPadding: EdgeInsets.all(ThemeConstants.mediumSpacing),
      shape: RoundedRectangleBorder(),
      collapsedShape: RoundedRectangleBorder(),
    );
  }
}