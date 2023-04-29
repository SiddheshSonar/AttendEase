import 'dart:convert';
import 'package:attendease_t/main.dart';
import 'package:attendease_t/models/login_model.dart';
import 'package:attendease_t/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:rive/rive.dart';
import '../components/students.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final loginKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  //rive
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late StateMachineController? animationController;

  //rive

  @override
  void onInit() async {
    final bytes = await rootBundle.load('assets/check.riv');
    final file = RiveFile.import(bytes);
    final artboard = file.mainArtboard;
    animationController =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    check = animationController?.findSMI('Check') as SMITrigger;
    error = animationController?.findSMI('Error') as SMITrigger;
    reset = animationController?.findSMI('Reset') as SMITrigger;
    super.onInit();
  }

  void login() async {
    isLoading.value = true;
    if (!loginKey.currentState!.validate()) {
      isLoading.value = false;
      return;
    }
    try {
      RecordAuth authData =
          await LoginModel.getCredentials(email.text, password.text);
      Map authMap = authData.toJson();
      authMap = authMap['record'];
      user = Teacher(name: authMap["name"], id: authMap["id"]);
      final box = GetStorage();
      box.write('isLogin', true);
      box.write(
        'user',
        jsonEncode(user),
      );
      check.fire();
      Get.closeAllSnackbars();
      Get.snackbar(
        'Success',
        'Logged In Successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.2),
        colorText: Colors.white,
      );

      await Future.delayed(
        const Duration(seconds: 2),
      );
      Get.offAll(() => const Main(), transition: Transition.fadeIn);
    } on ClientException catch (e) {
      error.fire();
      Get.closeAllSnackbars();
      Get.snackbar(
        (e.statusCode == 0) ? 'Connection Error' : 'Incorrect Credentials',
        (e.statusCode == 0)
            ? 'Please check you Internet Connection'
            : 'Please check your credentials',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.white,
      );
    } finally {
      await Future.delayed(
        const Duration(seconds: 2),
      );
      isLoading.value = false;
    }
  }
}
