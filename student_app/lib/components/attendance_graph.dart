import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AtGraph extends StatefulWidget {
  final List<BarChartGroupData> items;
  final List<BarChartGroupData> showingBarGroups;
  final Map courses;
  final List<double> percentages;
  const AtGraph(
      {required this.items,
      required this.showingBarGroups,
      required this.courses,
      required this.percentages,
      super.key});

  @override
  State<AtGraph> createState() => AtGraphState();
}

// final List<BarChartGroupData> items = [];

// int touchedGroupIndex = -1;

// late List<BarChartGroupData> rawBarGroups;

// late List<BarChartGroupData> showingBarGroups;

// final List<BarChartGroupData> items = [];

// late List<BarChartGroupData> showingBarGroups;

class AtGraphState extends State<AtGraph> {
  //final List<BarChartGroupData> items = [];

  //late List<BarChartGroupData> showingBarGroups;
  @override
  void initState() {
    super.initState();
    // int i = 0;
    // items.clear();
    // courses.forEach((key, value) {true
    //   // print("key: $key, value: $value, attendance: ${attendance[key]}");
    //   // barData.add(BarData(name: key, y1: (attendance[key] != null) ? attendance[key].length : 0, y2: courses[key]));
    //   items.add(makeGroupData(
    //       i++,
    //       (attendance[key] != null) ? attendance[key].length : 0,
    //       courses[key]));
    // });
    // //rawBarGroups = items;
    // showingBarGroups = items;
    //rawBarGroups;
    // setState(() {

    // });
    // print('init');
    // print(widget.data);
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: BarChart(
        BarChartData(
          // maxY: 20,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              // getTooltipItem: (a, b, c, d) => null,
            ),
            // touchCallback: (FlTouchEvent event, response) {
            //   if (response == null || response.spot == null) {
            //     setState(() {
            //       touchedGroupIndex = -1;
            //       showingBarGroups = List.of(rawBarGroups);
            //     });
            //     return;
            //   }

            //   touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            //   setState(() {
            //     if (!event.isInterestedForInteractions) {
            //       touchedGroupIndex = -1;
            //       showingBarGroups = List.of(rawBarGroups);
            //       return;
            //     }
            //     showingBarGroups = List.of(rawBarGroups);
            //     if (touchedGroupIndex != -1) {
            //       var sum = 0.0;
            //       for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
            //         sum += rod.toY;
            //       }
            //       final avg =
            //           sum / showingBarGroups[touchedGroupIndex].barRods.length;

            //       showingBarGroups[touchedGroupIndex] =
            //           showingBarGroups[touchedGroupIndex].copyWith(
            //         barRods:
            //             showingBarGroups[touchedGroupIndex].barRods.map((rod) {
            //           return rod.copyWith(toY: avg, color: Colors.redAccent);
            //         }).toList(),
            //       );
            //     }
            //   });
            // },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 62,
              ),
            ),
            // leftTitles: AxisTitles(
            //   sideTitles: SideTitles(
            //     showTitles: true,
            //     reservedSize: 28,
            //     interval: 1,
            //     getTitlesWidget: leftTitles,
            //   ),
            // ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: widget.showingBarGroups,
          gridData: FlGridData(show: false),
        ),
        swapAnimationDuration: const Duration(milliseconds: 1500),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // also pass percentage here
    // i have number of lectures here
    // just need number of lectures attended
    final titles = <String>[];
    // print(widget.courses);
    // print(widget.items);
    // print(widget.showingBarGroups);
    widget.courses.forEach((key, value) {
      titles.add(key);
    });
    final Widget text = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titles[value.toInt()],
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Text(
          '${widget.percentages[value.toInt()].toStringAsFixed(2)}%',
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 12, //margin top
      child: text,
    );
  }
}

// Widget bottomTitles(double value, TitleMeta meta) {
//   final titles = <String>[];
//   courses.forEach((key, value) {
//     titles.add(key);
//   });
//   final Widget text = Text(
//     titles[value.toInt()],
//     style: const TextStyle(
//       color: Color(0xff7589a2),
//       fontWeight: FontWeight.bold,
//       fontSize: 14,
//     ),
//   );

//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 16, //margin top
//     child: text,
//   );
// }

// BarChartGroupData makeGroupData(int x, int y1, int y2) {
//   return BarChartGroupData(
//     barsSpace: 4,
//     x: x,
//     barRods: [
//       BarChartRodData(
//         toY: y1.toDouble(),
//         color: const Color(0xFF04d9ff),
//         width: 18,
//       ),
//       BarChartRodData(
//         toY: y2.toDouble(),
//         color: const Color(0xFF39FF14),
//         width: 18,
//       ),
//     ],
//   );
// }
