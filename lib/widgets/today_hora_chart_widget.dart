import 'package:bazi_app_frontend/configs/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TodayHoraChart extends StatelessWidget {
  const TodayHoraChart({required this.h, super.key});

  final List<dynamic> h;

  @override
  Widget build(BuildContext context) {
    double maxTop = h.map((e) => e[0].toDouble()).cast<double>().reduce(max);
    double minBottom = h.map((e) => e[1].toDouble()).cast<double>().reduce(min);
    double interval = 2;
    double barWidth = 25;
    double totalWidth = (barWidth + 25) * h.length;

    List<int> yLabels = [];
    for (int v = (minBottom).floor(); v <= maxTop.ceil(); v++) {
      if (v % interval == 0 && v % 2 == 0) {
        yLabels.add(v);
      }
    }
    yLabels = yLabels.reversed.toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: yLabels.map((v) {
                return Text(
                  v.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.right,
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: totalWidth,
                height: 190,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: createBarGroups(barWidth),
                    borderData: FlBorderData(show: false),
                    minY: minBottom,
                    maxY: maxTop,
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      verticalInterval: 2 / 24,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashArray: [10, 5],
                      ),
                      getDrawingVerticalLine: (value) => const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashArray: [10, 5],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'ย.${value.toInt() + 1}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                          //   showTitles: true,
                          //   interval: interval,
                          //   getTitlesWidget: (value, meta) {
                          //     if (value % interval != 0 || value.toInt() % 2 != 0) {
                          //       return const SizedBox.shrink();
                          //     }
                          //     return Padding(
                          //       padding: const EdgeInsetsGeometry.directional(end: 5),
                          //       child: Text(
                          //         value.toInt().toString(),
                          //         style: Theme.of(context).textTheme.bodySmall,
                          //         textAlign: TextAlign.right,
                          //       )
                          //     );
                          //   },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        tooltipMargin: 8,
                        tooltipBorderRadius: .circular(8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final topValue = h[group.x.toInt()][0].toDouble();
                          final bottomValue = h[group.x.toInt()][1].toDouble();

                          return BarTooltipItem(
                            'ดี: ${topValue.toStringAsFixed(2)}\nแย่: ${bottomValue.toStringAsFixed(2)}',
                            const TextStyle(
                              color: wColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartRodStackItem> generateStackItemsWithGradient(
    double from,
    double to,
    Color startColor,
    Color endColor,
  ) {
    List<BarChartRodStackItem> items = [];

    int steps = 100;
    if (steps < 1 || from == to) return items;

    double stepSize = (to - from) / steps;

    for (int i = 0; i < steps; i++) {
      double start = from + i * stepSize;
      double end = start + stepSize;
      Color color = Color.lerp(startColor, endColor, i / (steps - 1))!;
      items.add(BarChartRodStackItem(start, end, color));
    }

    return items;
  }

  List<BarChartGroupData> createBarGroups(double barWidth) {
    return List.generate(h.length, (index) {
      double topValue = h[index][0].toDouble();
      double bottomValue = h[index][1].toDouble();

      List<BarChartRodStackItem> stackItems = [];

      if (bottomValue < 0) {
        stackItems.addAll(
          generateStackItemsWithGradient(
            bottomValue,
            0,
            const Color(0xFF862D2D),
            const Color(0xFFcbbcbc),
          ),
        );
      }

      if (topValue > 0) {
        stackItems.addAll(
          generateStackItemsWithGradient(
            0,
            topValue,
            const Color(0xFFbec6c1),
            const Color(0xFF316141),
          ),
        );
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            fromY: bottomValue < 0 ? bottomValue : 0,
            toY: topValue > 0 ? topValue : 0,
            width: barWidth,
            rodStackItems: stackItems,
            borderRadius: BorderRadius.vertical(
              top: topValue > 0 ? const Radius.circular(10) : Radius.zero,
              bottom: bottomValue < 0 ? const Radius.circular(10) : Radius.zero,
            ),
          ),
        ],
      );
    });
  }
}
