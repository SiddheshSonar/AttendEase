import 'dart:ui';

import 'package:attendease/components/attendance_graph.dart';
import 'package:attendease/components/scanner.dart';
import 'package:attendease/controllers/home_controller.dart';
import 'package:attendease/database/db.dart';
import 'package:attendease/main.dart';
import 'package:attendease/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

//move to controller
// Map attendance = {};
// Map courses = {};
//move to controller

// GlobalKey<AtGraphState> graphKey = GlobalKey<AtGraphState>();

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  //final RxBool _isFetching = true.obs;
  final HomeController _homeController = Get.put(HomeController());

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  // List<Widget> _home = [
  //   // HomePage(homeController: _homeController),

  // ];
  final Duration pageAnimationDuration = const Duration(milliseconds: 300);
  final Curve pageAnimationCurve = Curves.easeInOut;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 12),
          child: Theme(
            data: ThemeData(
              iconTheme: const IconThemeData(size: 40, color: Colors.blueGrey),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.black54,
                            child: Text(
                              // 'S',
                              // '${PbDb.pb.authStore.user!.name![0]}',
                              user.name[0],
                              style: const TextStyle(fontSize: 40),
                            )),
                        onTap: () {
                          _homeController.homePageController.animateToPage(0,
                              duration: pageAnimationDuration,
                              curve: pageAnimationCurve);
                        }),
                    IconButton(
                        splashRadius: 32,
                        onPressed: () {
                          _homeController.homePageController.animateToPage(1,
                              duration: pageAnimationDuration,
                              curve: pageAnimationCurve);
                        },
                        icon: const Icon(Icons.calendar_view_day_rounded)),
                    IconButton(
                        splashRadius: 32,
                        // iconSize: 50,
                        onPressed: () {
                          _homeController.homePageController.animateToPage(2,
                              duration: pageAnimationDuration,
                              curve: pageAnimationCurve);
                        },
                        icon: const Icon(Icons.notes_rounded)),
                    IconButton(
                      splashRadius: 32,
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () {
                        // show a dialog to confirm logout
                        showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: AlertDialog(
                                  backgroundColor: Colors.cyan.withOpacity(0.1),
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                      'Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          // logout
                                          PbDb.pb.authStore.clear();
                                          final box = GetStorage();
                                          box.erase();
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const Login();
                                          }), (r) => false);
                                        },
                                        child: const Text('Logout')),
                                  ],
                                ),
                              );
                            });
                        // PbDb.pb.authStore.clear();
                        // final box = GetStorage();
                        // box.erase();
                        // Navigator.pushAndRemoveUntil(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return const Login();
                        // }), (r) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(

      //   onPressed: () => attendValidate(),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(32),
      //   ),
      //   tooltip: "Submit Attendance",
      //   backgroundColor: Colors.blueGrey.withOpacity(0.3),
      //   child: const Icon(
      //     Icons.fingerprint,
      //     size: 36,
      //   ),
      // ),
      floatingActionButton: SpeedDial(
        // implement above feature along with an extra button with qr as icon
        backgroundColor: Colors.blueGrey.withOpacity(0.3),
        overlayColor: Colors.black.withOpacity(0.5),
        overlayOpacity: 0.5,
        curve: Curves.easeInOut,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.qr_code),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              backgroundColor: Colors.blueGrey.withOpacity(0.3),
              label: 'Scan QR',
              onTap: () {
                // scan qr
                // _homeController.scanQR();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ScanQR();
                }));
              }),
          SpeedDialChild(
              child: const Icon(Icons.fingerprint),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              backgroundColor: Colors.blueGrey.withOpacity(0.3),
              label: 'Submit Attendance',
              onTap: () {
                // submit attendance
                attendValidate();
              }),
        ],
        // implement above feature along with an extra button with qr as icon
        child: const Icon(Icons.bolt),
      ),

      // body: HomePage(homeController: _homeController),
      body: PageView(
        controller: _homeController.homePageController,
        children: _homeController.home,
      ),
      // ),
    );
  }

  Future<bool> _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    // bool canCheckBiometrics = false;
    // try {
    //   canCheckBiometrics = await auth.canCheckBiometrics;
    // } catch (e) {
    //   // print("error biome trics $e");
    // }

    // print("biometric is available: $canCheckBiometrics");

    // List<BiometricType> availableBiometrics = [];
    // try {
    //   availableBiometrics = await auth.getAvailableBiometrics();
    // } catch (e) {
    //   // print("error enumerate biometrics $e");
    // }

    // print("following biometrics are available");
    // if (availableBiometrics.isNotEmpty) {
    //   for (var ab in availableBiometrics) {
    //     // print("\ttech: $ab");
    //   }
    // } else {
    //   // print("no biometrics are available");
    // }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          )
          // useErrorDialogs: true,
          // stickyAuth: false,
          // androidAuthStrings:
          //     AndroidAuthMessages(signInTitle: "Login to HomePage")

          );
      // authenticated = true;
      // return true;
    } catch (e) {
      // print("error using biometric auth: $e");
    }
    // setState(() {
    //   isAuth = authenticated ? true : false;
    // });

    // print("authenticated: $authenticated");
    return authenticated;
  }

  Future<dynamic> attendValidate() async {
    bool isAuth = await _checkBiometric();
    // print("isAuth: $isAuth");
    if (isAuth) {
      return Get.bottomSheet(const SubmitAttendance(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          barrierColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          enableDrag: false,
          elevation: 0.0);
    } else {
      Get.closeAllSnackbars();
      return Get.snackbar('Error', 'Authentication Failed',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi!, ${user.name}',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 5),
          Text(
            'UID: ${user.uid}',
          ),
          const SizedBox(height: 5),
          Text(
            'Division: ${user.subdivision}',
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     attendValidate();
          //   },
          //   child: const Text('Submit Attendance'),
          // ),
          SizedBox(
            height: 350,
            child: Obx(() {
              return (!_homeController.isFetching.value)
                  ? AtGraph(
                      key: _homeController.graphKey,
                      items: _homeController.items,
                      showingBarGroups: _homeController.showingBarGroups,
                      courses: _homeController.courses,
                      percentages: _homeController.percentages,
                    )
                  : const Center(child: CircularProgressIndicator());
            }),
          ),
        ],
      ),
    );
  }
}
