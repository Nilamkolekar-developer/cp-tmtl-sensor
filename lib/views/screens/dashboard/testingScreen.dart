// import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/testingController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/mainLayoutScreen.dart';

// class TestingScreen extends StatelessWidget {
//   TestingScreen({super.key});
//   final ESNController controller = Get.put(ESNController());

//   final List<Map<String, String>> testSteps = [
//     {"sr": "1", "part": "Crankshaft RPM", "status": "OK"},
//     {"sr": "2", "part": "Temp Coolant", "status": "NOT OK"},
//     {"sr": "3", "part": "Charge Air Temp", "status": "OK"},
//     {"sr": "4", "part": "Fuel Rail Pres", "status": "OK"},
//     {"sr": "5", "part": "Adjuster MPROP", "status": "OK"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     final double titleFontSize = isDesktop ? 22 : 18;
//     final double labelFontSize = isDesktop ? 18 : 14;
//     final double valueFontSize = isDesktop ? 17 : 14;
//     final double tableCellFontSize = isDesktop ? 16 : 13;

//     return SafeArea(
//       child: MainLayout(
//         title: "ATPL Diagnostic Tool",
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(isDesktop ? 30 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- 1. ESN VALIDATION SECTION ---

//               // Row(
//               //   children: [
//               //     Text("ESN Validation :",
//               //         style: TextStyle(
//               //             fontSize: titleFontSize,
//               //             fontWeight: FontWeight.bold)),
//               //     const SizedBox(width: 20),
//               //     Flexible(
//               //       flex: 3, // Takes 3 parts of the available space
//               //       child: Padding(
//               //         padding: const EdgeInsets.all(8.0),
//               //         child: TextField(
//               //           cursorColor: Colors.black,
//               //           decoration: _inputDecoration(
//               //             'Enter ESN......',
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //     const SizedBox(width: 10),
//               //     ElevatedButton(
//               //       onPressed: () {},
//               //       child: Padding(
//               //         padding: const EdgeInsets.symmetric(
//               //             vertical: 12, horizontal: 16),
//               //         child: const Text("Validate",
//               //             style: TextStyle(color: Colors.white, fontSize: 18)),
//               //       ),
//               //       style: ElevatedButton.styleFrom(
//               //         backgroundColor: const Color(0xFF0055BB),
//               //         shape: const RoundedRectangleBorder(),
//               //       ),
//               //     ),
//               //     // This spacer pushes the remaining space to the right so the row doesn't stretch
//               //     const Spacer(flex: 2),
//               //   ],
//               // ),

//               // Assuming you have: final controller = Get.find<ESNController>();

// Row(
//   children: [
//     Text("ESN Validation :",
//         style: TextStyle(
//             fontSize: titleFontSize, fontWeight: FontWeight.bold)),
//     const SizedBox(width: 20),
//     Flexible(
//       flex: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextField(
//           controller: controller.esnTextFieldController, // Link the controller
//           cursorColor: Colors.black,
//           decoration: _inputDecoration('Enter ESN......'),
//         ),
//       ),
//     ),
//     const SizedBox(width: 10),

//     // --- VALIDATE BUTTON ---
//     ElevatedButton(
//       onPressed: () => controller.validateESN(),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF0055BB),
//         shape: const RoundedRectangleBorder(),
//       ),
//       child: const Padding(
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Text("Validate",
//             style: TextStyle(color: Colors.white, fontSize: 18)),
//       ),
//     ),

//     const SizedBox(width: 10),

//     // --- START TESTING BUTTON (Controlled by Obx) ---
//     Obx(() => ElevatedButton(
//       // If isValidated is false, onPressed is null (which disables the button)
//       onPressed: controller.isValidated.value
//           ? () { print("Starting Test..."); }
//           : null,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green.shade700,
//         disabledBackgroundColor: Colors.grey, // Color when disabled
//         shape: const RoundedRectangleBorder(),
//       ),
//       child: const Padding(
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Text("Start Testing",
//             style: TextStyle(color: Colors.white, fontSize: 18)),
//       ),
//     )),

//     const Spacer(flex: 2),
//   ],
// ),

//               const SizedBox(height: 30),

//               // --- 2. DEVICE INFO ROW (Serial, Variant, Model all in one row) ---
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildReadOnlyInfo("Serial Number", "SN-987654321",
//                         labelFontSize, valueFontSize),
//                   ),
//                   Expanded(
//                     child: _buildReadOnlyInfo("Variant Code", "V-B8_DIESEL",
//                         labelFontSize, valueFontSize),
//                   ),
//                   Expanded(
//                     child: _buildReadOnlyInfo("Model Number", "V-B8_DIESEL",
//                         labelFontSize, valueFontSize),
//                   ),
//                   // Expanded(
//                   //   child: Column(
//                   //     crossAxisAlignment: CrossAxisAlignment
//                   //         .end, // Align the whole block to the right
//                   //     children: [
//                   //       Center(
//                   //         child: Text(
//                   //           "Model Number",
//                   //           style: TextStyle(
//                   //             fontSize: labelFontSize,
//                   //             fontWeight: FontWeight.w600,
//                   //             color: const Color(0xFF64748B), // textLight color
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       const SizedBox(height: 8),
//                   //       Obx(() => DropdownButtonFormField<String>(
//                   //             value: controller.selectedModelIndex.value == -1
//                   //                 ? null
//                   //                 : controller.engineModels[controller
//                   //                     .selectedModelIndex.value]['name'],
//                   //             hint: Text(
//                   //               "Select Model",
//                   //               style: TextStyles.hintStyle,
//                   //             ),
//                   //             decoration: InputDecoration(
//                   //               filled: true,
//                   //               fillColor: Colors.white,
//                   //               contentPadding: const EdgeInsets.symmetric(
//                   //                   horizontal: 12, vertical: 8),
//                   //               border: OutlineInputBorder(
//                   //                 borderRadius: BorderRadius.circular(8),
//                   //                 borderSide: const BorderSide(
//                   //                     color: Color(0xFFE2E8F0)),
//                   //               ),
//                   //               enabledBorder: OutlineInputBorder(
//                   //                 borderRadius: BorderRadius.circular(8),
//                   //                 borderSide: const BorderSide(
//                   //                     color: Color(0xFFE2E8F0)),
//                   //               ),
//                   //               focusedBorder: OutlineInputBorder(
//                   //                 borderRadius: BorderRadius.circular(8),
//                   //                 borderSide: const BorderSide(
//                   //                     color: Color(0xFFE2E8F0)),
//                   //               ),
//                   //             ),
//                   //             style: TextStyles.textfieldTextStyle,
//                   //             icon: const Icon(
//                   //                 Icons.keyboard_arrow_down_rounded,
//                   //                 color: Color(0xFF0055BB)),
//                   //             items: controller.engineModels.map((model) {
//                   //               return DropdownMenuItem<String>(
//                   //                 value: model['name'],
//                   //                 child: Text(
//                   //                   model['name'],
//                   //                   textAlign: TextAlign.center,
//                   //                 ),
//                   //               );
//                   //             }).toList(),
//                   //             onChanged: (String? newValue) {
//                   //               if (newValue != null) {
//                   //                 // Find the index by name and update the controller
//                   //                 int index = controller.engineModels
//                   //                     .indexWhere((m) => m['name'] == newValue);
//                   //                 controller.selectedModelIndex.value = index;
//                   //               }
//                   //             },
//                   //           )),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               ),

//               const SizedBox(height: 40),

//               // --- 3. TEST STEPS SECTION ---
//               Text("Test Steps",
//                   style: TextStyle(
//                       fontSize: titleFontSize, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),

//               Container(
//                 decoration:
//                     BoxDecoration(border: Border.all(color: Colors.black12)),
//                 child: Table(
//                   columnWidths: const {
//                     0: FlexColumnWidth(1),
//                     1: FlexColumnWidth(4),
//                     2: FlexColumnWidth(1.5),
//                     3: FlexColumnWidth(1.5),
//                     4: FlexColumnWidth(1.5),
//                     5: FlexColumnWidth(2),
//                   },
//                   border: TableBorder.all(color: Colors.black12),
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: [
//                     TableRow(
//                       decoration: BoxDecoration(color: Colors.grey[200]),
//                       children: [
//                         _buildCell("Sr.",
//                             isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Component",
//                             isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Min",
//                             isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Max",
//                             isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Val",
//                             isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Result",
//                             isHeader: true, fontSize: tableCellFontSize),
//                       ],
//                     ),
//                     ...testSteps.map((step) => TableRow(
//                           children: [
//                             _buildCell(step['sr']!,
//                                 fontSize: tableCellFontSize),
//                             _buildCell(step['part']!,
//                                 fontSize: tableCellFontSize,
//                                 align: TextAlign.left),
//                             _buildCell("0", fontSize: tableCellFontSize),
//                             _buildCell("100", fontSize: tableCellFontSize),
//                             _buildCell("-", fontSize: tableCellFontSize),
//                             _buildStatusBadge(
//                                 step['status']!, tableCellFontSize),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

<<<<<<< HEAD
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/testingController.dart';
=======
// import 'package:autopeepal/logic/controller/dashboard/testingController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';

// class TestingScreen extends StatelessWidget {
//   TestingScreen({super.key});

//   // FIX: Use lazyPut or ensure the type is explicit to avoid the DashboardController conflict
//   final ESNController controller = Get.put(ESNController());

//   final List<Map<String, String>> testSteps = [
//     {"sr": "1", "part": "Crankshaft RPM", "status": "OK"},
//     {"sr": "2", "part": "Temp Coolant", "status": "NOT OK"},
//     {"sr": "3", "part": "Charge Air Temp", "status": "OK"},
//     {"sr": "4", "part": "Fuel Rail Pres", "status": "OK"},
//     {"sr": "5", "part": "Adjuster MPROP", "status": "OK"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     final double titleFontSize = isDesktop ? 22 : 18;
//     final double labelFontSize = isDesktop ? 18 : 14;
//     final double valueFontSize = isDesktop ? 17 : 14;
//     final double tableCellFontSize = isDesktop ? 16 : 13;

//     return SafeArea(
//       child: MainLayout(
//         title: "ATPL Diagnostic Tool",
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(isDesktop ? 30 : 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- 1. ESN VALIDATION SECTION ---
//               Row(
//                 children: [
//                   Text("ESN Validation :",
//                       style: TextStyle(
//                           fontSize: titleFontSize,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(width: 20),
//                   Flexible(
//                     flex: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         controller: controller.esnTextFieldController, // Linked
//                         cursorColor: Colors.black,
//                         decoration: _inputDecoration('Enter ESN......'),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),

//                   // --- VALIDATE BUTTON ---
//                   ElevatedButton(
//                     onPressed: () => controller.validateESN(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0055BB),
//                       shape: const RoundedRectangleBorder(),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       child: Text("Validate",
//                           style: TextStyle(color: Colors.white, fontSize: 18)),
//                     ),
//                   ),

//                   const SizedBox(width: 10),

//                   // --- START TESTING BUTTON ---
//                   Obx(() => ElevatedButton(
//                     onPressed: controller.isValidated.value
//                         ? () { /* Start test logic here */ }
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade700,
//                       disabledBackgroundColor: Colors.grey.shade300,
//                       shape: const RoundedRectangleBorder(),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       child: Text("Start Testing",
//                           style: TextStyle(
//                             color: controller.isValidated.value ? Colors.white : Colors.grey.shade600,
//                             fontSize: 18
//                           )),
//                     ),
//                   )),

//                   const Spacer(flex: 2),
//                 ],
//               ),

//               const SizedBox(height: 30),

//               // --- 2. DEVICE INFO ROW ---
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildReadOnlyInfo("Serial Number", "SN-987654321",
//                         labelFontSize, valueFontSize),
//                   ),
//                   Expanded(
//                     child: _buildReadOnlyInfo("Variant Code", "V-B8_DIESEL",
//                         labelFontSize, valueFontSize),
//                   ),
//                   Expanded(
//                     child: _buildReadOnlyInfo("Model Number", "V-B8_DIESEL",
//                         labelFontSize, valueFontSize),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 40),

//               // --- 3. TEST STEPS SECTION ---
//               Text("Test Steps",
//                   style: TextStyle(
//                       fontSize: titleFontSize, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),

//               Container(
//                 decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
//                 child: Table(
//                   columnWidths: const {
//                     0: FlexColumnWidth(1),
//                     1: FlexColumnWidth(4),
//                     2: FlexColumnWidth(1.5),
//                     3: FlexColumnWidth(1.5),
//                     4: FlexColumnWidth(1.5),
//                     5: FlexColumnWidth(2),
//                   },
//                   border: TableBorder.all(color: Colors.black12),
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: [
//                     TableRow(
//                       decoration: BoxDecoration(color: Colors.grey[200]),
//                       children: [
//                         _buildCell("Sr.", isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Component", isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Min", isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Max", isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Val", isHeader: true, fontSize: tableCellFontSize),
//                         _buildCell("Result", isHeader: true, fontSize: tableCellFontSize),
//                       ],
//                     ),
//                     ...testSteps.map((step) => TableRow(
//                           children: [
//                             _buildCell(step['sr']!, fontSize: tableCellFontSize),
//                             _buildCell(step['part']!,
//                                 fontSize: tableCellFontSize, align: TextAlign.left),
//                             _buildCell("0", fontSize: tableCellFontSize),
//                             _buildCell("100", fontSize: tableCellFontSize),
//                             _buildCell("-", fontSize: tableCellFontSize),
//                             _buildStatusBadge(step['status']!, tableCellFontSize),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper for consistent info labels
//   Widget _buildReadOnlyInfo(
//       String label, String value, double labelSize, double valueSize,
//       {bool alignRight = false}) {
//     return Column(
//       crossAxisAlignment:
//           alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           label.toUpperCase(),
//           style: TextStyle(
//             fontSize: labelSize - 5,
//             fontWeight: FontWeight.bold,
//             color: Colors.blueGrey,
//             letterSpacing: 1.1,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: valueSize,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }

//   // Helper for Table Result status
//   Widget _buildStatusBadge(String status, double fontSize) {
//     bool isOk = status == "OK";
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//         decoration: BoxDecoration(
//           color: isOk
//               ? Colors.green.withOpacity(0.1)
//               : Colors.red.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Text(
//           status,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: fontSize - 2,
//             fontWeight: FontWeight.bold,
//             color: isOk ? Colors.green[800] : Colors.red[800],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCell(String text,
//       {required double fontSize,
//       bool isHeader = false,
//       TextAlign align = TextAlign.center}) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(
//         text,
//         textAlign: align,
//         style: TextStyle(
//           fontSize: fontSize,
//           fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//           color: isHeader ? Colors.black : Colors.black87,
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.blueGrey.withOpacity(0.03),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
//       ),
//     );
//   }
// }
import 'package:autopeepal/logic/controller/dashboard/testingController.dart';
>>>>>>> ac6a0938d8b7d5df553380c71a651200540d794f
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:CP_TMTL_Sensor_Zig/views/screens/dashboard/mainLayoutScreen.dart';

class TestingScreen extends StatelessWidget {
  TestingScreen({super.key});

  final ESNController controller = Get.put(ESNController());

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    final double titleFontSize = isDesktop ? 22 : 18;
    final double labelFontSize = isDesktop ? 18 : 14;
    final double valueFontSize = isDesktop ? 17 : 14;
    final double tableCellFontSize = isDesktop ? 16 : 13;

    return SafeArea(
      child: MainLayout(
        title: "ATPL Diagnostic Tool",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 30 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. ESN VALIDATION SECTION ---
              Row(
                children: [
                  // Text("ESN Validation :",
                  //     style: TextStyle(
                  //         fontSize: titleFontSize,
                  //         fontWeight: FontWeight.bold)),
                  // const SizedBox(width: 20),
                  // Flexible(
                  //   flex: 3,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: TextField(
                  //       controller: controller.esnTextFieldController,
                  //       cursorColor: Colors.black,
                  //       decoration: _inputDecoration('Enter ESN......'),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),

                  // ElevatedButton(
                  //   onPressed: () => controller.validateESN(),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF0055BB),
                  //     shape: const RoundedRectangleBorder(),
                  //   ),
                  //   child: const Padding(
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  //     child: Text("Validate",
                  //         style: TextStyle(color: Colors.white, fontSize: 18)),
                  //   ),
                  // ),
                  Text(
                    "ESN Validation :",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 3,
                    child: GetBuilder<ESNController>(
                      // MUST use GetBuilder
                      builder: (controller) {
                        return TextField(
                          controller: controller.esnTextFieldController,
                          //focusNode: controller.esnFocusNode,
                          //onSubmitted: (value) => controller.handleBarcodeSubmit(value),
                          decoration:
                              _inputDecoration('Enter ESN......').copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.qr_code_scanner,
                                  color: Color(0xFF0055BB)),
                              onPressed: () {
                                // Close keyboard and open camera
                                // controller.esnFocusNode.unfocus();
                                controller.sc();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => controller.validateESN(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055BB),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Text(
                          "Validate",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),

                  const SizedBox(width: 10),

                  // --- START TESTING BUTTON ---
                  Obx(() => ElevatedButton(
                        onPressed: controller.isValidated.value &&
                                !controller.isTesting.value
                            ? () => controller.startTestingSequence()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Text(
                            controller.isTesting.value
                                ? "Testing..."
                                : "Start Testing",
                            style: TextStyle(
                                color: controller.isValidated.value
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 18),
                          ),
                        ),
                      )),
                ],
              ),

              const SizedBox(height: 30),

              // --- 2. DEVICE INFO ROW (Reactive) ---
              Obx(() => Row(
                    children: [
                      Expanded(
                          child: _buildReadOnlyInfo(
                              "Serial Number",
                              controller.serialNumber.value,
                              labelFontSize,
                              valueFontSize)),
                      Expanded(
                          child: _buildReadOnlyInfo(
                              "Variant Code",
                              controller.variantCode.value,
                              labelFontSize,
                              valueFontSize)),
                      Expanded(
                          child: _buildReadOnlyInfo(
                              "Model Number",
                              controller.modelNumber.value,
                              labelFontSize,
                              valueFontSize)),
                    ],
                  )),

              const SizedBox(height: 40),

              // --- 3. TEST STEPS SECTION (Sequential Loop) ---
              Text("Test Steps",
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              Obx(() => Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1), // Sr.
                      1: FlexColumnWidth(4), // Component
                      2: FlexColumnWidth(1.5), // Min
                      3: FlexColumnWidth(1.5), // Max
                      //4: FlexColumnWidth(1.5), // Val
                      5: FlexColumnWidth(2), // Result
                    },
                    border: TableBorder.all(color: Colors.black12),
                    children: [
                      // 1. HEADER ROW (Total 6 children)
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          _buildCell("Sr.",
                              isHeader: true, fontSize: tableCellFontSize),
                          _buildCell("Component",
                              isHeader: true, fontSize: tableCellFontSize),
                          _buildCell("Min",
                              isHeader: true, fontSize: tableCellFontSize),
                          _buildCell("Max",
                              isHeader: true, fontSize: tableCellFontSize),
                          // _buildCell("Val",
                          //     isHeader: true, fontSize: tableCellFontSize),
                          _buildCell("Result",
                              isHeader: true, fontSize: tableCellFontSize),
                        ],
                      ),

                      // 2. DATA ROWS (Must also have exactly 6 children)
                      ...controller.sensorResults.map((sensor) {
                        return TableRow(
                          children: [
                            _buildCell(sensor['sr'].toString(),
                                fontSize: tableCellFontSize), // 1
                            _buildCell(sensor['part'],
                                fontSize: tableCellFontSize,
                                align: TextAlign.left), // 2
                            _buildCell(sensor['min'].toString(),
                                fontSize: tableCellFontSize), // 3
                            _buildCell(sensor['max'].toString(),
                                fontSize: tableCellFontSize), // 4
                            // _buildCell(sensor['val'].toString(),
                            //     fontSize: tableCellFontSize), // 5
                            _buildStatusBadge(
                                sensor['status'], tableCellFontSize), // 6
                          ],
                        );
                      }).toList(),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable UI Components ---

  Widget _buildReadOnlyInfo(
      String label, String value, double labelSize, double valueSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: labelSize - 5,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildStatusBadge(String status, double fontSize) {
    Color bgColor = Colors.grey.withOpacity(0.1);
    Color textColor = Colors.grey;

    if (status == "OK") {
      bgColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green.shade800;
    } else if (status == "NOT OK" || status == "TIMEOUT") {
      bgColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red.shade800;
    } else if (status == "TESTING...") {
      bgColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue.shade800;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(4)),
        child: Text(status,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSize - 2,
                fontWeight: FontWeight.bold,
                color: textColor)),
      ),
    );
  }

  Widget _buildCell(String text,
      {required double fontSize,
      bool isHeader = false,
      TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(text,
            textAlign: align,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.blueGrey.withOpacity(0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2)),
    );
  }
}
