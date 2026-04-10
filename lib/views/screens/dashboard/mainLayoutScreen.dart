import 'package:autopeepal/common_widgets/custom_drawer.dart';
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

    return Scaffold(
      drawer: (isMobile && showDrawer) ?  CustomDrawer() : null,
      appBar: isMobile
          ? AppBar(
              title: Text(title),
              backgroundColor: const Color(0xFF0055BB),
              leading: !showDrawer ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()) : null,
            )
          : null,
      body: Row(
        children: [
          // This IF statement must be exactly like this to free up the space
          if (!isMobile && showDrawer)  CustomDrawer(),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Only show blue border on main screens where drawer is visible
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
                        leading: !showDrawer ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()) : null,
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