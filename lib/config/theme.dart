import 'package:flutter/material.dart';

const Color primaryColor = Colors.redAccent;

final ThemeData themeTravelPoint = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  fontFamily: 'RobotoFlex',
  appBarTheme: const AppBarTheme(color: primaryColor),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      unselectedItemColor: Colors.white38,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(size: 40),
      unselectedIconTheme: IconThemeData(size: 30),
      elevation: 5),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.black54, fontSize: 50),
  ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black12),
  inputDecorationTheme: InputDecorationTheme(
      isCollapsed: true,
      hintStyle: const TextStyle(color: Colors.black38),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(15.0)),
      labelStyle: const TextStyle(color: Colors.black54)),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(primaryColor),
        animationDuration: Duration(milliseconds: 700)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
    ),
  ),
);
