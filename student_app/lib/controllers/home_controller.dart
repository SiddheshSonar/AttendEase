import 'package:attendease/components/attendance_graph.dart';
import 'package:attendease/models/home_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isFetching = true.obs;

  Map attendance = {};
  Map courses = {};

  final List<BarChartGroupData> items = [];

  late List<BarChartGroupData> showingBarGroups;
  GlobalKey<AtGraphState> graphKey = GlobalKey<AtGraphState>();

  late HomeModel homeModel;
  HomeController() {
    homeModel = HomeModel(this);
  }

  @override
  void onInit() async {
    // await Future.wait([
    //   homeModel.populateUserData(),
    //   homeModel.populateUserCourses(),
    // ]);
    await homeModel.populateUserData();
    await homeModel.populateUserCourses();

    // print('attendance: $attendance');
    // isFetching.value = false;
    super.onInit();
  }

  @override
  void onClose() async{
    // await homeModel.cancelSubscriptions();
    super.onClose();
  }
}
