import 'package:autopeepal/logic/controller/dashboard/testRecipeController.dart';
import 'package:autopeepal/routes/routes_string.dart';
import 'package:autopeepal/views/screens/dashboard/mainLayoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestRecipeScreen extends StatelessWidget {
  TestRecipeScreen({super.key});

  // Initialize the controller
  final TestRecipeController controller = Get.put(TestRecipeController());

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive padding
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return SafeArea(
      child: MainLayout(
        title: "ATPL Diagnostic Tool",
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 12, vertical: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Responsive Search Section
                  _buildResponsiveSearchBar(isDesktop),

                  const SizedBox(height: 40),

                  const Text(
                    "Recipe List",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // --- CONSTANT (NON-SCROLLABLE) TABLE ---
                  Container(
                    width: double.infinity, // Forces table to fill the width
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Obx(() => Table(
                          // Draw lines between cells
                          border:
                              TableBorder.all(color: Colors.black26, width: 1),
                          // Use FlexColumnWidth to divide space by ratios (Total flex = 9)
                          columnWidths: const {
                            0: FlexColumnWidth(1), // Sr. No (Smallest)
                            1: FlexColumnWidth(3.5), // Engine Model (Largest)
                            2: FlexColumnWidth(2), // Engine Type
                            3: FlexColumnWidth(2.5), // Recipe ID
                            4: FlexColumnWidth(2.5),
                            5: FlexColumnWidth(2.5),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            // Header Row
                            // TableRow(
                            //   decoration:
                            //       BoxDecoration(color: Colors.grey[200]),
                            //   children: [
                            //     _buildTableCell("Sr.", isHeader: true),
                            //     _buildTableCell("Engine Model", isHeader: true),
                            //     _buildTableCell("Type", isHeader: true),
                            //     _buildTableCell("Recipe ID", isHeader: true),
                            //     _buildTableCell("Edit", isHeader: true),
                            //     _buildTableCell("Export", isHeader: true),
                            //   ],
                            // ),

                            // ...controller.recipeList.map((item) => TableRow(
                            //       children: [
                            //         _buildClickableTableCell(item.sr, item),
                            //         _buildClickableTableCell(item.model, item),
                            //         _buildClickableTableCell(item.type, item),
                            //         _buildClickableTableCell(
                            //             item.recipeId, item),
                            //         _buildClickableTableCell("Edit", item),
                            //         _buildClickableTableCell("Export", item),
                            //       ],
                            //     )),
                            // Inside children: [ ... ]
// 1. Header Row Update
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              children: [
                                _buildTableCell("Sr.", isHeader: true),
                                _buildTableCell("Engine Model", isHeader: true),
                                _buildTableCell("Type", isHeader: true),
                                _buildTableCell("Recipe ID", isHeader: true),
                                _buildTableCell("Actions",
                                    isHeader: true), // New Header
                              ],
                            ),

// 2. Data Row Update
                            ...controller.recipeList.map((item) => TableRow(
                                  children: [
                                    _buildTableCell(item.sr),
                                    _buildTableCell(item.model),
                                    _buildTableCell(item.type),
                                    _buildTableCell(item.recipeId),
                                    // --- ACTIONS CELL ---
                                    TableCell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // EDIT BUTTON
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue, size: 20),
                                            onPressed: () => Get.toNamed(
                                              Routes
                                                  .recipeAdditionReadOnlyScreen, // Or your Edit screen
                                              arguments: item,
                                            ),
                                          ),
                                          // EXPORT BUTTON (Single Recipe)
                                          IconButton(
                                            icon: const Icon(Icons.download,
                                                color: Colors.green, size: 20),
                                            onPressed: () => controller
                                                .exportSingleRecipe(item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Helper for consistent table cells
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow:
            TextOverflow.ellipsis, // Prevents text from breaking the layout
        style: TextStyle(
          fontSize: isHeader ? 13 : 12,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Responsive Search bar logic
  Widget _buildResponsiveSearchBar(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(flex: 5, child: _buildSearchField()),
          const SizedBox(width: 15),
          _buildActionButton("Search", () {}),
          const SizedBox(width: 15),
          _buildActionButton(
              "Add", () => Get.toNamed(Routes.recipeAdditionScreen)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildActionButton("Search", () {})),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildActionButton(
                      "Add", () => Get.toNamed(Routes.recipeAdditionScreen))),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF0055BB), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black, size: 22),
          hintText: "Search recipes...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A76C0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}
