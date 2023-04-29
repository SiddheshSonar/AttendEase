import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:attendease/helper/permission.dart';
import 'package:attendease/pages/landing.dart';
import 'package:attendease/views/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
//ios beacon
import 'package:beacon_broadcast/beacon_broadcast.dart' as i_beacon;
//android beacon
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:rive/rive.dart';

//TODO: Fetch from db
String classRoom = '409';

//fetch from db

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkBluetoothPerms();
  await GetStorage.init();
  FlutterNativeSplash.remove();
  runApp(const Landing());
}

// class Main extends StatefulWidget {
//   const Main({super.key});

//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   final RxBool _isFetching = true.obs;
//   @override
//   void initState() {
//     PbDb.pb
//         .collection("students")
//         .getOne(user.id, expand: "courses(students).courses")
//         .then((value) {
//       // user = Student.fromJson(value.toJson());
//       // print(value);
//       // print(value.expand);
//       // print(value.data);
//       // print(value.data["attendance"]);
//       // print("test");
//       attendance = value.data["attendance"];
//       PbDb.pb.collection("courses").getFullList().then((value) {
//         // print(value);
//         for (RecordModel element in value) {
//           if (element.data["students_enrolled"].contains(user.id)) {
//             // print(element.data["course_name"]);
//             // print(element.data["lectures"]);
//             courses[element.data["course_name"]] = element.data["lectures"];
//           }
//         }
//         // print("courses: $courses");

//         int i = 0;
//         items.clear();
//         courses.forEach((key, value) {
//           // print("key: $key, value: $value, attendance: ${attendance[key]}");
//           // barData.add(BarData(name: key, y1: (attendance[key] != null) ? attendance[key].length : 0, y2: courses[key]));
//           items.add(makeGroupData(
//               i++,
//               (attendance[key] != null) ? attendance[key].length : 0,
//               courses[key]));
//         });
//         //rawBarGroups = items;
//         showingBarGroups = items;
//         _isFetching.value = false;
//       });
//     });
//     PbDb.pb.collection("students").subscribe(user.id, (e) {
//       if (e.action == "update") {
//         // _isFetching.value = true;
//         attendance = e.record?.data["attendance"];
//         if (!Get.isOverlaysClosed) {
//           Get.back(closeOverlays: true);
//         }
//         int i = 0;
//         items.clear();
//         courses.forEach((key, value) {
//           // print("key: $key, value: $value, attendance: ${attendance[key]}");
//           // barData.add(BarData(name: key, y1: (attendance[key] != null) ? attendance[key].length : 0, y2: courses[key]));
//           items.add(makeGroupData(
//               i++,
//               (attendance[key] != null) ? attendance[key].length : 0,
//               courses[key]));
//         });
//         //rawBarGroups = items;
//         showingBarGroups = items;
//         graphKey.currentState?.update();
//         // Future.delayed(const Duration(milliseconds: 500), () {
//         //   _isFetching.value = false;
//         // });
//         // _isFetching.value = false;
//       }
//     });
//     PbDb.pb.collection("courses").subscribe("*", (e) {
//       if (e.action == "update") {
//         e.record?.data["students_enrolled"].forEach((element) {
//           if (element == user.id) {
//             courses[e.record?.data["course_name"]] = e.record?.data["lectures"];
//           }
//         });
//         // print("courses: $courses");
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 90,
//         flexibleSpace: SafeArea(
//           minimum: const EdgeInsets.symmetric(horizontal: 12),
//           child: Theme(
//             data: ThemeData(
//               iconTheme: const IconThemeData(size: 40, color: Colors.blueGrey),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(32),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const CircleAvatar(
//                         radius: 32,
//                         backgroundColor: Colors.black54,
//                         child: Text(
//                           'S',
//                           style: TextStyle(fontSize: 40),
//                         )),
//                     IconButton(
//                         splashRadius: 32,
//                         onPressed: () {},
//                         icon: const Icon(Icons.search)),
//                     IconButton(
//                         splashRadius: 32,
//                         onPressed: () {},
//                         icon: const Icon(Icons.notifications_active_outlined)),
//                     IconButton(
//                       splashRadius: 32,
//                       icon: const Icon(Icons.logout_rounded),
//                       onPressed: () {
//                         PbDb.pb.authStore.clear();
//                         final box = GetStorage();
//                         box.erase();
//                         Navigator.pushAndRemoveUntil(context,
//                             MaterialPageRoute(builder: (context) {
//                           return const Login();
//                         }), (r) => false);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Hi!, ${user.name}',
//                 style: const TextStyle(fontSize: 32),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 'UID: ${user.uid}',
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 'Division: ${user.subdivision}',
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   attendValidate();
//                 },
//                 child: const Text('Submit Attendance'),
//               ),
//               SizedBox(
//                 height: 300,
//                 child: Obx(() {
//                   return (!_isFetching.value)
//                       ? AtGraph(key: graphKey)
//                       : const Center(child: CircularProgressIndicator());
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // ),
//     );
//   }

//   Future<dynamic> attendValidate() async {
//     return Get.bottomSheet(const SubmitAttendance(),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         isDismissible: false,
//         enableDrag: false,
//         elevation: 0.0);
//   }
// }

late SMITrigger submitCheck;
late SMITrigger submitError;
late SMITrigger submitReset;

class SubmitAttendance extends StatefulWidget {
  const SubmitAttendance({
    super.key,
  });

  @override
  State<SubmitAttendance> createState() => _SubmitAttendanceState();
}

class _SubmitAttendanceState extends State<SubmitAttendance> {
  RxBool status = false.obs;
  RxBool attendance = false.obs;
  // i_beacon.BeaconBroadcast beaconBroadcast = i_beacon.BeaconBroadcast();
  late i_beacon.BeaconBroadcast beaconBroadcast;
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      beaconBroadcast = i_beacon.BeaconBroadcast();
      beaconBroadcast.isAdvertising().then((value) {
        status.value = value as bool;
      });
    } else if (Platform.isAndroid) {
      // flutterBeacon.isBroadcasting().then((value) {

      //   flutterBeacon.stopBroadcast();
      //   status.value = false;
      // });
      flutterBeacon.stopBroadcast();
      // beaconBroadcast.isAdvertising().then((value) {
      //   status.value = value as bool;
      // });
    }
    // print('status: $status');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!status.value) {
        attend();
      }
      Future.delayed(const Duration(seconds: 5), () {
        attendance.value = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (GetPlatform.isIOS) {
      beaconBroadcast.stop();
    } else if (GetPlatform.isAndroid) {
      flutterBeacon.stopBroadcast();
    }
  }

  Future<void> attend() async {
    // i_beacon.BeaconBroadcast beaconBroadcast = i_beacon.BeaconBroadcast();
    if (GetPlatform.isIOS) {
      beaconBroadcast
          .setUUID("00000000-0000-0000-0000-00${user.uid}") //3digits
          .setIdentifier('spit$classRoom')
          .setMajorId(0)
          .setMinorId(0)
          .start();
      status.value = await beaconBroadcast.isAdvertising() as bool;
    } else if (GetPlatform.isAndroid) {
      // print("user uid: ${user.uid}");
      flutterBeacon.startBroadcast(BeaconBroadcast(
          proximityUUID: '00000000-0000-0000-0000-00${user.uid}',
          major: 0,
          minor: 0,
          identifier: 'spit$classRoom'));
      status.value = await flutterBeacon.isBroadcasting();
      //TODO: check if we can achieve the same result with beaconBroadcast, if yes then remove the flutterBeacon package
      // beaconBroadcast
      //     .setUUID("00000000-0000-0000-0000-00${user.uid}") //3digits
      //     .setIdentifier('spit$classRoom')
      //     .setMajorId(0)
      //     .setMinorId(0)
      //     .setLayout(
      //         'm:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24') //Apple iBeacon layout
      //     .setManufacturerId(0x004c) //Apple for android test
      //     .start();
      // status.value = await beaconBroadcast.isAdvertising() as bool;
    }
  }

  bool isShowLoading = false;
  bool isShowConfetti = false;

  // late SMITrigger submitCheck;
  // late SMITrigger submitError;
  // late SMITrigger submitReset;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              // height: 300,
              // width: 300,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            // color: Colors.red,
                            // size: 40,
                          )),
                    ],
                  ),
                  // const Text('Submitting Attendance'),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Submitting Attendance',
                        textStyle: const TextStyle(
                            fontSize: 28.0, fontStyle: FontStyle.italic),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    isRepeatingAnimation: false,
                    repeatForever: false,
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: RiveAnimation.asset(
                      'assets/check.riv',
                      onInit: (artboard) {
                        StateMachineController? controller =
                            StateMachineController.fromArtboard(
                                artboard, "State Machine 1");
                        artboard.addController(controller!);
                        submitCheck = controller.findSMI("Check") as SMITrigger;
                        submitError = controller.findSMI("Error") as SMITrigger;
                        submitReset = controller.findSMI("Reset") as SMITrigger;
                      },
                      // animations: ['bounce'],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () async {
                  //         if (Platform.isAndroid) {
                  //           status.value = await flutterBeacon.isBroadcasting();
                  //         } else {
                  //           status.value = await i_beacon.BeaconBroadcast()
                  //               .isAdvertising() as bool;
                  //         }
                  //         check.fire();

                  //         //print(status.value);

                  //         // _isPlaying ? null : _controller.isActive = true;
                  //       },
                  //       child: const Text('check'),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () async {
                  //         // if (Platform.isAndroid) {
                  //         //   status.value = await flutterBeacon.isBroadcasting();
                  //         // } else {
                  //         //   status.value = await i_beacon.BeaconBroadcast()
                  //         //       .isAdvertising() as bool;
                  //         // }
                  //         error.fire();

                  //         //print(status.value);

                  //         // _isPlaying ? null : _controller.isActive = true;
                  //       },
                  //       child: const Text('error'),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () async {
                  //         // if (Platform.isAndroid) {
                  //         //   status.value = await flutterBeacon.isBroadcasting();
                  //         // } else {
                  //         //   status.value = await i_beacon.BeaconBroadcast()
                  //         //       .isAdvertising() as bool;
                  //         // }
                  //         reset.fire();

                  //         //print(status.value);

                  //         // _isPlaying ? null : _controller.isActive = true;
                  //       },
                  //       child: const Text('reset'),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//classes and objects
//abstract and super class
//exception handling
//polymorphism
