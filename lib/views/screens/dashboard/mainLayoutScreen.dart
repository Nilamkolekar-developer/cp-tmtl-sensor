import 'package:autopeepal/common_widgets/custom_drawer.dart';
import 'package:autopeepal/logic/controller/dashboard/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class MainLayout extends StatelessWidget {
//   final Widget child;
//   final String title;
//   final bool showDrawer; // NEW: Flag to toggle between Sidebar and Back Button

//   const MainLayout({
//     super.key,
//     required this.child,
//     required this.title,
//     this.showDrawer = true, // Default to true for main screens
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 800;

//     return Scaffold(
//       // Android: Show Drawer only if showDrawer is true
//       drawer: (isMobile && showDrawer) ? CustomDrawer() : null,
//       appBar: isMobile
//           ? AppBar(
//               title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               backgroundColor: const Color(0xFF0055BB),
//               centerTitle: true,
//               // NEW: If drawer is hidden, show back button
//               leading: !showDrawer
//                   ? IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Get.back(),
//                     )
//                   : null,
//             )
//           : null,
//       body: Row(
//         children: [
//           // Windows: Show Sidebar only if showDrawer is true
//           if (!isMobile && showDrawer)  CustomDrawer(),

//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: isMobile ? null : Border.all(color: const Color(0xFF0055BB), width: 8),
//               ),
//               child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 appBar: !isMobile
//                     ? AppBar(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         centerTitle: true,
//                         title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//                         // Windows Back Button
//                         leading: !showDrawer
//                             ? IconButton(
//                                 icon: const Icon(Icons.arrow_back, color: Colors.black),
//                                 onPressed: () => Get.back(),
//                               )
//                             : null,
//                       )
//                     : null,
//                 body: child,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// mainLayoutScreen.dart
class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showDrawer;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    // Find the permanent PLC Controller
    final PLCController plcController = Get.find<PLCController>();

    // Helper widget for the status dot to avoid code duplication
    Widget connectionStatusDot() {
      return Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: plcController.isConnected.value ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (plcController.isConnected.value ? Colors.green : Colors.red).withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                  // if (!isMobile) const SizedBox(width: 8),
                  // if (!isMobile)
                  //   Text(
                  //     plcController.isConnected.value ? "ONLINE" : "",
                  //     style: TextStyle(
                  //       color: plcController.isConnected.value ? Colors.green : Colors.red,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
      drawer: (isMobile && showDrawer) ? CustomDrawer() : null,
      appBar: isMobile
          ? AppBar(
              title: Text(title, style: const TextStyle(fontFamily: "Roboto-Regular", color: Colors.white)),
              backgroundColor: const Color(0xFF0055BB),
              leading: !showDrawer ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()) : null,
              // --- MOBILE ACTION BUTTON ---
              actions: [connectionStatusDot()],
            )
          : null,
      body: Row(
        children: [
          if (!isMobile && showDrawer) CustomDrawer(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: (isMobile || !showDrawer)
                    ? null
                    : Border.all(color: const Color(0xFF0055BB), width: 8),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: !isMobile
                    ? AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        leading: !showDrawer
                            ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back())
                            : null,
                        // --- DESKTOP ACTION BUTTON ---
                        actions: [connectionStatusDot()],
                      )
                    : null,
                body: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}