// import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:autopeepal/logic/controller/dashboard/dasboardController.dart';

// class DashboardScreen extends StatelessWidget {
//   DashboardScreen({super.key});
//   final DashboardController controller = Get.put(DashboardController());

//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       title: "ATPL Diagnostic Tool",
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isDesktop = constraints.maxWidth > 800;
//           bool isSmallMobile = constraints.maxWidth < 400;

//           return SingleChildScrollView(
//             // Tighter padding for mobile to maximize screen real estate
//             padding: EdgeInsets.symmetric(
//                 horizontal: isDesktop ? 60 : 16, vertical: isDesktop ? 40 : 15),
//             child: Column(
//               crossAxisAlignment: isDesktop
//                   ? CrossAxisAlignment.start
//                   : CrossAxisAlignment.center,
//               children: [
//                 // Date Display - Aligned center for mobile
//                 Align(
//                   alignment:
//                       isDesktop ? Alignment.centerLeft : Alignment.center,
//                   child: Text(
//                     "Date: 09.04.2026",
//                     style: TextStyle(
//                       fontSize: isDesktop ? 16 : 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: isDesktop ? 40 : 20),

//                 Center(
//                   child: Container(
//                     constraints: const BoxConstraints(maxWidth: 1000),
//                     child: Column(
//                       children: [
//                         Text(
//                           "Engine Test Zig",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: isDesktop
//                                   ? 28
//                                   : 22, // Smaller title for mobile
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[700],
//                               letterSpacing: 1.2),
//                         ),
//                         SizedBox(height: isDesktop ? 40 : 25),

//                         // Pie Chart Container
//                         SizedBox(
//                           height: isDesktop
//                               ? 400
//                               : 250, // Reduced height for mobile
//                           child: PieChart(
//                             PieChartData(
//                               sectionsSpace: 2,
//                               centerSpaceRadius: 0,
//                               sections: _getSections(isDesktop, isSmallMobile),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         // Legend with better spacing for fingers
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Wrap(
//                             spacing: 20,
//                             runSpacing: 12,
//                             alignment: WrapAlignment.center,
//                             children: [
//                               _buildLegend(Colors.blue.shade600, "Test OK"),
//                               _buildLegend(
//                                   Colors.orange.shade800, "Test Not Ok"),
//                               _buildLegend(Colors.grey.shade400, "Retest"),
//                             ],
//                           ),
//                         ),

//                         SizedBox(height: isDesktop ? 80 : 50),

//                         // Bottom Stats - Cleanly separated
//                         _buildStatsRow(isDesktop),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatsRow(bool isDesktop) {
//     List<Widget> stats = [
//       _buildStatItem("Total Engine Tested", "100", isDesktop),
//       _buildStatItem("Today's Engine tested", "52", isDesktop),
//       _buildStatItem("Today Plan engine testing", "10", isDesktop),
//     ];

//     if (isDesktop) {
//       return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: stats);
//     } else {
//       // Mobile: Vertical list with dividers for better readability
//       return Column(
//         children: stats.asMap().entries.map((entry) {
//           int idx = entry.key;
//           Widget val = entry.value;
//           return Column(
//             children: [
//               val,
//               if (idx != stats.length - 1)
//                 Divider(
//                     height: 40,
//                     color: Colors.grey[200],
//                     thickness: 1,
//                     indent: 50,
//                     endIndent: 50),
//             ],
//           );
//         }).toList(),
//       );
//     }
//   }

//   List<PieChartSectionData> _getSections(bool isDesktop, bool isSmallMobile) {
//     // Dynamic radius based on screen width
//     double radius = isDesktop ? 200 : (isSmallMobile ? 100 : 120);
//     return [
//       _section(Colors.blue.shade600, 65, '65%', radius, isDesktop),
//       _section(Colors.orange.shade800, 25, '25%', radius, isDesktop),
//       _section(Colors.grey.shade400, 10, '10%', radius, isDesktop),
//     ];
//   }

//   PieChartSectionData _section(
//       Color color, double val, String title, double rad, bool isDesktop) {
//     return PieChartSectionData(
//       color: color,
//       value: val,
//       title: title,
//       radius: rad,
//       titlePositionPercentageOffset: 0.55, // Center the text in the slice
//       titleStyle: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: isDesktop ? 16 : 14),
//     );
//   }

//   Widget _buildLegend(Color color, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//             width: 14,
//             height: 14,
//             decoration: BoxDecoration(
//                 color: color, borderRadius: BorderRadius.circular(3))),
//         const SizedBox(width: 8),
//         Text(text,
//             style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87)),
//       ],
//     );
//   }

//   Widget _buildStatItem(String label, String value, bool isDesktop) {
//     return Column(
//       children: [
//         Text(label,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: isDesktop ? 18 : 15,
//                 color: Colors.grey[700],
//                 height: 1.2),
//             textAlign: TextAlign.center),
//         const SizedBox(height: 8),
//         Text(value,
//             style: TextStyle(
//                 fontSize: isDesktop ? 32 : 28,
//                 fontWeight: FontWeight.w300,
//                 color: Colors.blueAccent)),
//       ],
//     );
//   }
// }
import 'package:autopeepal/common_widgets/ui_helper_widgets.dart';
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

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 20, vertical: isDesktop ? 60 : 20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- HEADER SECTION ---

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Date Container
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 16 : 12,
                              vertical: isDesktop ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300
                                  .withOpacity(0.1), // Subtle background
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              // border: Border.all(
                              //   color: Colors.blueGrey.shade100,
                              //   width: 1,
                              // ),
                            ),
                            child: Text(
                              "Date: 09.04.2026",
                              style: TextStyle(
                                fontFamily: "Roboto-Regular",
                                fontSize: isDesktop ? 20 : 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue
                                    .shade700, // Slightly darker for better contrast
                              ),
                            ),
                          ),
                        ),

                        // Icon Logic
                        if (!isDesktop)
                          const Icon(Icons.analytics_outlined,
                              color: Colors.blue),
                      ],
                    ),
                    C5(),

                    Text(
                      "Engine Test Zig",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                          fontSize:
                              isDesktop ? 44 : 24, // Large Header for Windows
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          letterSpacing: 0.5),
                          
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Production Line Performance Overview",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: isDesktop ? 18 : 13 ,// Scaled for Windows
                           fontFamily: "Roboto-Regular",
                          ),
                    ),

                    SizedBox(height: isDesktop ? 70 : 5),

                    // --- CHART SECTION ---
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 15 : 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: isDesktop
                                ? 500
                                : 280, // Much larger chart for Windows
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: isDesktop ? 6 : 4,
                                    centerSpaceRadius:
                                        isDesktop ? 140 : 60, // Wider Donut
                                    sections: _getSections(isDesktop),
                                  ),
                                ),
                                // Center Summary Text
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "100",
                                        style: TextStyle(
                                          fontSize: isDesktop
                                              ? 64
                                              : 30, // Large Value
                                          fontWeight: FontWeight.w900,
                                           fontFamily: "Roboto-Regular",
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                                      Text("TOTAL TESTS",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: isDesktop ? 18 : 12,
                                              letterSpacing: 2,
                                               fontFamily: "Roboto-Regular",
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Legend
                          Wrap(
                            spacing: isDesktop ? 40 : 20,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildLegend(
                                  Colors.blue.shade600, "Test OK", isDesktop),
                              _buildLegend(Colors.orange.shade800,
                                  "Test Not Ok", isDesktop),
                              _buildLegend(
                                  Colors.grey.shade400, "Retest", isDesktop),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isDesktop ? 80 : 20),

                    // --- STATS SECTION ---
                    _buildStatsGrid(isDesktop),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: _buildStatCard(
                  "Total Tested", "100", Icons.speed, Colors.blue, isDesktop)),
          const SizedBox(width: 30),
          Expanded(
              child: _buildStatCard(
                  "Tested Today", "52", Icons.today, Colors.orange, isDesktop)),
          const SizedBox(width: 30),
          Expanded(
              child: _buildStatCard("Planned Today", "10", Icons.assignment,
                  Colors.blueGrey, isDesktop)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildStatCard(
              "Total Tested", "100", Icons.speed, Colors.blue, isDesktop),
          const SizedBox(height: 12),
          _buildStatCard(
              "Tested Today", "52", Icons.today, Colors.orange, isDesktop),
          const SizedBox(height: 12),
          _buildStatCard("Planned Today", "10", Icons.assignment,
              Colors.blueGrey, isDesktop),
        ],
      );
    }
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isDesktop ? 14 : 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: isDesktop ? 32 : 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: isDesktop ? 16 : 13,
                       fontFamily: "Roboto-Regular",
                      fontWeight: FontWeight.w600)),
              Text(value,
                  style: TextStyle(
                      fontSize: isDesktop ? 32 : 22,
                      fontWeight: FontWeight.bold,
                       fontFamily: "Roboto-Regular",
                      color: const Color(0xFF1E293B))),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections(bool isDesktop) {
    double radius = isDesktop ? 80 : 45; // Thicker ring for Windows
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
      titleStyle: TextStyle(
         fontFamily: "Roboto-Regular",
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isDesktop ? 18 : 12),
    );
  }

  Widget _buildLegend(Color color, String text, bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: isDesktop ? 16 : 10,
            height: isDesktop ? 16 : 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Text(text,
            style: TextStyle(
               fontFamily: "Roboto-Regular",
                fontSize: isDesktop ? 18 : 12,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey)),
      ],
    );
  }
}
