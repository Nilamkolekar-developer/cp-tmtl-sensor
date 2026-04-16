import 'package:autopeepal/logic/controller/dashboard/testRecipeController.dart';
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeAdditionScreen extends StatelessWidget {
  RecipeAdditionScreen({super.key});
  final TestRecipeController controller = Get.find<TestRecipeController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    // --- RESPONSIVE FONT SIZES ---
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
              child: Column(
                children: [
                  // --- SECTION 1: ENGINE DETAILS + IMPORT ---
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

                  // --- SECTION 2: ADDED SENSOR LIST ---
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
                              DataColumn(
                                  label: Text('Name',
                                      style: TextStyle(
                                          fontSize: tableHeaderFontSize,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Type',
                                      style: TextStyle(
                                          fontSize: tableHeaderFontSize,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Register',
                                      style: TextStyle(
                                          fontSize: tableHeaderFontSize,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Range',
                                      style: TextStyle(
                                          fontSize: tableHeaderFontSize,
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Action',
                                      style: TextStyle(
                                          fontSize: tableHeaderFontSize,
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: controller.addedSensors.map((sensor) {
                              return DataRow(cells: [
                                DataCell(Text(sensor.name,
                                    style: TextStyle(
                                        fontSize: tableCellFontSize))),
                                DataCell(Text(sensor.type,
                                    style: TextStyle(
                                        fontSize: tableCellFontSize))),
                                DataCell(Text(sensor.register,
                                    style: TextStyle(
                                        fontSize: tableCellFontSize))),
                                DataCell(Text("${sensor.min} / ${sensor.max}",
                                    style: TextStyle(
                                        fontSize: tableCellFontSize))),
                                DataCell(IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: Colors.red,
                                      size: isDesktop ? 22 : 20),
                                  onPressed: () =>
                                      controller.addedSensors.remove(sensor),
                                )),
                              ]);
                            }).toList(),
                          ),
                        )),

                  // --- SECTION 3: SENSOR CONFIGURATION (Form) ---
                  Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.isAddingSensor.value
                            ? Column(
                                key: const ValueKey("ConfigForm"),
                                children: [
                                  const SizedBox(height: 20),
                                  _buildSectionHeader("Configure New Sensor",
                                      fontSize: headerFontSize),
                                  const SizedBox(height: 20),
                                  _buildResponsiveGrid(isDesktop, [
                                    _buildInputField(
                                        "Sensor Name", "e.g. Oil Pressure",
                                        labelSize: labelFontSize,
                                        textSize: inputFontSize,
                                        controller:
                                            controller.sensorName.value),
                                    _buildInputField(
                                        "Sensor Type", "e.g. Analog",
                                        labelSize: labelFontSize,
                                        textSize: inputFontSize,
                                        controller:
                                            controller.sensorType.value),
                                  ]),
                                  const SizedBox(height: 20),
                                  _buildResponsiveGrid(isDesktop, [
                                    _buildInputField("Register Number", "0x00",
                                        isNumeric: true,
                                        labelSize: labelFontSize,
                                        textSize: inputFontSize,
                                        controller:
                                            controller.registerNumber.value),
                                    _buildMinMaxField(isDesktop, labelFontSize,
                                        inputFontSize),
                                  ]),
                                  const SizedBox(height: 20),
                                  _buildResponsiveGrid(isDesktop, [
                                    _buildInputField("Multiplier", "1.0",
                                        isNumeric: true,
                                        labelSize: labelFontSize,
                                        textSize: inputFontSize,
                                        controller:
                                            controller.multiplier.value),
                                    _buildInputField("Offset", "0",
                                        isNumeric: true,
                                        labelSize: labelFontSize,
                                        textSize: inputFontSize,
                                        controller: controller.offset.value),
                                  ]),
                                  const SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        controller.saveSensorToList();
                                        controller.isAddingSensor.value = false;
                                      },
                                      icon: const Icon(Icons.check),
                                      label: Text("Save Sensor to Table",
                                          style: TextStyle(
                                              fontSize: labelFontSize)),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[700],
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12)),
                                    ),
                                  ),
                                  const Divider(height: 60),
                                ],
                              )
                            : const SizedBox.shrink(),
                      )),

                  const SizedBox(height: 60),

                  // FINAL ACTION BUTTONS
                  Row(
                    mainAxisAlignment: isDesktop
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 50 : 40, vertical: 20),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: isDesktop ? 18 : 16)),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => controller.addRecipe(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A76C0),
                          padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 60 : 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Add Recipe",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modified helper to accept fontSize
  Widget _buildSectionHeader(String title,
      {required double fontSize, Widget? trailing}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0055BB))),
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
      children: children
          .map((w) => SizedBox(
                width: isDesktop
                    ? (MediaQuery.of(Get.context!).size.width / 2) - 60
                    : double.infinity,
                child: w,
              ))
          .toList(),
    );
  }

  Widget _buildInputField(String label, String hint,
      {required double labelSize,
      required double textSize,
      bool isNumeric = false,
      TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(fontSize: textSize),
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: textSize, color: Colors.grey),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinMaxField(bool isDesktop, double labelSize, double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Range (Min / Max)",
            style: TextStyle(fontSize: labelSize, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildInputFieldNoLabel(
                    "Min", textSize, controller.min.value)),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("/")),
            Expanded(
                child: _buildInputFieldNoLabel(
                    "Max", textSize, controller.max.value)),
          ],
        ),
      ],
    );
  }

  Widget _buildInputFieldNoLabel(
      String hint, double textSize, TextEditingController? controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: textSize),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: textSize),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
