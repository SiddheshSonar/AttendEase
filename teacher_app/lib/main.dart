import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:attendease_t/database/db.dart';
import 'package:attendease_t/helper/permission.dart';
import 'package:attendease_t/pages/landing.dart';
import 'package:attendease_t/views/attendance.dart';
import 'package:attendease_t/views/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
//ios beacon
import 'dart:async';
// import 'dart:io' show Platform;
// import 'package:flutter/services.dart';
// import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:pocketbase/pocketbase.dart';
//android beacon
// import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:rive/rive.dart';

//global vars

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

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<RecordModel> teachingCourses = [];
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    //first fetch available classes for teacher
    // print('init');
    // print(user.id);
    PbDb.pb
        .collection("courses")
        .getFullList(
            filter: 'teachers_enrolled = "${user.id}"',
            expand: 'students_enrolled',
            sort: "created"
            // expand: "students(students_enrolled)"
            // query: {'expand': 'students_enrolled'}
            //query doesn't work (is it a proper sqlite query?)
            //     query: {
            //   "course_nam": "DAA",
            //   "teachers_enrolled": user.id.toString(),
            // },
            )
        .then((value) {
      // print(value);
      teachingCourses = value;
      _isLoading.value = false;
      // print(teachingCourses[0].expand['students_enrolled']!.length);
      // print(teachingCourses[0].expand['students_enrolled']?[0].data['name']);
      // print(teachingCourses[0].expand['students_enrolled']?[1].data['name']);

      // for (var element in value) {
      //   // print(element.expand['students_enrolled']);
      //   for (var element in element.expand['students_enrolled']!) {
      //     // print(element.data['name']);
      //   }
      //   // print(element);
      // }
      // print(teachingCourses[0].data['course_name']);
      // value.forEach((element) {
      //   Map data = element.data;
      //   print(data);
      // });
    });

    //display in card format
    //on tap, fetch students in that class
    //add their uuids to region list to monitor
  }

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
            child: const CustomAppBar(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Hi!, ${user.name}',
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 5),
            // Text(
            //   'UID: ${user.id}',
            //   // style: const TextStyle(fontSize: 24),
            // ),
            Obx(() {
              return (!_isLoading.value)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Courses:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w200),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: teachingCourses.length,
                            itemBuilder: (context, index1) {
                              return customCard(
                                  teachingCourses[index1], context);
                              // List<RecordModel> studentsEnrolled =
                              //     teachingCourses[index1]
                              //             .expand["students_enrolled"]
                              //         as List<RecordModel>;
                              // print(studentsEnrolled.length);
                              // return OpenContainer(
                              //   closedBuilder: (BuildContext _,
                              //       VoidCallback openContainer) {
                              //     return customCard(
                              //         teachingCourses[index1], openContainer);
                              //   },
                              //   openBuilder: (BuildContext _,
                              //       VoidCallback openContainer) {
                              //     // print(
                              //     //     "indexfix: ${teachingCourses[index1].expand['students_enrolled']!.length}");
                              //     return Dialog(
                              //       child: SizedBox(
                              //         // height: 500,
                              //         width: 500,
                              //         child: Column(
                              //           children: [
                              //             const Text(
                              //               "Students",
                              //               style: TextStyle(fontSize: 32),
                              //             ),
                              //             Expanded(
                              //               child: ListView.builder(
                              //                 //teachingCourses[index1].expand['students_enrolled']?[index2].data['name']
                              //                 itemCount:
                              //                     studentsEnrolled.length,
                              //                 // teachingCourses[index]
                              //                 //     .expand['students_enrolled']![
                              //                 //         index]
                              //                 //     .data
                              //                 //     .length,

                              //                 itemBuilder: (context, index2) {
                              //                   // return ListTile(
                              //                   //   title: Text(teachingCourses[
                              //                   //           index]
                              //                   //       .expand[
                              //                   //           'students_enrolled']![
                              //                   //           index]
                              //                   //       .data['name']),
                              //                   //   subtitle: Text(
                              //                   //       teachingCourses[index]
                              //                   //           .expand[
                              //                   //               'students_enrolled']![
                              //                   //               index]
                              //                   //           .data['uid']
                              //                   //           .toString()),
                              //                   // );
                              //                 },
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   closedColor: Colors.transparent,
                              //   openColor: Colors.transparent,
                              // );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            }),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     attendValidate();
            //   },
            //   child: const Text('Scan Students'),
            // ),
          ],
        ),
      ),
      // ),
    );
  }

  Future<dynamic> attendValidate() async {
    return Get.bottomSheet(const SubmitAttendance(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        isDismissible: false,
        enableDrag: false,
        elevation: 0.0);
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black54,
                child: Text(
                  user.name[0],
                  style: const TextStyle(fontSize: 40),
                )),
            IconButton(
                splashRadius: 32,
                onPressed: () {},
                icon: const Icon(Icons.search)),
            IconButton(
                splashRadius: 32,
                onPressed: () {},
                icon: const Icon(Icons.notifications_active_outlined)),
            IconButton(
              splashRadius: 32,
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                // print("before: $isDark");
                // isDark = !isDark;
                // Get.changeTheme((isDark) ? dark : light);
                // print("after: $isDark");
                PbDb.pb.authStore.clear();
                final box = GetStorage();
                // box.write('isLogin', false);
                box.erase();
                // Get.offAll(() => const Landing()); //dependent empty error
                // Get.offAllNamed('/');
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const Login();
                }), (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
  @override
  void initState() {
    super.initState();
    // print('status: $status');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (!status.value) {
      //   // attend();
      // }
      Future.delayed(const Duration(seconds: 5), () {
        attendance.value = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    isRepeatingAnimation: true,
                    repeatForever: true,
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
                        check = controller.findSMI("Check") as SMITrigger;
                        error = controller.findSMI("Error") as SMITrigger;
                        reset = controller.findSMI("Reset") as SMITrigger;
                      },
                      // animations: ['bounce'],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // if (Platform.isAndroid) {
                          //   status.value = await flutterBeacon.isBroadcasting();
                          // } else {
                          //   status.value = await i_beacon.BeaconBroadcast()
                          //       .isAdvertising() as bool;
                          // }
                          check.fire();

                          //print(status.value);

                          // _isPlaying ? null : _controller.isActive = true;
                        },
                        child: const Text('check'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // if (Platform.isAndroid) {
                          //   status.value = await flutterBeacon.isBroadcasting();
                          // } else {
                          //   status.value = await i_beacon.BeaconBroadcast()
                          //       .isAdvertising() as bool;
                          // }
                          error.fire();

                          //print(status.value);

                          // _isPlaying ? null : _controller.isActive = true;
                        },
                        child: const Text('error'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // if (Platform.isAndroid) {
                          //   status.value = await flutterBeacon.isBroadcasting();
                          // } else {
                          //   status.value = await i_beacon.BeaconBroadcast()
                          //       .isAdvertising() as bool;
                          // }
                          reset.fire();

                          //print(status.value);

                          // _isPlaying ? null : _controller.isActive = true;
                        },
                        child: const Text('reset'),
                      ),
                    ],
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

Widget customCard(
    RecordModel model,
// , VoidCallback open
    BuildContext context) {
  List<RecordModel> studentsEnrolled =
      model.expand["students_enrolled"] as List<RecordModel>;

  // print(studentsEnrolled.length);
  // RxMap<int, bool> present = <int, bool>{}.obs;
  // RxList<int> present = <int>[].obs;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      // onTap: () {
      //   OpenContainer(closedBuilder: , openBuilder: openBuilder);
      // },
      //remove padding
      // onTap: () => open(),
      onTap: () {
        // print("id:${model.id}");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Attendance(
                    title: model.data['course_name'],
                    records: studentsEnrolled,
                    id: model.id,
                  )),
        );
        // studentsEnrolled.forEach((element) {
        //   print(element.data['name']);
        // });
        // showGeneralDialog(
        //     barrierLabel: "course",
        //     barrierDismissible: true,
        //     context: context,
        //     pageBuilder: (context, anim1, anim2) {
        //       return Align(
        //         alignment: Alignment.center,
        //         child: Container(
        //           height: 300,
        //           child: Scaffold(
        //             body: ListView.builder(
        //               itemCount: studentsEnrolled.length,
        //               itemBuilder: (context, index) {
        //                 return Obx(() {
        //                   final int uid = studentsEnrolled[index].data['uid'];
        //                   return GestureDetector(
        //                     onTap: () => present.addIf(!present.contains(uid), uid),
        //                     child: ListTile(
        //                       title: Text(studentsEnrolled[index].data['name']),
        //                       subtitle: Text(
        //                           uid.toString()),
        //                       trailing: (present.contains(
        //                               uid))
        //                           ? Icon(Icons.check)
        //                           : CircularProgressIndicator(),
        //                     ),
        //                   );
        //                 });
        //               },
        //             ),
        //           ),
        //         ),
        //       );
        //     });
      },
      // autofocus: false,
      // splashFactory: InkSparkle.splashFactory,
      // borderRadius: BorderRadius.circular(8),
      // splashColor: Colors.blueGrey,
      // focusColor: Colors.blueGrey,
      // highlightColor: Colors.blueGrey,
      // hoverColor: Colors.blueGrey,
      // overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),

      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.lightBlue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Text(
              model.data['course_name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18), // Replace with desired text style
            ),
          ),
        ),
      ),
    ),
  );
}
