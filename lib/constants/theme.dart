import 'package:flutter/material.dart';
import 'package:wise_verbs/constants/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: appFont,
  primaryColor: darkPrimaryColor,
  highlightColor: Colors.white,
  cardColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(),
  switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.cyan),
      trackColor: MaterialStateProperty.all(Colors.grey)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: const Color(0xFF005A9C),
    unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
    showUnselectedLabels: false,
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.white),
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white)),
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(style: ButtonStyle()),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: darkPrimaryColor,
    secondary: darkSecondaryColor,
    background: Colors.black,
    tertiary: Colors.grey.shade900,
  ).copyWith(background: Colors.black),
);

ThemeData darkThemeData() {
  return ThemeData(
    fontFamily: appFont,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme.copyWith(backgroundColor: kContentColorLightTheme),
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w300,
        fontSize: 96.0,
      ),
      // Regular
      displayMedium: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w400,
        fontSize: 60.0,
      ),
      // Medium
      displaySmall: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w500,
        fontSize: 48.0,
      ),
      // Bold
      headlineMedium: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w700,
        fontSize: 34.0,
      ),
      // Extra Bold
      headlineSmall: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w800,
        fontSize: 24.0,
      ),
      // Black
      titleLarge: TextStyle(
        fontFamily: appFont,
        fontWeight: FontWeight.w900,
        fontSize: 20.0,
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.cyan),
      checkColor: MaterialStateProperty.all(Colors.white),

    )
  );
}

const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
