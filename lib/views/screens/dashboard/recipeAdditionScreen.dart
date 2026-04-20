// import 'package:autopeepal/logic/controller/dashboard/AddrecipeController.dart';
// import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RecipeAdditionScreen extends StatelessWidget {
//   RecipeAdditionScreen({super.key});
//   final AddRecipeController controller = Get.put(AddRecipeController());

//   // 1. Add Form Keys for validation
//   final _engineFormKey = GlobalKey<FormState>();
//   final _sensorFormKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     final double headerFontSize = isDesktop ? 20 : 18;
//     final double labelFontSize = isDesktop ? 20 : 14;
//     final double inputFontSize = isDesktop ? 16 : 14;
//     final double tableHeaderFontSize = isDesktop ? 20 : 13;
//     final double tableCellFontSize = isDesktop ? 16 : 12;

//     return SafeArea(
//       child: MainLayout(
//         title: "Recipe Configuration",
//         showDrawer: false,
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//                 horizontal: isDesktop ? 40 : 16, vertical: 30),
//             child: SizedBox(
//               width: double.infinity,
//               // 2. Wrap the main content in a Form for Engine Details
//               child: Form(
//                 key: _engineFormKey,
//                 child: Column(
//                   children: [
//                     _buildSectionHeader(
//                       "Engine Details",
//                       fontSize: headerFontSize,
//                       trailing: OutlinedButton.icon(
//                         onPressed: () => controller.importRecipes(),
//                         icon: Icon(Icons.file_upload_outlined,
//                             size: isDesktop ? 20 : 18),
//                         label: Text("Import JSON",
//                             style: TextStyle(fontSize: labelFontSize)),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: const Color(0xFF0055BB),
//                           side: const BorderSide(color: Color(0xFF0055BB)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildResponsiveGrid(isDesktop, [
//                       _buildInputField("Engine Model Number", "e.g. 6BT-5.9",
//                           labelSize: labelFontSize,
//                           textSize: inputFontSize,
//                           controller: controller.modelController.value),
//                       _buildInputField("Engine Type", "e.g. Diesel",
//                           labelSize: labelFontSize,
//                           textSize: inputFontSize,
//                           controller: controller.typeController.value),
//                     ]),

//                     const SizedBox(height: 40),

//                     _buildSectionHeader(
//                       "Added Sensor List",
//                       fontSize: headerFontSize,
//                       trailing: Obx(() => !controller.isAddingSensor.value
//                           ? ElevatedButton.icon(
//                               onPressed: () =>
//                                   controller.isAddingSensor.value = true,
//                               icon: Icon(Icons.add, size: isDesktop ? 20 : 18),
//                               label: Text("Add New Sensor",
//                                   style: TextStyle(fontSize: labelFontSize)),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF0055BB),
//                                   foregroundColor: Colors.white),
//                             )
//                           : TextButton(
//                               onPressed: () =>
//                                   controller.isAddingSensor.value = false,
//                               child: Text("Cancel",
//                                   style: TextStyle(
//                                       fontSize: labelFontSize,
//                                       color: Colors.red)),
//                             )),
//                     ),
//                     const SizedBox(height: 10),

//                     Obx(() => controller.addedSensors.isEmpty
//                         ? const Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text("No sensors added yet.",
//                                 style: TextStyle(color: Colors.grey)),
//                           )
//                         : Container(
//                             width: double.infinity,
//                             margin: const EdgeInsets.only(bottom: 20),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: DataTable(
//                               headingRowColor:
//                                   WidgetStateProperty.all(Colors.grey[100]),
//                               columns: [
//                                 DataColumn(
//                                     label: Text('Name',
//                                         style: TextStyle(
//                                             fontSize: tableHeaderFontSize,
//                                             fontWeight: FontWeight.bold))),
//                                 DataColumn(
//                                     label: Text('Type',
//                                         style: TextStyle(
//                                             fontSize: tableHeaderFontSize,
//                                             fontWeight: FontWeight.bold))),
//                                 DataColumn(
//                                     label: Text('Register',
//                                         style: TextStyle(
//                                             fontSize: tableHeaderFontSize,
//                                             fontWeight: FontWeight.bold))),
//                                 DataColumn(
//                                     label: Text('Range',
//                                         style: TextStyle(
//                                             fontSize: tableHeaderFontSize,
//                                             fontWeight: FontWeight.bold))),
//                                 DataColumn(
//                                     label: Text('Action',
//                                         style: TextStyle(
//                                             fontSize: tableHeaderFontSize,
//                                             fontWeight: FontWeight.bold))),
//                               ],
//                               rows: controller.addedSensors.map((sensor) {
//                                 return DataRow(cells: [
//                                   DataCell(Text(sensor.sensorName ?? '',
//                                       style: TextStyle(
//                                           fontSize: tableCellFontSize))),
//                                   DataCell(Text(sensor.sensorType ?? '',
//                                       style: TextStyle(
//                                           fontSize: tableCellFontSize))),
//                                   DataCell(Text(
//                                       sensor.registerNumber.toString(),
//                                       style: TextStyle(
//                                           fontSize: tableCellFontSize))),
//                                   DataCell(Text("${sensor.min} / ${sensor.max}",
//                                       style: TextStyle(
//                                           fontSize: tableCellFontSize))),
//                                   DataCell(
//                                     Row(
//                                       mainAxisSize: MainAxisSize
//                                           .min, // Keep buttons tight
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.edit_outlined,
//                                               color: Colors.blue,
//                                               size: isDesktop ? 22 : 20),
//                                           onPressed: () => controller.editSensor(
//                                               sensor), // Pulls data back to form
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.delete_outline,
//                                               color: Colors.red,
//                                               size: isDesktop ? 22 : 20),
//                                           onPressed: () => controller
//                                               .addedSensors
//                                               .remove(sensor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ]);
//                               }).toList(),
//                             ),
//                           )),

//                     // --- SENSOR CONFIGURATION (Form) ---
//                     Obx(() => AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 300),
//                           child: controller.isAddingSensor.value
//                               ? Form(
//                                   key:
//                                       _sensorFormKey, // 3. Separate key for Sensor Form
//                                   child: Column(
//                                     key: const ValueKey("ConfigForm"),
//                                     children: [
//                                       const SizedBox(height: 20),
//                                       _buildSectionHeader(
//                                           "Configure New Sensor",
//                                           fontSize: headerFontSize),
//                                       const SizedBox(height: 20),
//                                       _buildResponsiveGrid(isDesktop, [
//                                         _buildInputField(
//                                             "Sensor Name", "e.g. Oil Pressure",
//                                             labelSize: labelFontSize,
//                                             textSize: inputFontSize,
//                                             controller:
//                                                 controller.sensorName.value),
//                                         _buildInputField(
//                                             "Sensor Type", "e.g. Analog",
//                                             labelSize: labelFontSize,
//                                             textSize: inputFontSize,
//                                             controller:
//                                                 controller.sensorType.value),
//                                       ]),
//                                       const SizedBox(height: 20),
//                                       _buildResponsiveGrid(isDesktop, [
//                                         _buildInputField(
//                                             "Register Address", "0x00",
//                                             isNumeric: true,
//                                             labelSize: labelFontSize,
//                                             textSize: inputFontSize,
//                                             controller: controller
//                                                 .registerNumber.value),
//                                         _buildMinMaxField(isDesktop,
//                                             labelFontSize, inputFontSize),
//                                       ]),
//                                       const SizedBox(height: 20),
//                                       _buildResponsiveGrid(isDesktop, [
//                                         _buildInputField("Multiplier", "1.0",
//                                             isNumeric: true,
//                                             labelSize: labelFontSize,
//                                             textSize: inputFontSize,
//                                             controller:
//                                                 controller.multiplier.value),
//                                         _buildInputField("Offset", "0",
//                                             isNumeric: true,
//                                             labelSize: labelFontSize,
//                                             textSize: inputFontSize,
//                                             controller:
//                                                 controller.offset.value),
//                                       ]),
//                                       const SizedBox(height: 20),
//                                       // _buildResponsiveGrid(isDesktop, [
//                                       //   _buildInputField(
//                                       //     "Unit",
//                                       //     "Ohms",
//                                       //     labelSize: labelFontSize,
//                                       //     textSize: inputFontSize,
//                                       //     controller: controller.unit.value,
//                                       //   ),
//                                       //   // In RecipeAdditionScreen
//                                       //   _buildInputField(
//                                       //     "Test Result",
//                                       //     "Calculated automatically",
//                                       //     labelSize: labelFontSize,
//                                       //     textSize: inputFontSize,
//                                       //     controller:
//                                       //         controller.testResult.value,
//                                       //         readOnly: true
//                                       //     // Add this property to your helper method
//                                       //   ),
//                                       // ]
//                                       //),
//                                       // Inside _buildResponsiveGrid for the sensor fields
//                                       _buildResponsiveGrid(isDesktop, [
//                                         _buildInputField(
//                                           "Unit",
//                                           "e.g. Ohms",
//                                           labelSize: labelFontSize,
//                                           textSize: inputFontSize,
//                                           controller: controller.unit.value,
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text("Test Result",
//                                                 style: TextStyle(
//                                                     fontSize: labelFontSize,
//                                                     fontWeight:
//                                                         FontWeight.w600)),
//                                             const SizedBox(height: 8),
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: _buildInputFieldNoLabel(
//                                                       "Result",
//                                                       inputFontSize,
//                                                       controller
//                                                           .testResult.value,
//                                                       "Test Result",
//                                                       AutovalidateMode
//                                                           .onUserInteraction),
//                                                 ),
//                                                 const SizedBox(width: 10),
//                                                 // --- THE HIT BUTTON ---
//                                                 ElevatedButton(
//                                                   onPressed: () {
//                                                     int reg = int.tryParse(
//                                                             controller
//                                                                 .registerNumber
//                                                                 .value
//                                                                 .text) ??
//                                                         0;

//                                                     // Clear the field so the technician knows a new poll started
//                                                     controller.testResult.value
//                                                         .text = "Polling...";

//                                                     // 🔥 Trigger the real Modbus request
//                                                     controller
//                                                         .sendGeneratorDataRequest(
//                                                             reg);

//                                                     print(
//                                                         "User clicked HIT for register: $reg");
//                                                   },
//                                                   style: ElevatedButton.styleFrom(
//                                                       backgroundColor:
//                                                           Colors.orange,
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           vertical: 18,
//                                                           horizontal: 15),
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10))),
//                                                   child: const Text("Test",
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ]),
//                                       const SizedBox(height: 30),
//                                       // Align(
//                                       //   alignment: Alignment.centerRight,
//                                       //   child: ElevatedButton.icon(
//                                       //     onPressed: () {
//                                       //       // 4. Validate Sensor Form before saving
//                                       //       if (_sensorFormKey.currentState!
//                                       //           .validate()) {
//                                       //         controller.saveSensorToList();
//                                       //         controller.isAddingSensor.value =
//                                       //             false;
//                                       //       }
//                                       //     },
//                                       //     icon: const Icon(Icons.check),
//                                       //     label: Text("Save Sensor to Table",
//                                       //         style: TextStyle(
//                                       //             fontSize: labelFontSize)),
//                                       //     style: ElevatedButton.styleFrom(
//                                       //         backgroundColor:
//                                       //             Colors.green[700],
//                                       //         foregroundColor: Colors.white,
//                                       //         padding:
//                                       //             const EdgeInsets.symmetric(
//                                       //                 horizontal: 24,
//                                       //                 vertical: 12)),
//                                       //   ),
//                                       // ),
//                                       Obx(
//                                         () => controller.hasTested.value
//                                             ? Align(
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: ElevatedButton.icon(
//                                                   onPressed: () {
//                                                     if (_sensorFormKey
//                                                         .currentState!
//                                                         .validate()) {
//                                                       controller
//                                                           .saveSensorToList();
//                                                       controller.isAddingSensor
//                                                           .value = false;
//                                                     }
//                                                   },
//                                                   icon: const Icon(Icons.check),
//                                                   label: Text(
//                                                       "Save Sensor to Table",
//                                                       style: TextStyle(
//                                                           fontSize:
//                                                               labelFontSize)),
//                                                   style: ElevatedButton.styleFrom(
//                                                       backgroundColor:
//                                                           Colors.green[700],
//                                                       foregroundColor:
//                                                           Colors.white,
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 24,
//                                                           vertical: 12)),
//                                                 ),
//                                               )
//                                             : const SizedBox
//                                                 .shrink(), // Hides the button completely
//                                       ),
//                                       const Divider(height: 60),
//                                     ],
//                                   ),
//                                 )
//                               : const SizedBox.shrink(),
//                         )),

//                     const SizedBox(height: 60),

//                     // FINAL ACTION BUTTONS
//                     Row(
//                       mainAxisAlignment: isDesktop
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.center,
//                       children: [
//                         OutlinedButton(
//                           onPressed: () => Get.back(),
//                           style: OutlinedButton.styleFrom(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: isDesktop ? 50 : 40, vertical: 20),
//                             side: const BorderSide(color: Colors.grey),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8)),
//                           ),
//                           child: Text("Cancel",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: isDesktop ? 18 : 16)),
//                         ),
//                         const SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             // 5. Final validation check
//                             if (_engineFormKey.currentState!.validate()) {
//                               controller.addRecipe();
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4A76C0),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: isDesktop ? 60 : 50, vertical: 20),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8)),
//                           ),
//                           child: Text("Add Recipe",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: isDesktop ? 18 : 16)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Helper methods remain mostly same, logic for validation is inside TextFormField ---

//   Widget _buildSectionHeader(String title,
//       {required double fontSize, Widget? trailing}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(title,
//                 style: TextStyle(
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF0055BB))),
//             if (trailing != null) trailing,
//           ],
//         ),
//         const Divider(thickness: 1),
//       ],
//     );
//   }

//   Widget _buildResponsiveGrid(bool isDesktop, List<Widget> children) {
//     return Wrap(
//       spacing: 30,
//       runSpacing: 20,
//       children: children
//           .map((w) => SizedBox(
//                 width: isDesktop
//                     ? (MediaQuery.of(Get.context!).size.width / 2) - 60
//                     : double.infinity,
//                 child: w,
//               ))
//           .toList(),
//     );
//   }

//   Widget _buildInputField(
//     String label,
//     String hint, {
//     required double labelSize,
//     required double textSize,
//     bool isNumeric = false,
//     bool readOnly = false, // Added this parameter
//     TextEditingController? controller,
//     AutovalidateMode autovalidatemode = AutovalidateMode.onUserInteraction,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: labelSize,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           readOnly: readOnly, // Set the readOnly property here
//           cursorColor: Colors.black,
//           autovalidateMode: autovalidatemode,
//           controller: controller,
//           // Optional: Change background color if readOnly to indicate it's disabled
//           style: TextStyle(
//             color: readOnly ? Colors.blueGrey : Colors.black,
//             fontWeight: readOnly ? FontWeight.bold : FontWeight.normal,
//           ),
//           keyboardType: isNumeric
//               ? const TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return "$label is required";
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: TextStyle(fontSize: textSize, color: Colors.grey),
//             filled: true,
//             fillColor: readOnly
//                 ? Colors.grey[200]
//                 : Colors.grey[50], // Grey out if readOnly
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: Colors.black26),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: readOnly ? Colors.black26 : Colors.blue,
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMinMaxField(bool isDesktop, double labelSize, double textSize) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Range (Min / Max)",
//             style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         Row(
//           crossAxisAlignment:
//               CrossAxisAlignment.start, // Align for error messages
//           children: [
//             Expanded(
//               child: _buildInputFieldNoLabel(
//                   "Min",
//                   textSize,
//                   controller.min.value,
//                   "Min",
//                   AutovalidateMode.onUserInteraction),
//             ),
//             const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                 child: Text("/")),
//             Expanded(
//               child: _buildInputFieldNoLabel(
//                   "Max",
//                   textSize,
//                   controller.max.value,
//                   "Max",
//                   AutovalidateMode.onUserInteraction),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInputFieldNoLabel(
//       String hint,
//       double textSize,
//       TextEditingController? controller,
//       String fieldName,
//       AutovalidateMode autovalidatemode) {
//     return TextFormField(
//       autovalidateMode: autovalidatemode,
//       controller: controller,
//       keyboardType: const TextInputType.numberWithOptions(decimal: true),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return "$fieldName required";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey[50],
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 10,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.black26),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red, width: 1),
//         ),
//       ),
//     );
//   }
// }
import 'package:autopeepal/logic/controller/dashboard/AddrecipeController.dart';
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeAdditionScreen extends StatelessWidget {
  RecipeAdditionScreen({super.key});
  final AddRecipeController controller = Get.put(AddRecipeController());

  final _engineFormKey = GlobalKey<FormState>();
  final _sensorFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    final double headerFontSize = isDesktop ? 20 : 18;
    final double labelFontSize = isDesktop ? 20 : 14;
    final double inputFontSize = isDesktop ? 16 : 14;
    final double tableHeaderFontSize = isDesktop ? 20 : 13;
    final double tableCellFontSize = isDesktop ? 16 : 12;

    return SafeArea(
      child: MainLayout(
        title: "Recipe Configuration",
        showDrawer: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 16, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: _engineFormKey,
                child: Column(
                  children: [
                    // --- SECTION 1: ENGINE DETAILS ---
                    _buildSectionHeader(
                      "Engine Details",
                      fontSize: headerFontSize,
                      trailing: OutlinedButton.icon(
                        onPressed: () => controller.importRecipes(),
                        icon: Icon(Icons.file_upload_outlined,
                            size: isDesktop ? 20 : 18),
                        label: Text("Import JSON",
                            style: TextStyle(fontSize: labelFontSize)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0055BB),
                          side: const BorderSide(color: Color(0xFF0055BB)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildResponsiveGrid(isDesktop, [
                      _buildInputField("Engine Model Number", "e.g. 6BT-5.9",
                          labelSize: labelFontSize,
                          textSize: inputFontSize,
                          controller: controller.modelController.value),
                      _buildInputField("Engine Type", "e.g. Diesel",
                          labelSize: labelFontSize,
                          textSize: inputFontSize,
                          controller: controller.typeController.value),
                    ]),

                    const SizedBox(height: 40),

                    // --- SECTION 2: SENSOR LIST ---
                    _buildSectionHeader(
                      "Added Sensor List",
                      fontSize: headerFontSize,
                      trailing: Obx(() => !controller.isAddingSensor.value
                          ? ElevatedButton.icon(
                              onPressed: () =>
                                  controller.isAddingSensor.value = true,
                              icon: Icon(Icons.add, size: isDesktop ? 20 : 18),
                              label: Text("Add New Sensor",
                                  style: TextStyle(fontSize: labelFontSize)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0055BB),
                                  foregroundColor: Colors.white),
                            )
                          : TextButton(
                              onPressed: () =>
                                  controller.isAddingSensor.value = false,
                              child: Text("Cancel",
                                  style: TextStyle(
                                      fontSize: labelFontSize,
                                      color: Colors.red)),
                            )),
                    ),
                    const SizedBox(height: 10),

                    Obx(() => controller.addedSensors.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("No sensors added yet.",
                                style: TextStyle(color: Colors.grey)),
                          )
                        : Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DataTable(
                              headingRowColor:
                                  WidgetStateProperty.all(Colors.grey[100]),
                              columns: [
                                DataColumn(label: Text('Name', style: TextStyle(fontSize: tableHeaderFontSize, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Type', style: TextStyle(fontSize: tableHeaderFontSize, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Register', style: TextStyle(fontSize: tableHeaderFontSize, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Range', style: TextStyle(fontSize: tableHeaderFontSize, fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Action', style: TextStyle(fontSize: tableHeaderFontSize, fontWeight: FontWeight.bold))),
                              ],
                              rows: controller.addedSensors.map((sensor) {
                                return DataRow(cells: [
                                  DataCell(Text(sensor.sensorName ?? '', style: TextStyle(fontSize: tableCellFontSize))),
                                  DataCell(Text(sensor.sensorType ?? '', style: TextStyle(fontSize: tableCellFontSize))),
                                  DataCell(Text(sensor.registerNumber.toString(), style: TextStyle(fontSize: tableCellFontSize))),
                                  DataCell(Text("${sensor.min} / ${sensor.max}", style: TextStyle(fontSize: tableCellFontSize))),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined, color: Colors.blue, size: isDesktop ? 22 : 20),
                                        onPressed: () => controller.editSensor(sensor),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, color: Colors.red, size: isDesktop ? 22 : 20),
                                        onPressed: () => controller.addedSensors.remove(sensor),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          )),

                    // --- SECTION 3: SENSOR CONFIGURATION FORM ---
                    Obx(() => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: controller.isAddingSensor.value
                              ? Form(
                                  key: _sensorFormKey,
                                  child: Column(
                                    key: const ValueKey("ConfigForm"),
                                    children: [
                                      const SizedBox(height: 20),
                                      _buildSectionHeader("Configure New Sensor", fontSize: headerFontSize),
                                      const SizedBox(height: 20),
                                      _buildResponsiveGrid(isDesktop, [
                                        _buildInputField("Sensor Name", "e.g. Oil Pressure",
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.sensorName.value),
                                        _buildInputField("Sensor Type", "e.g. Analog",
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.sensorType.value),
                                      ]),
                                      const SizedBox(height: 20),
                                      _buildResponsiveGrid(isDesktop, [
                                        _buildInputField("Register Address", "0x00",
                                            isNumeric: true,
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.registerNumber.value),
                                        _buildMinMaxField(isDesktop, labelFontSize, inputFontSize),
                                      ]),
                                      const SizedBox(height: 20),
                                      _buildResponsiveGrid(isDesktop, [
                                        _buildInputField("Multiplier", "1.0",
                                            isNumeric: true,
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.multiplier.value),
                                        _buildInputField("Offset", "0",
                                            isNumeric: true,
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.offset.value),
                                      ]),
                                      const SizedBox(height: 20),
                                      _buildResponsiveGrid(isDesktop, [
                                        _buildInputField("Unit", "e.g. Ohms",
                                            labelSize: labelFontSize,
                                            textSize: inputFontSize,
                                            controller: controller.unit.value),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Sensor Test / Operation",
                                                style: TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildInputFieldNoLabel(
                                                      "Result",
                                                      inputFontSize,
                                                      controller.testResult.value,
                                                      "Test Result",
                                                      AutovalidateMode.onUserInteraction),
                                                ),
                                                const SizedBox(width: 10),
                                                // --- READ BUTTON ---
                                                ElevatedButton(
                                                  onPressed: () {
                                                    int reg = int.tryParse(controller.registerNumber.value.text) ?? 0;
                                                    controller.testResult.value.text = "Reading...";
                                                    controller.sendGeneratorDataRequest1(reg);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFF0055BB),
                                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                  child: const Text("Read", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                ),
                                                const SizedBox(width: 8),
                                                // --- WRITE BUTTON ---
                                                ElevatedButton(
                                                  onPressed: () {
                                                    int reg = int.tryParse(controller.registerNumber.value.text) ?? 0;
                                                    int val = int.tryParse(controller.testResult.value.text) ?? 0;
                                                    controller.testResult.value.text = "Writing...";
                                                    // Make sure to add this method in your controller
                                                     controller.writeGeneratorDataRequest(reg, val);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.orange.shade800,
                                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                  child: const Text("Write", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                      const SizedBox(height: 30),
                                      
                                      // --- SAVE BUTTON ---
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            if (_sensorFormKey.currentState!.validate()) {
                                              controller.saveSensorToList();
                                              controller.isAddingSensor.value = false;
                                            }
                                          },
                                          icon: const Icon(Icons.check),
                                          label: Text("Save Sensor to Table", style: TextStyle(fontSize: labelFontSize)),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green[700],
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                        ),
                                      ),
                                      const Divider(height: 60),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )),

                    const SizedBox(height: 60),

                    // --- FINAL ACTION BUTTONS ---
                    Row(
                      mainAxisAlignment: isDesktop ? MainAxisAlignment.end : MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 40, vertical: 20),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: isDesktop ? 18 : 16)),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_engineFormKey.currentState!.validate()) {
                              controller.addRecipe();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A76C0),
                            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 50, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("Add Recipe", style: TextStyle(color: Colors.white, fontSize: isDesktop ? 18 : 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPERS (STAY THE SAME) ---

  Widget _buildSectionHeader(String title, {required double fontSize, Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xFF0055BB))),
            if (trailing != null) trailing,
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildResponsiveGrid(bool isDesktop, List<Widget> children) {
    return Wrap(
      spacing: 30,
      runSpacing: 20,
      children: children.map((w) => SizedBox(
                width: isDesktop ? (MediaQuery.of(Get.context!).size.width / 2) - 60 : double.infinity,
                child: w,
              )).toList(),
    );
  }

  Widget _buildInputField(String label, String hint, {required double labelSize, required double textSize, bool isNumeric = false, bool readOnly = false, TextEditingController? controller, AutovalidateMode autovalidatemode = AutovalidateMode.onUserInteraction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          cursorColor: Colors.black,
          autovalidateMode: autovalidatemode,
          controller: controller,
          style: TextStyle(color: readOnly ? Colors.blueGrey : Colors.black, fontWeight: readOnly ? FontWeight.bold : FontWeight.normal),
          keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          validator: (value) => (value == null || value.trim().isEmpty) ? "$label is required" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: textSize, color: Colors.grey),
            filled: true,
            fillColor: readOnly ? Colors.grey[200] : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: readOnly ? Colors.black26 : Colors.blue, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildMinMaxField(bool isDesktop, double labelSize, double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Range (Min / Max)", style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInputFieldNoLabel("Min", textSize, controller.min.value, "Min", AutovalidateMode.onUserInteraction)),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), child: Text("/")),
            Expanded(child: _buildInputFieldNoLabel("Max", textSize, controller.max.value, "Max", AutovalidateMode.onUserInteraction)),
          ],
        ),
      ],
    );
  }

  Widget _buildInputFieldNoLabel(String hint, double textSize, TextEditingController? controller, String fieldName, AutovalidateMode autovalidatemode) {
    return TextFormField(
      autovalidateMode: autovalidatemode,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) => (value == null || value.trim().isEmpty) ? "$fieldName required" : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black26)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1)),
      ),
    );
  }
}