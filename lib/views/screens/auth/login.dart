import 'package:autopeepal/common_widgets/ui_helper_widgets.dart';
import 'package:autopeepal/logic/controller/auth/loginController.dart';
import 'package:autopeepal/routes/routes_string.dart';

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
//                           'assets/new/autopeepal(1).png',
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
//                     'assets/new/autopeepal(1).png',
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
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800;

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200.withOpacity(0.4),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? screenSize.width * 0.18 : 24,
                      vertical: 40, // Consistent vertical padding
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // --- WELCOME TEXT (Outside the Card) ---
                        Text(
                          "Welcome to AutoPeepal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 36 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your Trusted Diagnostic Partner",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40), // Spacing before the Card

                        // --- LOGIN CARD ---
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity, // Keeps form readable on wide screens
                          ),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // --- LOGO ---
                                Image.asset(
                                  'assets/new/autopeepal(1).png',
                                  height: isDesktop ? 75 : 60,
                                ),
                                const SizedBox(height: 10),

                                SizedBox(height: constraints.maxHeight * 0.02),

                                const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),

                                SizedBox(height: constraints.maxHeight * 0.03),

                                // --- EMAIL FIELD ---
                                _buildLabel("Email"),
                                TextField(
                                  controller: controller.usernameController,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: _inputDecoration(
                                      'Enter Username', Icons.email_outlined),
                                ),

                                const SizedBox(height: 20),

                                // --- PASSWORD FIELD ---
                                _buildLabel("Password"),
                                Obx(() => TextField(
                                      controller: controller.passwordController,
                                      obscureText: controller.hidePassword.value,
                                      style: const TextStyle(fontSize: 15),
                                      decoration: _inputDecoration(
                                              'Enter Password', Icons.lock_outline)
                                          .copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            controller.hidePassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey.shade400,
                                          ),
                                          onPressed: () =>
                                              controller.hidePassword.toggle(),
                                        ),
                                      ),
                                    )),

                                // --- LINKS ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Register')),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: isDesktop ? 14 : 13),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // --- SIGN IN BUTTON ---
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF7A18),
                                    minimumSize: const Size(double.infinity, 54),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () =>
                                      Get.offAllNamed(Routes.dashboardScreen),
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // --- FOOTER ---
                                const Text('Powered by',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 5),
                                Image.asset('assets/new/autopeepal(1).png',
                                    height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.blue.shade300),
      filled: true,
      fillColor: Colors.blueGrey.withOpacity(0.03),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
      ),
    );
  }
}
