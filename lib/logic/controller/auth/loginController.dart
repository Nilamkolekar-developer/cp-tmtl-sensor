import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cp_tmtl_sensor_zig/routes/routes_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:cp_tmtl_sensor_zig/AppPreferences/app_areferences.dart';
import 'package:cp_tmtl_sensor_zig/api/app_urls.dart';
import 'package:cp_tmtl_sensor_zig/api/dev/dev_service.dart';

class LoginController extends GetxController {
  /// =========================================
  /// CONTROLLERS
  /// =========================================

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  /// =========================================
  /// OBS VARIABLES
  /// =========================================

  final isLoading = false.obs;

  final hidePassword = true.obs;

  /// =========================================
  /// TOGGLE PASSWORD
  /// =========================================

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  /// =========================================
  /// LOGIN API
  /// =========================================

  Future<void> login() async {
    final String user = usernameController.text.trim();

    final String pass = passwordController.text.trim();

    /// =========================================
    /// VALIDATION
    /// =========================================

    if (user.isEmpty || pass.isEmpty) {
      Get.defaultDialog(
        title: "Error",
        middleText: "Please enter username & password",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );

      return;
    }

    try {
      isLoading.value = true;

      print("=================================");
      print("🚀 LOGIN API START");
      print("=================================");

      /// =========================================
      /// LOGIN API URL
      /// =========================================

      const String loginUrl =
          "http://192.168.50.200:7101/itracex-configservice/v1/api/auth/login";

      print("🌐 URL : $loginUrl");

      /// =========================================
      /// REQUEST BODY
      /// =========================================

      final Map<String, dynamic> requestBody = {
        "userName": user,
        "password": pass,
      };

      print("📤 REQUEST BODY :");

      print(jsonEncode(requestBody));

      /// =========================================
      /// API CALL
      /// =========================================

      final response = await http
          .post(
            Uri.parse(loginUrl),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 60));

      print("=================================");
      print("📥 API RESPONSE");
      print("=================================");

      print("✅ STATUS CODE : ${response.statusCode}");

      print("📦 RESPONSE BODY :");

      print(response.body);

      /// =========================================
      /// JSON RESPONSE
      /// =========================================

      final Map<String, dynamic> body = jsonDecode(response.body);

      /// =========================================
      /// DEV SERVICE LOG
      /// =========================================

      DevService.instance.insertAPICall(
        AppAPIsCall(
          id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
          type: 'POST ${response.statusCode}',
          path: AppURLs.login,
          dateTime: DateTime.now(),
          data: requestBody,
          response: body,
        ),
      );

      /// =========================================
      /// SUCCESS RESPONSE
      /// =========================================

      if (response.statusCode == 200 && body['responseStatus'] == "SUCCESS") {
        print("=================================");
        print("✅ LOGIN SUCCESS");
        print("=================================");

        final Map<String, dynamic> data = body['data'];

        final String accessToken = data['accessToken'];

        final String refreshToken = data['refreshToken'];

        final int userId = data['userId'];

        final String firstName = data['firstName'];

        final String lastName = data['lastName'];

        final String userName = data['userName'];
        final String? stationId = data['stationId']?.toString();

        /// =========================================
        /// PRINT USER INFO
        /// =========================================

        print("👤 USER ID : $userId");

        print("👤 FIRST NAME : $firstName");

        print("👤 LAST NAME : $lastName");

        print("👤 USERNAME : $userName");

        print("🔑 ACCESS TOKEN :");

        print(accessToken);

        print("🔄 REFRESH TOKEN :");

        print(refreshToken);

        /// =========================================
        /// SAVE TOKEN
        /// =========================================

        await AppPreferences.setToken(
          accessToken,
        );

        if (stationId != null && stationId.isNotEmpty) {
          await AppPreferences.saveStationId(stationId);

          // ✅ Verify what was actually saved
          final String? savedStationId = await AppPreferences.getStationId();
          print("✅ Saved StationId: $savedStationId");
        } else {
          print("⚠️ stationId is null or empty in API response");
        }

        print("✅ TOKEN SAVED SUCCESSFULLY");

        /// =========================================
        /// SUCCESS DIALOG
        /// =========================================

        Get.defaultDialog(
          title: "Success",
          middleText: "Login Successful",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();

            /// NAVIGATION

            Get.offAllNamed(Routes.dashboardScreen);
          },
        );
      }

      /// =========================================
      /// LOGIN FAILED
      /// =========================================

      else {
        print("=================================");
        print("❌ LOGIN FAILED");
        print("=================================");

        print(body);

        final String errorMessage =
            body['messages']?[0]?['message'] ?? "Login Failed";

        Get.defaultDialog(
          title: "Login Failed",
          middleText: errorMessage,
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      }
    }

    /// =========================================
    /// SOCKET ERROR
    /// =========================================

    on SocketException catch (e) {
      DevService.instance.insertAPICall(
        AppAPIsCall(
          id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
          type: 'POST SOCKET ERROR',
          path: AppURLs.login,
          dateTime: DateTime.now(),
          data: {
            "userName": user,
            "password": "***",
          },
          response: {
            "error": "SocketException",
            "message": e.message,
            "address": e.address.toString(),
            "port": e.port,
          },
        ),
      );

      print("=================================");
      print("❌ SOCKET ERROR");
      print("=================================");

      print("MESSAGE : ${e.message}");

      print("ADDRESS : ${e.address}");

      print("PORT : ${e.port}");

      Get.defaultDialog(
        title: "Connection Error",
        middleText: "Unable to connect server",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    }

    /// =========================================
    /// TIMEOUT ERROR
    /// =========================================

    on TimeoutException {
      DevService.instance.insertAPICall(
        AppAPIsCall(
          id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
          type: 'POST TIMEOUT',
          path: AppURLs.login,
          dateTime: DateTime.now(),
          data: {
            "userName": user,
            "password": "***",
          },
          response: {
            "error": "TimeoutException",
            "message": "Request timed out",
          },
        ),
      );

      print("=================================");
      print("❌ TIMEOUT ERROR");
      print("=================================");

      Get.defaultDialog(
        title: "Timeout",
        middleText: "Server not responding",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    }

    /// =========================================
    /// COMMON ERROR
    /// =========================================

    catch (e) {
      DevService.instance.insertAPICall(
        AppAPIsCall(
          id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
          type: 'POST ERROR',
          path: AppURLs.login,
          dateTime: DateTime.now(),
          data: {
            "userName": user,
            "password": "***",
          },
          response: {
            "error": "Exception",
            "message": e.toString(),
          },
        ),
      );

      print("=================================");
      print("❌ COMMON ERROR");
      print("=================================");

      print(e.toString());

      Get.defaultDialog(
        title: "Error",
        middleText: e.toString(),
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================================
  /// AUTH HEADERS
  /// =========================================

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await AppPreferences.getToken();

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }
}
