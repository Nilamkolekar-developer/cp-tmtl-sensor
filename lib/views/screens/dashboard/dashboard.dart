import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:autopeepal/logic/controller/dashboard/dasboardController.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "ATPL Diagnostic Tool",
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          bool isSmallMobile = constraints.maxWidth < 400;

          return SingleChildScrollView(
            // Tighter padding for mobile to maximize screen real estate
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 16, vertical: isDesktop ? 40 : 15),
            child: Column(
              crossAxisAlignment: isDesktop
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // Date Display - Aligned center for mobile
                Align(
                  alignment:
                      isDesktop ? Alignment.centerLeft : Alignment.center,
                  child: Text(
                    "Date: 09.04.2026",
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: isDesktop ? 40 : 20),

                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: [
                        Text(
                          "Engine Test Zig",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: isDesktop
                                  ? 28
                                  : 22, // Smaller title for mobile
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              letterSpacing: 1.2),
                        ),
                        SizedBox(height: isDesktop ? 40 : 25),

                        // Pie Chart Container
                        SizedBox(
                          height: isDesktop
                              ? 400
                              : 250, // Reduced height for mobile
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 0,
                              sections: _getSections(isDesktop, isSmallMobile),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Legend with better spacing for fingers
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildLegend(Colors.blue.shade600, "Test OK"),
                              _buildLegend(
                                  Colors.orange.shade800, "Test Not Ok"),
                              _buildLegend(Colors.grey.shade400, "Retest"),
                            ],
                          ),
                        ),

                        SizedBox(height: isDesktop ? 80 : 50),

                        // Bottom Stats - Cleanly separated
                        _buildStatsRow(isDesktop),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(bool isDesktop) {
    List<Widget> stats = [
      _buildStatItem("Total Engine Tested", "100", isDesktop),
      _buildStatItem("Today's Engine tested", "52", isDesktop),
      _buildStatItem("Today Plan engine testing", "10", isDesktop),
    ];

    if (isDesktop) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: stats);
    } else {
      // Mobile: Vertical list with dividers for better readability
      return Column(
        children: stats.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget val = entry.value;
          return Column(
            children: [
              val,
              if (idx != stats.length - 1)
                Divider(
                    height: 40,
                    color: Colors.grey[200],
                    thickness: 1,
                    indent: 50,
                    endIndent: 50),
            ],
          );
        }).toList(),
      );
    }
  }

  List<PieChartSectionData> _getSections(bool isDesktop, bool isSmallMobile) {
    // Dynamic radius based on screen width
    double radius = isDesktop ? 200 : (isSmallMobile ? 100 : 120);
    return [
      _section(Colors.blue.shade600, 65, '65%', radius, isDesktop),
      _section(Colors.orange.shade800, 25, '25%', radius, isDesktop),
      _section(Colors.grey.shade400, 10, '10%', radius, isDesktop),
    ];
  }

  PieChartSectionData _section(
      Color color, double val, String title, double rad, bool isDesktop) {
    return PieChartSectionData(
      color: color,
      value: val,
      title: title,
      radius: rad,
      titlePositionPercentageOffset: 0.55, // Center the text in the slice
      titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isDesktop ? 16 : 14),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, bool isDesktop) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isDesktop ? 18 : 15,
                color: Colors.grey[700],
                height: 1.2),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                fontSize: isDesktop ? 32 : 28,
                fontWeight: FontWeight.w300,
                color: Colors.blueAccent)),
      ],
    );
  }
}
