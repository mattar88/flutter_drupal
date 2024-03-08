import 'package:flutter/material.dart';

//Reference: https://m2.material.io/design/color/the-color-system.html

abstract class AppColors {
  ///primarySwatch It is MaterialColor. That’s why it will contain color shades from 50 to 900.
  ///PrimarySwatch is used to configure default values for several fields
  ///including primaryColor, primaryColorBrightness, primaryColorLight, primaryColorDark,
  ///toggableActiveColor, accentColor, colorScheme, secondaryHeaderColor,
  ///textSelectionColor,backgroundColor and buttonColor
  static const MaterialColor primarySwatch = Colors.blue;

  ///A primary color is the color displayed most frequently across your app's screens and components
  static const Color primary = Color(0xFF2494db);
  //Primary Variant used to accent the(elments text, icon) in component used with primary
  // for typography and iconography. Additionally
  static const Color primaryVariant = Colors.blue;

  ///secondary color applied sparingly to accent select parts of your UI.
  ///Floating action buttons
  ///Selection controls, like sliders and switches
  ///Highlighting selected text
  ///Progress bars
  ///Links and headlines
  static const Color secondary = primarySwatch;
  static const Color secondaryVariant = Color(0xFF9ea0a1);

  static const Color background = Colors.white;
  static const Color statusBarColor = primarySwatch;
  static const Color appBarTextColor = Colors.white;
  static const Color appBarColor = primarySwatch;
  static const Color appBarTitleColor = appBarTextColor;
  static const Color appBarIconColor = appBarTextColor;

  static const Color sideBarMenu = primarySwatch;
  static const Color sideBarMenuTextColor = textColorPrimary;

  static const Color centerTextColor = Colors.grey;
  static const Color white = Colors.white;

  static const Color success = Color(0xFF73b355);
  static const Color warning = Color(0xFFe29700);
  static const Color error = Color(0xFFe34f4f);

  static const Color buttonTextColor = primary;
  static const Color buttonBgColor = primary;

  static const Color textColorPrimary = Colors.black;
  static const Color textColorSecondary = Color.fromARGB(255, 63, 63, 63);
  static const Color textColorTag = primary;
  static const Color textColorGreyLight = Color(0xFFABABAB);
  static const Color textColorGreyDark = Color(0xFF979797);
  static const Color textColorBlueGreyDark = Color(0xFF939699);
  static const Color textColorCyan = Color(0xFF38686A);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  static Color searchFieldTextColor = const Color(0xFF323232).withOpacity(0.5);

  static const Color iconColorDefault = Colors.grey;

  static Color barrierColor = const Color(0xFF000000).withOpacity(0.5);

  static Color timelineDividerColor = const Color(0x5438686A);

  static const Color gradientStartColor = Colors.black87;
  static const Color gradientEndColor = Colors.transparent;
  static const Color silverAppBarOverlayColor = Color(0x80323232);

  static const Color switchActiveColor = primary;
  static const Color switchInactiveColor = Color(0xFFABABAB);
  static Color elevatedContainerColorOpacity = Colors.grey.withOpacity(0.5);
  static const Color suffixImageColor = Colors.grey;
}
