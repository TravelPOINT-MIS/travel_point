import 'package:flutter/material.dart';

const Color primaryColor = Colors.redAccent;

final ThemeData themeTravelPoint = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
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
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: primaryColor,
    ),
  ),
);
