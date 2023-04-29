import 'package:attendease/components/attendance_graph.dart';
import 'package:attendease/models/home_model.dart';
import 'package:attendease/pages/event_cal.dart';
import 'package:attendease/views/home.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    await homeModel.populateUserData();
    await homeModel.populateUserCourses();

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
