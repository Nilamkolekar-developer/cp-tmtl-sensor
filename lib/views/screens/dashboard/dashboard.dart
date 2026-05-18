import 'package:cp_tmtl_sensor_zig/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/dasboardController.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "ATPL Diagnostic Tool",
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(
          children: [
            // ── LEFT SIDEBAR ─────────────────────────────────────────────
            Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text("Engine Models",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.5)),
                  ),
                  Expanded(
                    child: Obx(() => ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: controller.engineModels.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                          itemBuilder: (context, idx) {
                            final isSelected =
                                controller.selectedModelIndex.value == idx;

                            return GestureDetector(
                              onTap: () => controller.selectModel(idx),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange.shade50
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange.shade400
                                        : Colors.grey.shade200,
                                    width: isSelected ? 1.5 : 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Model",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500)),
                                    Text(
                                      controller.engineModels[idx]['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.orange.shade800
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),

            // ── RIGHT MAIN CONTENT ────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final data = controller.selectedModel;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date badge
                      _buildDateHeader(),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        "Engine Model: ${data['name']}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Production Line Performance Overview",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 24),

                      // ── Chart on top ──────────────────────────────────
                      _buildChartSection(data, true),
                      const SizedBox(height: 20),

                      // ── Stats below chart ─────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              "Total Tested",
                              "${data['total']}",
                              Icons.speed,
                              Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              "Today Tested",
                              "${data['today']}",
                              Icons.calendar_today,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              "Today Pass",
                              "${data['pass']}",
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              "Today Fail",
                              "${data['fail']}",
                              Icons.cancel,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

// ── Date Header ───────────────────────────────────────────────────────────
  Widget _buildDateHeader() {
    final now = DateTime.now();
    final formatted =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Date: $formatted",
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade700),
      ),
    );
  }

// ── Chart Section ─────────────────────────────────────────────────────────
  Widget _buildChartSection(Map<String, dynamic> data, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 6,
                    centerSpaceRadius: 110,
                    sections: _getSections(data),
                  ),
                ),
                // (data['total'] ?? 0) == 0
                //     ? Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(
                //               Icons.pie_chart_outline,
                //               size: 80,
                //               color: Colors.grey.shade400,
                //             ),
                //             const SizedBox(height: 12),
                //             Text(
                //               "No Data Available",
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.grey.shade600,
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : PieChart(
                //         PieChartData(
                //           sectionsSpace: 6,
                //           centerSpaceRadius: 110,
                //           sections: _getSections(data),
                //         ),
                //       ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${data['total']}",
                        style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B)),
                      ),
                      const Text(
                        "TOTAL TESTED",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 24,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _legendItem(Colors.green.shade600, "Today Pass"),
              _legendItem(Colors.red.shade800, "Today Fail"),
              _legendItem(Colors.blue.shade400, "Today Tested"),
              _legendItem(Colors.orange.shade800, "Total Tested"),
            ],
          ),
        ],
      ),
    );
  }

// ── Stat Card ─────────────────────────────────────────────────────────────
  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

// ── Legend Item ───────────────────────────────────────────────────────────
  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey)),
      ],
    );
  }

// ── Pie Chart Sections ────────────────────────────────────────────────────
// List<PieChartSectionData> _getSections(Map<String, dynamic> data) {
//   const double radius = 60;
//   return [
//     _section(Colors.green.shade600, (data['pass'] ?? 0).toDouble(),
//         "${data['pass']}", radius),
//     _section(Colors.red.shade800, (data['fail'] ?? 0).toDouble(),
//         "${data['fail']}", radius),
//     _section(Colors.blue.shade400, (data['today'] ?? 0).toDouble(),
//         "${data['today']}", radius),
//     _section(Colors.orange.shade800, (data['total'] ?? 0).toDouble(),
//         "${data['total']}", radius),
//   ];
// }
  List<PieChartSectionData> _getSections(Map<String, dynamic> data) {
    const double radius = 60;

    double pass = (data['todayPass'] ?? 0).toDouble();

    double fail = (data['todayFail'] ?? 0).toDouble();

    double today = (data['today'] ?? 0).toDouble();

    double total = (data['total'] ?? 0).toDouble();

    return [
      _section(
        Colors.green.shade600,
        pass,
        pass.toInt().toString(),
        radius,
      ),
      _section(
        Colors.red.shade800,
        fail,
        fail.toInt().toString(),
        radius,
      ),
      _section(
        Colors.blue.shade400,
        today,
        today.toInt().toString(),
        radius,
      ),
      _section(
        Colors.orange.shade800,
        total,
        total.toInt().toString(),
        radius,
      ),
    ];
  }

  PieChartSectionData _section(
      Color color, double val, String title, double rad) {
    return PieChartSectionData(
      color: color,
      value: val,
      title: title,
      radius: rad,
      titlePositionPercentageOffset: 0.6,
      titleStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
    );
  }
}
