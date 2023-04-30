import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:attendease/controllers/home_controller.dart';
import 'package:attendease/database/db.dart';
import 'package:attendease/helper/notification_service.dart';
import 'package:attendease/main.dart';
import 'package:attendease/views/login_screen.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeModel {
  late HomeController _homeController;
  // late StreamSubscription _userSub;
  // late StreamSubscription _courseSub;
  // var userSub;
  // var courseSub;

  HomeModel(HomeController homeController) {
    _homeController = homeController;
    PbDb.pb.collection('students').subscribe(user.id, (e) async {
      // print("stream initalized");
      if (e.action == "update") {
        // print("stream is active");
        // _isFetching.value = true;
        _homeController.attendance = e.record?.data["attendance"];
        try {
          submitCheck.fire();
        } catch (e) {
          // print(e);
        }

        if (!Get.isOverlaysClosed) {
          await Future.delayed(const Duration(seconds: 2), () {
            Get.back(closeOverlays: true);
          });
          // Get.back(closeOverlays: true);
        }
        int i = 0;
        _homeController.items.clear();
        _homeController.percentages.clear();
        _homeController.courses.forEach((key, value) {
          // print("key: $key, value: $value, attendance: ${attendance[key]}");
          // barData.add(BarData(name: key, y1: (attendance[key] != null) ? attendance[key].length : 0, y2: courses[key]));

          _homeController.items.add(makeGroupData(
              i++,
              (_homeController.attendance[key] != null)
                  ? _homeController.attendance[key].length
                  : 0,
              _homeController.courses[key]));
        });
        // rawBarGroups = items;
        _homeController.showingBarGroups = _homeController.items;
        _homeController.graphKey.currentState?.update();
        Future.delayed(const Duration(milliseconds: 500), () {
          _homeController.isFetching.value = false;
        });
        // _isFetching.value = false;
      }
    });
    PbDb.pb.collection("courses").subscribe("*", (e) {
      if (e.action == "update") {
        e.record?.data["students_enrolled"].forEach((element) {
          if (element == user.id) {
            _homeController.courses[e.record?.data["course_name"]] =
                e.record?.data["lectures"];
          }
        });
        // print("courses: $courses");
      }
    });
  }

  BarChartGroupData makeGroupData(int x, int y1, int y2) {
    _homeController.percentages.add(y1 * 100 / y2);
    // print("x: $x, y1: $y1, y2: $y2");
    // print("percent: ${y1 / y2}");

    Color attColor = const Color(0xFF39FF14);
    if (y1 / y2 < 0.75) {
      attColor = const Color.fromARGB(255, 231, 80, 80);
    }
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1.toDouble(),
          color: attColor,
          width: 14,
        ),
        BarChartRodData(
          toY: y2.toDouble(),
          // color: const Color(0xFF39FF14),
          color: const Color(0xFF04d9ff),
          width: 14,
        ),
      ],
    );
  }

  Future<void> populateUserData() async {
    await PbDb.pb
        .collection("students")
        .getOne(user.id, expand: "courses_enrolled")
        .then((RecordModel value) {
      _homeController.attendance = value.data["attendance"];
      createNotificationQueue(value);
      populateGraph();
      _homeController.isFetching.value = false;
    });
  }

  Future<void> populateUserCourses() async {
    await PbDb.pb.collection("courses").getFullList().then((value) {
      for (RecordModel element in value) {
        if (element.data["students_enrolled"].contains(user.id)) {
          _homeController.courses[element.data["course_name"]] =
              element.data["lectures"];
        }
      }
    });
  }

  void populateGraph() {
    int i = 0;
    _homeController.items.clear();
    _homeController.percentages.clear();
    _homeController.courses.forEach((key, value) {
      _homeController.items.add(makeGroupData(
          i++,
          (_homeController.attendance[key] != null)
              ? _homeController.attendance[key].length
              : 0,
          _homeController.courses[key]));
    });

    _homeController.showingBarGroups = _homeController.items;
  }

  Future<void> createNotificationQueue(RecordModel value) async {
    NotificationService().cancelAllScheduled();
    for (var course in value.expand["courses_enrolled"]!) {
      Map data = course.data["tt"];

      for (var key in data.keys) {
        int weekDay = int.parse(key);
        List timing = data[key];
        for (var element in timing) {
          String courseName = course.data["course_name"];
          String roomNo = course.data["room_no"];

          int sHr = int.parse(element[0]);
          int sMin = int.parse(element[1]);
          int eHr = int.parse(element[2]);
          int eMin = int.parse(element[3]);
          DateTime now = DateTime.now();
          for (int i = 0; i < 7; i++) {
            DateTime date =
                DateTime(now.year, now.month, now.day).add(Duration(days: i));
            if (date.weekday == weekDay) {
              DateTime startTime =
                  DateTime(date.year, date.month, date.day, sHr, sMin, 0, 0, 0);
              DateTime endTime =
                  DateTime(date.year, date.month, date.day, eHr, eMin, 0, 0, 0);
              _homeController.eventController.add(CalendarEventData(
                  title: "$courseName in $roomNo",
                  date: date,
                  startTime: startTime,
                  endTime: endTime));
              int id = Random().nextInt(100000);
              if (_homeController.attendance[courseName] != null) {
                int lecturesAttended =
                    _homeController.attendance[courseName]!.length;
                print(courseName);
                double newAttendPercentage = (lecturesAttended + 1) *
                        100 /
                        _homeController.courses[courseName]! +
                    1;
                double newNotAttendPercentage = (lecturesAttended) *
                    100 /
                    (_homeController.courses[courseName]! + 1);
                NotificationService().scheduleNotification(
                    id,
                    "$courseName ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}",
                    "Attend: ${newAttendPercentage.toStringAsFixed(2)}% | Bunk: ${newNotAttendPercentage.toStringAsFixed(2)}%",
                    startTime.subtract(const Duration(minutes: 10)));
              } else {
                NotificationService().scheduleNotification(
                    id,
                    "Lecture Reminder",
                    "$courseName in $roomNo",
                    startTime.subtract(const Duration(minutes: 10)));
              }
            }
          }
        }
      }
    }
  }
}
