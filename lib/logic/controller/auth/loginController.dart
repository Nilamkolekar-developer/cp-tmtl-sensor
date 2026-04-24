import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:CP_TMTL_Sensor_Zig/AppPreferences/app_areferences.dart';
import 'package:CP_TMTL_Sensor_Zig/api/app_envirments.dart';
import 'package:CP_TMTL_Sensor_Zig/api/app_urls.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:CP_TMTL_Sensor_Zig/routes/routes_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  // 1. Controllers for TextFields
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final hidePassword = true.obs;
  final isLoading = false.obs;
  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }
  @override
void onInit() {
  super.onInit();
  _loadSavedCredentials(); // ✅ Load on init
}

Future<void> _loadSavedCredentials() async {
  final String? savedUser = await AppPreferences.getSavedUsername();
  final String? savedPass = await AppPreferences.getSavedPassword();

  if (savedUser != null && savedUser.isNotEmpty) {
    usernameController.text = savedUser;
  }
  if (savedPass != null && savedPass.isNotEmpty) {
    passwordController.text = savedPass;
  }
  print("📖 [LOGIN] Loaded saved credentials for: $savedUser");
}

  void login() async {
    String user = usernameController.value.text;
    String pass = passwordController.value.text;

    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter credentials",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      print("🚀 [LOGIN START] Authenticating: $user");
      print("password: $pass");
      final String baseUrl = AppEnvironment.baseUrl;
      final String loginUrl = "$baseUrl${AppURLs.login}";
      print("🌐 [API] Hitting: $loginUrl");

      // ✅ Use form encoding — Django REST expects this by default
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
        },
        body: {
          "username": user,
          "password": pass,
        },
      );

      print("📡 [RESPONSE] Status: ${response.statusCode}");
      print("📡 [RESPONSE] Body: ${response.body}");

      if (response.statusCode == 200) {
           await AppPreferences.saveUsername(user);
      await AppPreferences.savePassword(pass);
      print("💾 [LOGIN] Credentials saved for: $user");
        final Map<String, dynamic> data = jsonDecode(response.body);

        final String? token = data['data']?['auth_token']?['access'];
        if (token != null) {
          await AppPreferences.setToken(token);
          print("🔑 [TOKEN] Saved: $token");
        }

        await AppPreferences.setActiveUser(user);
        print("👤 [SESSION] Active User set: $user");

        if (Get.isRegistered<TestRecipeController>()) {
          final testController = Get.find<TestRecipeController>();
          await testController.loadStoredRecipes();
          print("🔄 [SYNC] Recipes: ${testController.recipeList.length}");
        }

        isLoading.value = false;
        Get.offAllNamed(Routes.dashboardScreen);
      } else if (response.statusCode == 400) {
        isLoading.value = false;
        final Map<String, dynamic> errData = jsonDecode(response.body);
        final String errMsg =
            errData['error'] ?? errData['detail'] ?? "Invalid request";
        print("❌ [LOGIN 400] $errMsg");
        Get.snackbar("Login Failed", errMsg,
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else if (response.statusCode == 401) {
        isLoading.value = false;
        Get.snackbar("Login Failed", "Invalid email or password",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar(
            "Server Error", "Something went wrong. (${response.statusCode})",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } on SocketException {
      isLoading.value = false;
      Get.snackbar("No Connection", "Check your internet and try again",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } on TimeoutException {
      isLoading.value = false;
      Get.snackbar("Timeout", "Server took too long to respond",
          backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      isLoading.value = false;
      print("❌ [LOGIN ERROR] $e");
      Get.snackbar("Login Failed", "An error occurred during login");
    }
  }
}
