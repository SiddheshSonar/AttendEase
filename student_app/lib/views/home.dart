import 'dart:ui';
import 'package:attendease/components/attendance_graph.dart';
import 'package:attendease/components/scanner.dart';
import 'package:attendease/controllers/home_controller.dart';
import 'package:attendease/database/db.dart';
import 'package:attendease/main.dart';
import 'package:attendease/pages/event_cal.dart';
import 'package:attendease/views/login_screen.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final HomeController _homeController = Get.put(HomeController());

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  final Duration pageAnimationDuration = const Duration(milliseconds: 300);
  final Curve pageAnimationCurve = Curves.easeInOut;
  RxInt _currentPage = 0.obs;
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
                    GestureDetector(child: Obx(() {
                      return CircleAvatar(
                          radius: 32,
                          backgroundColor: _currentPage.value == 0
                              ? Colors.black
                              : Colors.transparent,
                          child: Text(
                            user.name[0],
                            style: const TextStyle(fontSize: 40),
                          ));
                    }), onTap: () {
                      _currentPage.value = 0;
                      _homeController.homePageController.animateToPage(0,
                          duration: pageAnimationDuration,
                          curve: pageAnimationCurve);
                    }),
                    Obx(() {
                      return CircleAvatar(
                        radius: 32,
                        backgroundColor: _currentPage.value == 1
                            ? Colors.black
                            : Colors.transparent,
                        child: IconButton(
                            splashRadius: 32,
                            onPressed: () {
                              _currentPage.value = 1;
                              _homeController.homePageController.animateToPage(
                                  1,
                                  duration: pageAnimationDuration,
                                  curve: pageAnimationCurve);
                            },
                            icon: const Icon(Icons.event_available_rounded)),
                      );
                    }),
                    Obx(() {
                      return CircleAvatar(
                        radius: 32,
                        backgroundColor: _currentPage.value == 2
                            ? Colors.black
                            : Colors.transparent,
                        child: IconButton(
                            splashRadius: 32,
                            onPressed: () {
                              _currentPage.value = 2;
                              _homeController.homePageController.animateToPage(
                                  2,
                                  duration: pageAnimationDuration,
                                  curve: pageAnimationCurve);
                            },
                            icon: const Icon(Icons.notes_rounded)),
                      );
                    }),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.transparent,
                      child: IconButton(
                        splashRadius: 32,
                        icon: const Icon(Icons.logout_rounded),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: AlertDialog(
                                    backgroundColor:
                                        Colors.cyan.withOpacity(0.125),
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
                                            Navigator.pushAndRemoveUntil(
                                                context, MaterialPageRoute(
                                                    builder: (context) {
                                              return const Login();
                                            }), (r) => false);
                                          },
                                          child: const Text('Logout')),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
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
        child: const Icon(Icons.bolt),
      ),
      body: PageView(
        controller: _homeController.homePageController,
        onPageChanged: (value) {
          _currentPage.value = value;
        },
        physics: const BouncingScrollPhysics(),
        children: _homeController.home,
      ),
      // ),
    );
  }

  Future<bool> _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Touch your finger on the sensor to login',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ));
    } catch (e) {}
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
          // TODO: event list
          // implement event list with dummy data
          const EventsWidget()
        ],
      ),
    );
  }
}

List dummyData = [
  {
    'course': 'DAA',
    'event': 'Assignment 1',
    'desc':
        "XYZ should be done in C or JAVA, please submit the same on Moodle.",
    'endDate': '2023-04-30T11:45', //in iso format
    'createdAt': '2023-04-25T00:00',
  },
  {
    'course': 'OS',
    'event': 'ISE 2',
    'desc':
        "Exam will consist of 2 parts, 1st part will be MCQs and 2nd will be coding. Please prepare accordingly.\nSyllabus: Module 1, 2 & 3",
    'endDate': '2023-04-30T11:45', //in iso format
    'createdAt': '2023-04-20T00:00',
  },
  {
    'course': 'CCN',
    'event': 'ISE 2',
    'desc':
        "Exam will consist of 2 parts, 1st part will be MCQs and 2nd will be coding. Please prepare accordingly.\nSyllabus: Module 1, 2 & 3",
    'endDate': '2023-05-02T13:15', //in iso format
    'createdAt': '2023-04-29T00:00',
  },
  {
    'course': 'HSS',
    'event': 'Assignment 2',
    'desc': "Assignment 2 is out, please submit the same on Moodle.",
    'endDate': '2023-05-02T13:15', //in iso format
    'createdAt': '2023-04-29T00:00',
  }
  // {
  //   'course': 'PCS',
  //   'percentage': 0.5,
  // },
  // {
  //   'course': 'SEVA',
  //   'percentage': 0.4,
  // }
];

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        // separatorBuilder: (context, index) {
        //   return const SizedBox(height: 10);
        // },
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final DateTime endDate = DateTime.parse(dummyData[index]['endDate']);
          final String dayOfWeek =
              getDayOfWeek(endDate.year, endDate.month, endDate.day);
          final String formattedEndDate =
              '${endDate.day}/${endDate.month}/${endDate.year} ${endDate.hour}:${endDate.minute} ($dayOfWeek)';

          final String course = dummyData[index]['course'];
          final String event = dummyData[index]['event'];
          final String desc = dummyData[index]['desc'];
          return GestureDetector(
            onTap: () {
              _showDescDialog(context, desc);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                tileColor: Colors.blueGrey.withOpacity(0.2),
                title: Text(
                  course,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event),
                    const SizedBox(height: 4),
                    Text(
                      formattedEndDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showDescDialog(BuildContext context, String desc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.blueGrey.withOpacity(0.5),
          title: const Text('Description'),
          content: Text(desc),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
