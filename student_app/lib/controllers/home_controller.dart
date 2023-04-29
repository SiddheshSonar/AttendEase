import 'package:attendease/components/attendance_graph.dart';
import 'package:attendease/helper/notification_service.dart';
import 'package:attendease/models/home_model.dart';
import 'package:attendease/pages/event_cal.dart';
import 'package:attendease/views/home.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class HomeController extends GetxController {
  final RxBool isFetching = true.obs;

  Map attendance = {};
  Map courses = {};

  final List<BarChartGroupData> items = [];
  final List<double> percentages = [];
  late List<BarChartGroupData> showingBarGroups;
  GlobalKey<AtGraphState> graphKey = GlobalKey<AtGraphState>();
  List<Widget> home = [];

  late HomeModel homeModel;
  PageController homePageController = PageController();
  final EventController eventController = EventController();
  // add data to this controller receieved from the server
  HomeController() {
    home = [HomePage(homeController: this), EventCalendar(
      homeController: this,
    )];
    homeModel = HomeModel(this);
  }

  @override
  void onInit() async {
    // await Future.wait([
    //   homeModel.populateUserData(),
    //   homeModel.populateUserCourses(),
    // ]);
    // String hour = "15";
    // String mins = "30";
    // DateTime now = DateTime.now();
    // print(
    //     "now: $now, now day of week: ${now.weekday} ${now.hour}:${now.minute}");
    // print("Time of day: ${TimeOfDay.now().hour}");
    // await NotificationService().showNotification(
    //     title: "Test Notification",
    //     body: "This is a test notification",
    //     // payload: "test payload"
    //     );
        // await Future.delayed(const Duration(seconds: 30));
    // NotificationService().scheduleNotification(scheduledNotificationDateTime: DateTime.now().add(const Duration(seconds: 10)), title: "Test Background Notification", body: "This is a test notification");
    // NotificationService().scheduleNotification(1, "works", "alas", DateTime.now().add(const Duration(seconds: 20)));
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin.zonedSchedule(
// 0,
// 'scheduled title',
// 'scheduled body',
// tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
// const NotificationDetails(
//     android: AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         channelDescription: 'your channel description')),
// androidAllowWhileIdle: true,
// uiLocalNotificationDateInterpretation:
//     UILocalNotificationDateInterpretation.absoluteTime);
    await homeModel.populateUserCourses();
    await homeModel.populateUserData();
    // reversed order
    // await homeModel.populateUserCourses();

    // print('attendance: $attendance');
    // isFetching.value = false;
    super.onInit();
  }

  @override
  void onClose() async {
    // await homeModel.cancelSubscriptions();
    super.onClose();
  }
}
