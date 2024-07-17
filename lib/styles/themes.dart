import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_app/styles/fonts.dart';

ThemeData themes = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(54, 186, 152, 1),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: const Color.fromRGBO(54, 186, 152, 1),
    titleTextStyle: AppFonts.titles.copyWith(
      fontSize: 20,
      color: Colors.black,
    ),
    actionsIconTheme: const IconThemeData(color: Colors.black, size: 30),
    systemOverlayStyle: const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey.shade200,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.white,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: AppFonts.titles.copyWith(fontSize: 20),
    contentTextStyle: AppFonts.titles,
    backgroundColor: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        AppFonts.titles,
      ),
    ),
  ),
);
