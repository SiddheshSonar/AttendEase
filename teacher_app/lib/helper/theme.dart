import 'package:flutter/material.dart';

final ThemeData dark = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black54,
  ),
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black54,
);

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white
);
