import 'package:attendease/components/students.dart';
import 'package:attendease/controllers/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// import 'package:rive/rive.dart';

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
      // backgroundColor: const Color(0xFF232946),
      // backgroundColor: const Color(0xFF4ECCA3),
      body:
          // Center(
          //   child: SingleChildScrollView(
          //     child: Theme(
          //       data: ThemeData(
          //         useMaterial3: true,
          //         inputDecorationTheme: const InputDecorationTheme(
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(12.0)),
          //             borderSide: BorderSide(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //       child: Form(
          //         key: _loginController.loginKey,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const Text(
          //               'Welcome Back!',
          //               style: TextStyle(
          //                 fontSize: 24.0,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             const SizedBox(height: 30.0),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 32.0),
          //               child: TextFormField(
          //                 controller: _loginController.email,
          //                 keyboardType: TextInputType.emailAddress,
          //                 style: const TextStyle(color: Colors.white),
          //                 decoration: const InputDecoration(
          //                   hintText: 'Email',
          //                   hintStyle: TextStyle(color: Colors.grey),
          //                 ),
          //                 validator: (value) {
          //                   if (value!.isEmpty ||
          //                       !RegExp(r'^[a-zA-Z0-9.]+@spit.ac.in$')
          //                           .hasMatch(value)) {
          //                     return 'Domain should be spit.ac.in';
          //                   } else {
          //                     return null;
          //                   }
          //                 },
          //                 textInputAction: TextInputAction.next,
          //                 onTapOutside: (event) {
          //                   FocusScope.of(context).unfocus();
          //                 },
          //               ),
          //             ),
          //             const SizedBox(height: 20.0),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 32.0),
          //               child: TextFormField(
          //                 controller: _loginController.password,
          //                 enableSuggestions: false,
          //                 style: const TextStyle(color: Colors.white),
          //                 obscureText: true,
          //                 decoration: const InputDecoration(
          //                   hintText: 'Password',
          //                   hintStyle: TextStyle(color: Colors.grey),
          //                 ),
          //                 validator: (value) {
          //                   if (value!.isEmpty || value.length < 6) {
          //                     return 'Password cannot be less than 6 characters';
          //                   } else {
          //                     return null;
          //                   }
          //                 },
          //                 onFieldSubmitted: (value) => _loginController.login(),
          //                 textInputAction: TextInputAction.done,
          //                 // onChanged: (value) => password = value,
          //               ),
          //             ),
          //             const SizedBox(height: 30.0),
          //             Obx(() {
          //               return AnimatedSwitcher(
          //                 duration: const Duration(milliseconds: 200),
          //                 child: (!_loginController.isLoading.value)
          //                     ? ElevatedButton(
          //                         onPressed: () async {
          //                           _loginController.login();
          //                           // if (_loginController.loginKey.currentState!.validate()) {
          //                           //   isLoading.value = true;
          //                           //   bool status = await login(email, password);
          //                           //   if (status) {
          //                           //     check.fire();
          //                           //     Get.closeAllSnackbars();
          //                           //     Get.snackbar(
          //                           //       'Success',
          //                           //       'Logged In Successfully',
          //                           //       snackPosition: SnackPosition.TOP,
          //                           //       backgroundColor:
          //                           //           Colors.green.withOpacity(0.2),
          //                           //       colorText: Colors.white,
          //                           //     );
          //                           //     await Future.delayed(
          //                           //       const Duration(seconds: 2),
          //                           //     );
          //                           //     Get.offAll(
          //                           //       () => const Main(),
          //                           //       transition: Transition.fadeIn,
          //                           //     );
          //                           //   } else {
          //                           //     error.fire();
          //                           //     Get.closeAllSnackbars();
          //                           //     Get.snackbar(
          //                           //       'Error',
          //                           //       'Invalid Credentials',
          //                           //       snackPosition: SnackPosition.TOP,
          //                           //       backgroundColor:
          //                           //           Colors.red.withOpacity(0.2),
          //                           //       colorText: Colors.white,
          //                           //     );
          //                           //   }
          //                           //   await Future.delayed(
          //                           //     const Duration(seconds: 2),
          //                           //   );
          //                           //   isLoading.value = false;
          //                           // }
          //                         },
          //                         style: ElevatedButton.styleFrom(
          //                           backgroundColor: const Color(0xFF4ECCA3),
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 80.0, vertical: 16.0),
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(30.0),
          //                           ),
          //                         ),
          //                         child: const Text('Log In'),
          //                       )
          //                     : SizedBox(
          //                         height: 100,
          //                         width: 100,
          //                         child: RiveAnimation.asset(
          //                           'assets/check.riv',
          //                           stateMachines: const ['State Machine 1'],
          //                           controllers: [
          //                             _loginController.animationController
          //                                 as RiveAnimationController
          //                           ],
          //                         ),
          //                       ),
          //               );
          //             }),
          //             const SizedBox(height: 20.0),
          //             TextButton(
          //               onPressed: () {},
          //               child: const Text(
          //                 'Forgot Password?',
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                // Colors.purpleAccent,
                // Colors.amber,
                // Colors.blue,
                Color(0xFF196CE9),
                Color(0xFFF6F9EF)
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 200,
                // width: 300,
                child: LottieBuilder.asset("assets/login2.json"),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                // height: 470,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Form(
                  key: _loginController.loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black.withOpacity(0.6)
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Please Login to Your Account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _loginController.email,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-zA-Z0-9._-]+@spit.ac.in$')
                                    .hasMatch(value)) {
                              return 'Domain should be spit.ac.in';
                            } else {
                              return null;
                            }
                          },
                          // style: TextStyle(color: Colors.black.withOpacity(0.7)),
                          decoration: const InputDecoration(
                              suffix: Icon(
                                Icons.email_outlined,
                                color: Colors.red,
                              ),
                              labelText: "Email Address",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: Obx(() {
                          // print(_loginController.obscureText.value);
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return "Password should be more than 6 characters";
                              } else {
                                return null;
                              }
                            },
                            obscureText: _loginController.obscureText.value,
                            controller: _loginController.password,
                            // style: TextStyle(color: Colors.black.withOpacity(0.7)),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) =>
                                _loginController.login(),
                            decoration: InputDecoration(
                              suffix: InkWell(
                                child: _loginController.obscureText.value
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                        color: Colors.red,
                                      ),
                                onTap: () {
                                  _loginController.obscure();
                                },
                                // color: Colors.red,
                              ),
                              labelText: "Password",
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Obx(() {
                          return (!_loginController.isLoading.value)
                              ? GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.black87.withOpacity(0.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.grey,
                                        )),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            // color: Colors.white,
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    _loginController.login();
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator());
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
