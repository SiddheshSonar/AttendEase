import 'dart:convert';

// import 'package:attendease/main.dart';
import 'package:attendease/views/home.dart';
import 'package:attendease/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../components/students.dart';
import '../helper/theme.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    isLogin = box.read('isLogin') ?? false;
    if (isLogin) {
      final userData = box.read('user');
      user = Student.fromJson(jsonDecode(userData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      title: 'AttendEase',
      themeMode: ThemeMode.system,
      theme: light,
      darkTheme: dark,
      home: (isLogin) ? const Main() : const Login(),
    );
  }
}
