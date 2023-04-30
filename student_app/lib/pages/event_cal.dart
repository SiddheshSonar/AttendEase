// import 'dart:html';

import 'package:attendease/controllers/home_controller.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;
  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DayView(
      eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.cyan.withOpacity(0.4)),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ListTile(
            title: Text(events.first.title),
            subtitle: Text(events.first.description),
          ),
        );
      },
      controller: widget._homeController.eventController,
      liveTimeIndicatorSettings:
          const HourIndicatorSettings(color: Colors.cyan, height: 2.0),
      backgroundColor: Colors.black,
      dayTitleBuilder: (date) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       DayViewState().previousPage();
                    //     },
                    //     icon: Icon(Icons.arrow_back_ios)),
                    Text(
                      // format date in dd-mm-yyyy (dayofweek in string ex Monday)
                      "${date.day}-${date.month}-${date.year} (${getDayOfWeek(date.year, date.month, date.day)})",

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      headerStyle: HeaderStyle(
        headerMargin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}

String getDayOfWeek(int year, int month, int day) {
  DateTime date = DateTime(year, month, day);
  int dayOfWeekInt = date.weekday;
  switch (dayOfWeekInt) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Error";
  }
}
