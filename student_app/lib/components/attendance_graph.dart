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

class AtGraphState extends State<AtGraph> {
  @override
  void initState() {
    super.initState();
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
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
            ),
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
    final titles = <String>[];
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
            fontSize: 12,
          ),
        ),
        Text(
          '${widget.percentages[value.toInt()].toStringAsFixed(2)}%',
          style: const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 12,
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
