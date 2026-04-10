import 'package:autopeepal/logic/controller/dashboard/recipeAdditionReadOnlyController.dart';
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeAdditionReadOnlyScreen extends StatelessWidget {
  RecipeAdditionReadOnlyScreen({super.key});
 final recipeAdditionReadOnlyController controller = Get.put(recipeAdditionReadOnlyController());
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return SafeArea(
      child: MainLayout(
        title: "Recipe Configuration",
        showDrawer: false, // Tells MainLayout to hide sidebar and border
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop
                    ? 40
                    : 16, // Moderate padding for edge-to-edge look
                vertical: 30),
            child: SizedBox(
              width: double.infinity, // Allows content to span full width
              child: Column(
                children: [
                  _buildSectionHeader("Engine Details"),
                  const SizedBox(height: 20),
                  _buildResponsiveGrid(isDesktop, [
                    _buildInputField("Engine Model Number", "e.g. 6BT-5.9",
                        controller: controller.modelController.value),
                    _buildInputField("Engine Type", "e.g. Diesel",
                        controller: controller.typeController.value),
                  ]),

                  const SizedBox(height: 40),
                  _buildSectionHeader("Sensor Configuration"),
                  const SizedBox(height: 20),
                  _buildResponsiveGrid(isDesktop, [
                    _buildInputField("Sensor Name", "e.g. Oil Pressure",controller: controller.sensorName.value),
                    _buildInputField("Sensor Type", "e.g. Analog",controller: controller.sensorType.value),
                  ]),

                  const SizedBox(height: 20),
                  _buildResponsiveGrid(isDesktop, [
                    _buildInputField("Register Number", "0x00",
                        isNumeric: true, controller: controller.registerNumber.value),
                    _buildMinMaxField(isDesktop),
                  ]),

                  const SizedBox(height: 20),
                  _buildResponsiveGrid(isDesktop, [
                    _buildInputField("Multiplier", "1.0", isNumeric: true, controller: controller.multiplier.value),
                    _buildInputField("Offset", "0", isNumeric: true, controller: controller.offset.value),
                  ]),

                  const SizedBox(height: 60),

                  // Action Buttons
                  // Row(
                  //   mainAxisAlignment: isDesktop
                  //       ? MainAxisAlignment.end
                  //       : MainAxisAlignment.center,
                  //   children: [
                  //     OutlinedButton(
                  //       onPressed: () => Get.back(),
                  //       style: OutlinedButton.styleFrom(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 40, vertical: 20),
                  //         side: const BorderSide(color: Colors.grey),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8)),
                  //       ),
                  //       child: const Text("Cancel", style:
                  //               TextStyle(color: Colors.black, fontSize: 16)),
                  //     ),
                  //     const SizedBox(width: 20),
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         controller.addRecipe();
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF4A76C0),
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 50, vertical: 20),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8)),
                  //       ),
                  //       child: const Text("Add",
                  //           style:
                  //               TextStyle(color: Colors.white, fontSize: 16)),
                  //     ),
                  //     //  const SizedBox(width: 20),
                  //     //  ElevatedButton(
                  //     //   onPressed: () {
                  //     //     controller.importRecipes();
                  //     //   },
                  //     //   style: ElevatedButton.styleFrom(
                  //     //     backgroundColor: const Color(0xFF4A76C0),
                  //     //     padding: const EdgeInsets.symmetric(
                  //     //         horizontal: 50, vertical: 20),
                  //     //     shape: RoundedRectangleBorder(
                  //     //         borderRadius: BorderRadius.circular(8)),
                  //     //   ),
                  //     //   child: const Text("Import",
                  //     //       style:
                  //     //           TextStyle(color: Colors.white, fontSize: 16)),
                  //     // ),
                  //     //  const SizedBox(width: 20),
                  //     //  ElevatedButton(
                  //     //   onPressed: () {
                  //     //     controller.exportToJSON();
                  //     //   },
                  //     //   style: ElevatedButton.styleFrom(
                  //     //     backgroundColor: const Color(0xFF4A76C0),
                  //     //     padding: const EdgeInsets.symmetric(
                  //     //         horizontal: 50, vertical: 20),
                  //     //     shape: RoundedRectangleBorder(
                  //     //         borderRadius: BorderRadius.circular(8)),
                  //     //   ),
                  //     //   child: const Text("Export",
                  //     //       style:
                  //     //           TextStyle(color: Colors.white, fontSize: 16)),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Updated Helper: Takes up half width on Desktop, full on Mobile ---
  Widget _buildResponsiveGrid(bool isDesktop, List<Widget> children) {
    return Wrap(
      spacing: 30,
      runSpacing: 20,
      children: children
          .map((w) => SizedBox(
                // On full-page Windows, we make children 48% width to stay side-by-side
                width: isDesktop
                    ? (MediaQuery.of(Get.context!).size.width / 2) - 60
                    : double.infinity,
                child: w,
              ))
          .toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0055BB))),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildInputField(String label, String hint,
      {bool isNumeric = false,
      TextEditingController? controller} // Added comma here
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26),
          ),
          child: TextField(
            controller: controller, // CRITICAL: Assign the controller here
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinMaxField(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Range (Min / Max)",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildInputFieldNoLabel("Min", controller.min.value)),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("/")),
            Expanded(
                child: _buildInputFieldNoLabel("Max", controller.max.value)),
          ],
        ),
      ],
    );
  }

  Widget _buildInputFieldNoLabel(
      String hint, TextEditingController? controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
