import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:autopeepal/logic/controller/dashboard/dasboardController.dart';
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';

class TestingScreen extends StatelessWidget {
  TestingScreen({super.key});
  final DashboardController controller = Get.put(DashboardController());

  final List<Map<String, String>> testSteps = [
    {"sr": "1", "part": "Crankshaft RPM", "status": "OK"},
    {"sr": "2", "part": "Temp Coolant", "status": "NOT OK"},
    {"sr": "3", "part": "Charge Air Temp", "status": "OK"},
    {"sr": "4", "part": "Fuel Rail Pres", "status": "OK"},
    {"sr": "5", "part": "Adjuster MPROP", "status": "OK"},
  ];

  // @override
  // Widget build(BuildContext context) {
  //   final bool isDesktop = MediaQuery.of(context).size.width > 800;

  //   return SafeArea(
  //     child: MainLayout(
  //       title: "ATPL Diagnostic Tool",
  //       child: SingleChildScrollView(
  //         padding: EdgeInsets.all(isDesktop ? 40 : 16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // --- ESN VALIDATION SECTION (Adaptive) ---
  //             const Text("ESN",
  //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 10),
  //             Wrap(
  //               spacing: 15,
  //               runSpacing: 15,
  //               children: [
  //                 SizedBox(
  //                   width: isDesktop ? 400 : double.infinity,
  //                   height: 50,
  //                   child: TextField(
  //                     textAlign: TextAlign.center,
  //                     decoration: InputDecoration(
  //                       hintText: "112233445566778899",
  //                       border:
  //                           OutlineInputBorder(borderRadius: BorderRadius.zero),
  //                       contentPadding: EdgeInsets.zero,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: isDesktop ? 150 : double.infinity,
  //                   height: 50,
  //                   child: ElevatedButton(
  //                     onPressed: () {},
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xFF4A5A71),
  //                       shape: const RoundedRectangleBorder(),
  //                     ),
  //                     child: const Text("Validate",
  //                         style: TextStyle(color: Colors.white)),
  //                   ),
  //                 ),
  //               ],
  //             ),
      
  //             const SizedBox(height: 50),
  //             const Text("Test Steps",
  //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 15),
      
  //             // --- CONSTANT WIDTH TABLE (No Overflows) ---
  //             Container(
  //               decoration:
  //                   BoxDecoration(border: Border.all(color: Colors.black)),
  //               child: Table(
  //                 columnWidths: const {
  //                   0: FlexColumnWidth(1), // Sr. No
  //                   1: FlexColumnWidth(3), // Part Name
  //                   2: FlexColumnWidth(2), // Status
  //                 },
  //                 border: TableBorder.all(color: Colors.black12),
  //                 children: [
  //                   TableRow(
  //                     decoration: BoxDecoration(color: Colors.grey[100]),
  //                     children: [
  //                       _buildCell("Sr.", isHeader: true),
  //                       _buildCell("Part Name", isHeader: true),
  //                       _buildCell("Status", isHeader: true),
  //                     ],
  //                   ),
  //                   ...testSteps.map((step) => TableRow(
  //                         children: [
  //                           _buildCell(step['sr']!),
  //                           _buildCell(step['part']!),
  //                           _buildCell(
  //                             step['status']!,
  //                             color: step['status'] == "OK"
  //                                 ? Colors.green
  //                                 : Colors.red,
  //                           ),
  //                         ],
  //                       )),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCell(String text, {bool isHeader = false, Color? color}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
  //     child: Text(
  //       text,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: isHeader ? 14 : 13,
  //         fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
  //         color: color ?? Colors.black,
  //       ),
  //     ),
  //   );
  // }
  @override
Widget build(BuildContext context) {
  final bool isDesktop = MediaQuery.of(context).size.width > 800;

  // Define responsive font sizes here for easy maintenance
  final double titleFontSize = isDesktop ? 24 : 20;
  final double bodyFontSize = isDesktop ? 20 : 14;
  final double tableHeaderFontSize = isDesktop ? 25 : 14;
  final double tableCellFontSize = isDesktop ? 18 : 13;

  return SafeArea(
    child: MainLayout(
      title: "ATPL Diagnostic Tool",
      
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 40 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ESN VALIDATION SECTION ---
            Text(
              "ESN",
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                SizedBox(
                  width: isDesktop ? 400 : double.infinity,
                  height: isDesktop ? 60 : 50, // Slightly taller on desktop
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: bodyFontSize), // Responsive text inside field
                    decoration: const InputDecoration(
                      hintText: "112233445566778899",
                      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 150 : double.infinity,
                  height: isDesktop ? 50 : 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5A71),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      "Validate",
                      style: TextStyle(color: Colors.white, fontSize: bodyFontSize),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),
            Text(
              "Test Steps",
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // --- TABLE SECTION ---
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                },
                border: TableBorder.all(color: Colors.black12),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    children: [
                      // Pass the responsive font size to the helper
                      _buildCell("Sr.", fontSize: tableHeaderFontSize, isHeader: true),
                      _buildCell("Part Name", fontSize: tableHeaderFontSize, isHeader: true),
                      _buildCell("Status", fontSize: tableHeaderFontSize, isHeader: true),
                    ],
                  ),
                  ...testSteps.map((step) => TableRow(
                        children: [
                          _buildCell(step['sr']!, fontSize: tableCellFontSize),
                          _buildCell(step['part']!, fontSize: tableCellFontSize),
                          _buildCell(
                            step['status']!,
                            fontSize: tableCellFontSize,
                            color: step['status'] == "OK" ? Colors.green : Colors.red,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Updated helper method to accept a specific fontSize
Widget _buildCell(String text, {required double fontSize, bool isHeader = false, Color? color}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: isHeader ? 18 : 15, // Slightly more padding for headers on desktop
      horizontal: 8,
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        color: color ?? Colors.black,
      ),
    ),
  );
}
}
