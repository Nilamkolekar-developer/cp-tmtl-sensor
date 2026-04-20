import 'package:CP_TMTL_Sensor_Zig/logic/controller/auth/loginController.dart';
import 'package:CP_TMTL_Sensor_Zig/routes/routes_string.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({Key? key}) : super(key: key);
//   final LoginController controller = Get.put(LoginController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 170),
//                         child: Image.asset(
//                           'assets/new/CP_TMTL_Sensor_Zig(1).png',
//                           height: 55,
//                         ),
//                       ),
//                       C30(),
//                       const Text(
//                         'Login',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       C50(),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Email',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       TextField(
//                         controller: controller.usernameController,
//                         cursorColor: Colors.black,
//                         decoration: InputDecoration(
//                           hintText: 'Enter Username',
//                           hintStyle: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontFamily: "Roboto-Regular",
//                             fontSize: 15,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade300,
//                               width: 2,
//                             ),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                         ),
//                       ),
//                       C20(),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Password',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Obx(
//                         () => TextField(
//                           controller: controller.passwordController,
//                           cursorColor: Colors.black,
//                           obscureText: controller.hidePassword.value,
//                           decoration: InputDecoration(
//                             hintText: 'Enter Password',
//                             hintStyle: TextStyle(
//                               color: Colors.grey.shade600,
//                               fontFamily: "Roboto-Regular",
//                               fontSize: 15,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 controller.hidePassword.value
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey.shade400,
//                               ),
//                               onPressed: () {
//                                 controller.hidePassword.toggle();
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide:
//                                   BorderSide(color: Colors.grey.shade400),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide:
//                                   BorderSide(color: Colors.grey.shade400),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(6),
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade300,
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () {},
//                             child: const Text(
//                               'Register',
//                               style: TextStyle(color: Colors.blue),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {},
//                             child: Text(
//                               'Forgot Password ?',
//                               style: TextStyle(color: Colors.grey.shade700),
//                             ),
//                           ),
//                         ],
//                       ),
//                       C20(),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFFF7A18),
//                             minimumSize: const Size(double.infinity, 48),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             Get.offAllNamed(Routes.dashboardScreen);
//                           },
//                           child: const Text(
//                             'SIGN IN',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Column(
//                 children: [
//                   const Text(
//                     'Powered by',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   C5(),
//                   Image.asset(
//                     'assets/new/CP_TMTL_Sensor_Zig(1).png',
//                     height: 28,
//                   ),
//                   C10(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class LoginScreen extends StatelessWidget {
//   LoginScreen({Key? key}) : super(key: key);
//   final LoginController controller = Get.put(LoginController());

//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//     final bool isDesktop = screenSize.width > 800;

//     return Scaffold(
//       backgroundColor: Colors.lightBlue.shade200.withOpacity(0.4),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isDesktop ? screenSize.width * 0.18 : 24,
//                       vertical: 40, // Consistent vertical padding
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // --- WELCOME TEXT (Outside the Card) ---
//                         Text(
//                           "Welcome to CP_TMTL_Sensor_Zig",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: isDesktop ? 36 : 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 1.1,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Your Trusted Diagnostic Partner",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: isDesktop ? 18 : 14,
//                             color: Colors.blueGrey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 40), // Spacing before the Card

//                         // --- LOGIN CARD ---
//                         Container(
//                           constraints: const BoxConstraints(
//                             maxWidth: double
//                                 .infinity, // Keeps form readable on wide screens
//                           ),
//                           padding: const EdgeInsets.all(32),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 10),
//                               )
//                             ],
//                           ),
//                           child: IntrinsicHeight(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // --- LOGO ---
//                                 Image.asset(
//                                   'assets/new/CP_TMTL_Sensor_Zig(1).png',
//                                   height: isDesktop ? 75 : 60,
//                                 ),
//                                 const SizedBox(height: 10),

//                                 SizedBox(height: constraints.maxHeight * 0.02),

//                                 const Text(
//                                   'Login',
//                                   style: TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF2D3142),
//                                   ),
//                                 ),

//                                 SizedBox(height: constraints.maxHeight * 0.03),

//                                 // --- EMAIL FIELD ---
//                                 _buildLabel("Email"),
//                                 TextField(
//                                   controller: controller.usernameController,
//                                   style: const TextStyle(fontSize: 15),
//                                   decoration: _inputDecoration(
//                                       'Enter Username', Icons.email_outlined),
//                                 ),

//                                 const SizedBox(height: 20),

//                                 // --- PASSWORD FIELD ---
//                                 _buildLabel("Password"),
//                                 Obx(() => TextField(
//                                       controller: controller.passwordController,
//                                       obscureText:
//                                           controller.hidePassword.value,
//                                       style: const TextStyle(fontSize: 15),
//                                       decoration: _inputDecoration(
//                                               'Enter Password',
//                                               Icons.lock_outline)
//                                           .copyWith(
//                                         suffixIcon: IconButton(
//                                           icon: Icon(
//                                             controller.hidePassword.value
//                                                 ? Icons.visibility_off
//                                                 : Icons.visibility,
//                                             color: Colors.grey.shade400,
//                                           ),
//                                           onPressed: () =>
//                                               controller.hidePassword.toggle(),
//                                         ),
//                                       ),
//                                     )),

//                                 // --- LINKS ---
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     TextButton(
//                                         onPressed: () {},
//                                         child: const Text('Register')),
//                                     TextButton(
//                                       onPressed: () {},
//                                       child: Text(
//                                         'Forgot Password?',
//                                         style: TextStyle(
//                                             color: Colors.grey.shade700,
//                                             fontSize: isDesktop ? 14 : 13),
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 const SizedBox(height: 25),

//                                 // --- SIGN IN BUTTON ---
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFFFF7A18),
//                                     minimumSize:
//                                         const Size(double.infinity, 54),
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                   ),
//                                   onPressed: () =>
//                                       Get.offAllNamed(Routes.dashboardScreen),
//                                   child: const Text(
//                                     'SIGN IN',
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 30),

//                                 // --- FOOTER ---
//                                 const Text('Powered by',
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 11)),
//                                 const SizedBox(height: 5),
//                                 Image.asset('assets/new/CP_TMTL_Sensor_Zig(1).png',
//                                     height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String label) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 4, bottom: 8),
//         child: Text(label,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.black87)),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       hintText: hint,
//       prefixIcon: Icon(icon, size: 20, color: Colors.blue.shade300),
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

// Replace with your actual imports
// import 'package:modBus/controllers/login_controller.dart'; 
// import 'package:modBus/routes/app_pages.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This ensures the controller is initialized when the screen builds
    // Better practice: Use a Binding, but this fixes your disposal error.
    Get.lazyPut(() => LoginController());

    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 900;

    const Color primaryBlue = Color(0xFF0055BB);
    const Color textDark = Color(0xFF1E293B);
    const Color textLight = Color(0xFF64748B);
    const Color formBg = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- LEFT SIDE: BRANDING (Visible on Desktop) ---
          if (isDesktop)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue, Color(0xFF003377)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO ABOVE NAME
                    Image.asset(
                      'assets/new/CP_TMTL_Sensor_Zig(1).png',
                      height: 120,
                      // Note: Removing 'color: Colors.white' allows the actual logo colors to show. 
                      // Add it back if you want a solid white silhouette.
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.settings_suggest,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "CP_TMTL_Sensor_Zig",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Precision. Performance. Diagnostics.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // --- RIGHT SIDE: FORM ---
          Expanded(
            flex: 5,
            child: Container(
              color: formBg,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mobile Logo (Visible on small screens)
                        if (!isDesktop) ...[
                          Center(
                            child: Image.asset(
                              'assets/new/CP_TMTL_Sensor_Zig(1).png',
                              height: 60,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.settings_suggest, size: 50, color: primaryBlue),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],

                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Sign in to manage your diagnostics",
                          style: TextStyle(color: textLight, fontSize: 16),
                        ),
                        const SizedBox(height: 48),

                        // Username Field
                        _buildLabel("USERNAME OR EMAIL"),
                        TextField(
                          cursorColor: Colors.black,
                          controller: controller.usernameController,
                          style: const TextStyle(fontSize: 15),
                          decoration: _inputDecoration(
                            'name@company.com', 
                            Icons.alternate_email,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        _buildLabel("PASSWORD"),
                        Obx(() => TextField(
                          cursorColor: Colors.black,
                          controller: controller.passwordController,
                          obscureText: controller.hidePassword.value,
                          style: const TextStyle(fontSize: 15),
                          decoration: _inputDecoration(
                            '••••••••', 
                            Icons.lock_outline_rounded,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                                color: textLight,
                              ),
                              onPressed: () => controller.hidePassword.toggle(),
                            ),
                          ),
                        )),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(foregroundColor: primaryBlue),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Sign In Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Use your actual route name here
                            Get.toNamed(Routes.dashboardScreen); 
                          },
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Center(
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(color: textLight, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF94A3B8),
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 15),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0055BB), width: 2),
      ),
    );
  }
}