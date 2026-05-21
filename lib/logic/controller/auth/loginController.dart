import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cp_tmtl_sensor_zig/AppPreferences/app_areferences.dart';
import 'package:cp_tmtl_sensor_zig/api/app_envirments.dart';
import 'package:cp_tmtl_sensor_zig/api/app_urls.dart';
import 'package:cp_tmtl_sensor_zig/api/dev/dev_service.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:cp_tmtl_sensor_zig/routes/routes_string.dart';
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

  // ==========================================
  // VALIDATION
  // ==========================================
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

    print("🔐 PASSWORD : $pass");

    final String baseUrl =
        AppEnvironment.baseUrl;

    final String loginUrl =
        "$baseUrl${AppURLs.login}";

    print("🌐 [API] URL : $loginUrl");

    // ==========================================
    // API CALL
    // ==========================================
    final response = await http.post(

      Uri.parse(loginUrl),

      headers: {

        "Content-Type":
            "application/x-www-form-urlencoded",

        "Accept": "application/json",
      },

      body: {

        "username": user,

        "password": pass,
      },
    );

    print(
      "📡 [RESPONSE] STATUS : ${response.statusCode}",
    );

    print(
      "📡 [RESPONSE] BODY : ${response.body}",
    );

    // ==========================================
    // RESPONSE PARSE
    // ==========================================
    Map<String, dynamic> parsedResponse = {};

    try {

      parsedResponse =
          jsonDecode(response.body);

    } catch (_) {

      parsedResponse = {
        "raw": response.body
      };
    }

    parsedResponse['statusCode'] =
        response.statusCode;

    // ==========================================
    // DEV LOG
    // ==========================================
    DevService.instance.insertAPICall(

      AppAPIsCall(

        id:
            "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",

        type:
            'POST ${response.statusCode}',

        path: AppURLs.login,

        dateTime: DateTime.now(),

        data: {
          "username": user,
          "password": "***",
        },

        response: parsedResponse,
      ),
    );

    // ==========================================
    // SUCCESS
    // ==========================================
    if (response.statusCode == 200) {

      await AppPreferences.saveUsername(user);

      await AppPreferences.savePassword(pass);

      print(
        "💾 [LOGIN] Credentials saved",
      );

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      // ==========================================
      // AUTH TOKEN
      // ==========================================
      final Map<String, dynamic> authToken =
          data['data']['auth_token'] ?? {};

      // ACCESS TOKEN
      final String? token =
          authToken['access']
              ?.toString();

      // REFRESH TOKEN
      final String? refreshToken =
          authToken['refresh']
              ?.toString();

      print(
        "🔑 ACCESS TOKEN : $token",
      );

      print(
        "🔄 REFRESH TOKEN : $refreshToken",
      );

      // ==========================================
      // SAVE TOKEN
      // ==========================================
      if (token != null) {

        await AppPreferences.setToken(
          token,
        );

        print(
          "✅ ACCESS TOKEN SAVED",
        );
      }

      // ==========================================
      // ACTIVE USER
      // ==========================================
      await AppPreferences.setActiveUser(
        user,
      );

      print(
        "👤 ACTIVE USER : $user",
      );

      // ==========================================
      // LOAD RECIPES
      // ==========================================
      if (Get.isRegistered<
          TestRecipeController>()) {

        final testController =
            Get.find<TestRecipeController>();

        await testController
            .loadStoredRecipes();

        print(
          "🔄 RECIPES : ${testController.recipeList.length}",
        );
      }

      isLoading.value = false;

      Get.offAllNamed(
        Routes.dashboardScreen,
      );
    }

    // ==========================================
    // BAD REQUEST
    // ==========================================
    else if (response.statusCode == 400) {

      isLoading.value = false;

      final Map<String, dynamic> errData =
          jsonDecode(response.body);

      final String errMsg =
          errData['error'] ??
              errData['detail'] ??
              "Invalid request";

      print(
        "❌ LOGIN 400 : $errMsg",
      );

      Get.snackbar(
        "Login Failed",
        errMsg,
        backgroundColor:
            Colors.redAccent,
        colorText: Colors.white,
      );
    }

    // ==========================================
    // UNAUTHORIZED
    // ==========================================
    else if (response.statusCode == 401) {

      isLoading.value = false;

      Get.snackbar(
        "Login Failed",
        "Invalid email or password",
        backgroundColor:
            Colors.redAccent,
        colorText: Colors.white,
      );
    }

    // ==========================================
    // SERVER ERROR
    // ==========================================
    else {

      isLoading.value = false;

      Get.snackbar(
        "Server Error",
        "Something went wrong (${response.statusCode})",
        backgroundColor:
            Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // ==========================================
  // INTERNET ERROR
  // ==========================================
  on SocketException {

    DevService.instance.insertAPICall(

      AppAPIsCall(

        id:
            "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",

        type: 'POST ERROR',

        path: AppURLs.login,

        dateTime: DateTime.now(),

        data: {
          "username": user,
          "password": "***"
        },

        response: {

          "error": "SocketException",

          "message":
              "No internet connection"
        },
      ),
    );

    isLoading.value = false;

    Get.snackbar(
      "No Connection",
      "Check your internet and try again",
      backgroundColor:
          Colors.redAccent,
      colorText: Colors.white,
    );
  }

  // ==========================================
  // TIMEOUT
  // ==========================================
  on TimeoutException {

    DevService.instance.insertAPICall(

      AppAPIsCall(

        id:
            "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",

        type: 'POST TIMEOUT',

        path: AppURLs.login,

        dateTime: DateTime.now(),

        data: {
          "username": user,
          "password": "***"
        },

        response: {

          "error": "TimeoutException",

          "message":
              "Request timed out"
        },
      ),
    );

    isLoading.value = false;

    Get.snackbar(
      "Timeout",
      "Server took too long to respond",
      backgroundColor:
          Colors.orange,
      colorText: Colors.white,
    );
  }

  // ==========================================
  // EXCEPTION
  // ==========================================
  catch (e) {

    DevService.instance.insertAPICall(

      AppAPIsCall(

        id:
            "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",

        type: 'POST EXCEPTION',

        path: AppURLs.login,

        dateTime: DateTime.now(),

        data: {
          "username": user,
          "password": "***"
        },

        response: {

          "error": "Exception",

          "message": e.toString()
        },
      ),
    );

    isLoading.value = false;

    print(
      "❌ LOGIN ERROR : $e",
    );

    Get.snackbar(
      "Login Failed",
      "An error occurred during login",
      backgroundColor:
          Colors.redAccent,
      colorText: Colors.white,
    );
  }
}

  void login1() async {
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

      final String loginUrl = "${AppEnvironment.baseUrl}${AppURLs.login}";
      print("🌐 [API] Hitting: $loginUrl");

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
      ).timeout(const Duration(seconds: 30));

      print("📡 [RESPONSE] Status: ${response.statusCode}");
      print("📡 [RESPONSE] Body: ${response.body}");
      Map<String, dynamic> parsedResponse = {};
      try {
        parsedResponse = jsonDecode(response.body);
      } catch (_) {
        parsedResponse = {"raw": response.body};
      }
      parsedResponse['statusCode'] = response.statusCode;

      DevService.instance.insertAPICall(AppAPIsCall(
        id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
        type: 'POST ${response.statusCode}',
        path: AppURLs.login,
        dateTime: DateTime.now(),
        data: {"username": user, "password": "***"}, // ✅ password masked
        response: parsedResponse,
      ));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        // ✅ Check responseStatus from your API structure
        final String? responseStatus = body['responseStatus'];
        if (responseStatus != 'SUCCESS') {
          isLoading.value = false;
          final String errMsg =
              body['messages']?[0]?['message'] ?? "Login failed";
          print("❌ [LOGIN] responseStatus: $responseStatus | $errMsg");
          Get.snackbar("Login Failed", errMsg,
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          return;
        }

        // ✅ Extract from data object
        final Map<String, dynamic> data = body['data'];
        final String? accessToken = data['accessToken'];
        final int? userId = data['userId'];
        final String? firstName = data['firstName'];
        final String? lastName = data['lastName'];
        final String? userName = data['userName'];

        print("🔑 [TOKEN] accessToken: $accessToken");
        print("👤 [USER] userId: $userId | name: $firstName $lastName");

        // ✅ Save token
        if (accessToken != null) {
          await AppPreferences.setToken(accessToken);
          print("✅ [PREFS] Token saved");
        } else {
          isLoading.value = false;
          Get.snackbar("Login Failed", "Token not received",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          return;
        }

        // ✅ Save credentials & session
        await AppPreferences.saveUsername(user);
        await AppPreferences.savePassword(pass);
        await AppPreferences.setActiveUser(userName ?? user);

        print("💾 [PREFS] Credentials saved for: $user");
        print("👤 [SESSION] Active User set: ${userName ?? user}");

        // ✅ Sync recipes if controller exists
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
        Get.snackbar("Login Failed", "Invalid username or password",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else {
        isLoading.value = false;
        Get.snackbar(
            "Server Error", "Something went wrong. (${response.statusCode})",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } on SocketException {
      DevService.instance.insertAPICall(AppAPIsCall(
        id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
        type: 'POST TIMEOUT',
        path: AppURLs.login,
        dateTime: DateTime.now(),
        data: {"username": user, "password": "***"},
        response: {"error": "TimeoutException", "message": "Request timed out"},
      ));
      isLoading.value = false;
      Get.snackbar("No Connection", "Check your internet and try again",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } on TimeoutException {
      DevService.instance.insertAPICall(AppAPIsCall(
        id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
        type: 'POST TIMEOUT',
        path: AppURLs.login,
        dateTime: DateTime.now(),
        data: {"username": user, "password": "***"},
        response: {"error": "TimeoutException", "message": "Request timed out"},
      ));
      isLoading.value = false;
      Get.snackbar("Timeout", "Server took too long to respond",
          backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      DevService.instance.insertAPICall(AppAPIsCall(
        id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
        type: 'POST TIMEOUT',
        path: AppURLs.login,
        dateTime: DateTime.now(),
        data: {"username": user, "password": "***"},
        response: {"error": "TimeoutException", "message": "Request timed out"},
      ));
      isLoading.value = false;
      print("❌ [LOGIN ERROR] $e");
      Get.snackbar("Login Failed", "An error occurred during login",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // Create a reusable header helper
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await AppPreferences.getToken();
    return {
      'Authorization': 'Bearer $token', // ✅ Bearer not JWT
      'Content-Type': 'application/json',
    };
  }
}
