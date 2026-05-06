import 'package:cp_tmtl_sensor_zig/logic/controller/auth/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                     'assets/new/tmtl-logo(1).png',
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
                      "CP TMTL Sensor Zig",
                      style: TextStyle(
                        fontSize: 40,
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
                              'assets/new/cp_tmtl_sensor_zig(1).png',
                              height: 60,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.settings_suggest,
                                      size: 50, color: primaryBlue),
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
                                  onPressed: () =>
                                      controller.hidePassword.toggle(),
                                ),
                              ),
                            )),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                foregroundColor: primaryBlue),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Sign In Button
                        // Sign In Button
Obx(() => ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // Disable button while loading to prevent multiple clicks
      onPressed: controller.isLoading.value 
          ? null 
          : () => controller.login(),
      child: controller.isLoading.value
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : const Text(
              "SIGN IN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
    )),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: primaryBlue,
                        //     foregroundColor: Colors.white,
                        //     minimumSize: const Size(double.infinity, 56),
                        //     elevation: 0,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     controller.login();
                        //     // Use your actual route name here
                        //     // Get.toNamed(Routes.dashboardScreen);
                        //   },
                        //   child: const Text(
                        //     "SIGN IN",
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w800,
                        //       letterSpacing: 1,
                        //     ),
                        //   ),
                        // ),

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
