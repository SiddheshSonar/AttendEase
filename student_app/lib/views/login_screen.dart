import 'package:attendease/components/students.dart';
import 'package:attendease/controllers/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rive/rive.dart';

late Student user;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _loginController = Get.put(LoginController());

  @override
  void dispose() {
    super.dispose();
    _loginController.loginKey.currentState?.dispose();
    Get.delete<LoginController>();
  }

  @override
  Widget build(BuildContext context) {
    //create a minimal login page
    return Scaffold(
      backgroundColor: const Color(0xFF232946),
      body: Center(
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            child: Form(
              key: _loginController.loginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextFormField(
                      controller: _loginController.email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-zA-Z0-9.]+@spit.ac.in$')
                                .hasMatch(value)) {
                          return 'Domain should be spit.ac.in';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextFormField(
                      controller: _loginController.password,
                      enableSuggestions: false,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password cannot be less than 6 characters';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) => _loginController.login(),
                      textInputAction: TextInputAction.done,
                      // onChanged: (value) => password = value,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Obx(() {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: (!_loginController.isLoading.value)
                          ? ElevatedButton(
                              onPressed: () async {
                                _loginController.login();
                                // if (_loginController.loginKey.currentState!.validate()) {
                                //   isLoading.value = true;
                                //   bool status = await login(email, password);
                                //   if (status) {
                                //     check.fire();
                                //     Get.closeAllSnackbars();
                                //     Get.snackbar(
                                //       'Success',
                                //       'Logged In Successfully',
                                //       snackPosition: SnackPosition.TOP,
                                //       backgroundColor:
                                //           Colors.green.withOpacity(0.2),
                                //       colorText: Colors.white,
                                //     );
                                //     await Future.delayed(
                                //       const Duration(seconds: 2),
                                //     );
                                //     Get.offAll(
                                //       () => const Main(),
                                //       transition: Transition.fadeIn,
                                //     );
                                //   } else {
                                //     error.fire();
                                //     Get.closeAllSnackbars();
                                //     Get.snackbar(
                                //       'Error',
                                //       'Invalid Credentials',
                                //       snackPosition: SnackPosition.TOP,
                                //       backgroundColor:
                                //           Colors.red.withOpacity(0.2),
                                //       colorText: Colors.white,
                                //     );
                                //   }
                                //   await Future.delayed(
                                //     const Duration(seconds: 2),
                                //   );
                                //   isLoading.value = false;
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4ECCA3),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0, vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text('Log In'),
                            )
                          : SizedBox(
                              height: 100,
                              width: 100,
                              child: RiveAnimation.asset(
                                'assets/check.riv',
                                stateMachines: const ['State Machine 1'],
                                controllers: [
                                  _loginController.animationController
                                      as RiveAnimationController
                                ],
                              ),
                            ),
                    );
                  }),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
