// import 'dart:convert';
// import 'package:cp_tmtl_sensor_zig/AppPreferences/app_areferences.dart';
// import 'package:cp_tmtl_sensor_zig/api/dev/dev_service.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:package_info_plus/package_info_plus.dart';

// class DashboardController extends GetxController {
//   // =====================================================
//   // APP INFO
//   // =====================================================

//   RxString appName = ''.obs;
//   RxString version = ''.obs;
//   RxString buildNumber = ''.obs;

//   // =====================================================
//   // LOADING
//   // =====================================================

//   RxBool isLoading = false.obs;

//   // =====================================================
//   // MODEL SELECTION
//   // =====================================================

//   RxInt selectedModelIndex = 0.obs;

//   final selectedModel = <String, dynamic>{}.obs;

//   // =====================================================
//   // API URL
//   // =====================================================

//   static const String dashboardApiUrl =
//       "http://192.168.50.200:7106/itracex-traceabilityservice/v1/api/traceability/test";

//   // =====================================================
//   // ENGINE MODELS
//   // =====================================================

//   final RxList<Map<String, dynamic>> engineModels =
//       <Map<String, dynamic>>[].obs;

//   // =====================================================
//   // DEFAULT MODEL IDS
//   // =====================================================

//   final List<String> modelNos = [
//      "TD 2.2 L3",
//     "TCD 2.2 L4",
//     "TCD 2.9 L4",
//     "D 2.9 L4",
//     "TD 2.9",
//   ];

//   // =====================================================
//   // GET CURRENT MODEL
//   // =====================================================

//   Map<String, dynamic> get currentModel =>
//       engineModels[selectedModelIndex.value];

//   // =====================================================
//   // INIT
//   // =====================================================

//   @override
//   void onInit() {
//     super.onInit();

//     loadAppInfo();

//     fetchDashboardData();
//   }

//   // =====================================================
//   // APP INFO
//   // =====================================================

//   Future<void> loadAppInfo() async {
//     try {
//       final info = await PackageInfo.fromPlatform();

//       appName.value = info.appName;
//       version.value = info.version;
//       buildNumber.value = info.buildNumber;
//     } catch (e) {
//       appName.value = "ATPL Tool";
//     }
//   }

//   // =====================================================
//   // SELECT MODEL
//   // =====================================================

//   void selectModel(int index) {
//     selectedModelIndex.value = index;

//     selectedModel.value = engineModels[index];
//   }

//   // =====================================================
//   // FETCH DASHBOARD API
//   // =====================================================

//   Future<void> fetchDashboardData() async {
//     try {
//       isLoading.value = true;

//       String? token = await AppPreferences.getToken();

//       // =================================================
//       // DATE RANGE
//       // =================================================

//       final DateTime now = DateTime.now();

//       final DateTime fromDate = now.subtract(const Duration(days: 30));

//       // =================================================
//       // REQUEST BODY
//       // =================================================

//       final Map<String, dynamic> requestBody = {
//         "type": "SENSOR_TEST",
//         "stationId": "sensortesting_1",
//         "fromDate":
//             "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
//         "toDate":
//             "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
//         "modelNo": modelNos,
//       };

//       print("=================================================");
//       print("📡 DASHBOARD API REQUEST");
//       print("URL : $dashboardApiUrl");
//       print("BODY: ${jsonEncode(requestBody)}");
//       print("=================================================");

//       // =================================================
//       // API CALL
//       // =================================================

//       final response = await http.post(
//         Uri.parse(dashboardApiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",

//           /// ✅ TOKEN
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(requestBody),
//       ).timeout(
//         const Duration(seconds: 15),
//         onTimeout: () {
//           throw Exception("Request timed out. Please check network.");
//         },
//       );

//       // =================================================
//       // PARSE RESPONSE BODY
//       // =================================================

//       final Map<String, dynamic> responseBody = jsonDecode(response.body);

//       print("=================================================");
//       print("📥 DASHBOARD API RESPONSE");
//       print("STATUS CODE : ${response.statusCode}");
//       print("BODY        : ${response.body}");
//       print("=================================================");

//       // =================================================
//       // 📝 LOG API CALL — DEV SERVICE
//       // =================================================

//         DevService.instance.insertAPICall(
//         AppAPIsCall(
//           id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
//           type: "POST ${response.statusCode}",
//           path: dashboardApiUrl,
//           dateTime: DateTime.now(),
//           data: requestBody,
//           response: responseBody,
//         ),
//       );

//       // =================================================
//       // SUCCESS — 200
//       // =================================================

//       if (response.statusCode == 200) {
//         if (responseBody["responseStatus"] == "SUCCESS") {
//           // =============================================
//           // CLEAR OLD LIST
//           // =============================================

//           engineModels.clear();

//           // =============================================
//           // GET DATA LIST
//           // =============================================

//           final List<dynamic> dashboardList = responseBody["data"];

//           // =============================================
//           // MAP API DATA
//           // =============================================

//           for (var item in dashboardList) {
//             engineModels.add({
//               "name"      : item["modelId"]        ?? "-",
//               "total"     : item["totalTested"]    ?? 0,
//               "today"     : item["todayTested"]    ?? 0,
//               "pass"      : item["totalTestPass"]  ?? 0,
//               "fail"      : item["totalTestFail"]  ?? 0,
//               "plan"      : item["todayPasstest"]  ?? 0,
//               "todayPass" : item["todayPasstest"]  ?? 0,
//               "todayFail" : item["todayFailedTest"] ?? 0,
//             });

//             print("✅ MODEL LOADED : ${item["modelId"]}");
//           }

//           // =============================================
//           // SELECT FIRST MODEL BY DEFAULT
//           // =============================================

//           if (engineModels.isNotEmpty) {
//            // selectedModel.value = engineModels.first;
//            selectedModel.assignAll(engineModels.first);
//           }

//           Get.snackbar(
//             "Success",
//             "Dashboard data loaded successfully",
//           );
//         } else {
//           // =============================================
//           // API RETURNED FAILURE STATUS
//           // =============================================

//           Get.snackbar(
//             "Error",
//             responseBody["responseStatusDetails"] ??
//                 "Failed to fetch dashboard data",
//           );
//         }
//       }

//       // =================================================
//       // UNAUTHORIZED — 401
//       // =================================================

//       else if (response.statusCode == 401) {
//         Get.snackbar(
//           "Unauthorized",
//           "Session expired. Please login again.",
//         );
//       }

//       // =================================================
//       // SERVER ERROR — OTHER STATUS CODES
//       // =================================================

//       else {
//         Get.snackbar(
//           "Server Error",
//           "Status Code: ${response.statusCode}",
//         );
//       }
//     } catch (e) {
//       print("❌ DASHBOARD ERROR: $e");

//       // =================================================
//       // NETWORK / TIMEOUT ERROR
//       // =================================================

//       if (e.toString().contains("SocketException") ||
//           e.toString().contains("semaphore") ||
//           e.toString().contains("timeout")) {
//         Get.snackbar(
//           "Network Error",
//           "Cannot reach server. Check your network connection.",
//           duration: const Duration(seconds: 4),
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           "Failed to load dashboard data",
//         );
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // =====================================================
//   // REFRESH
//   // =====================================================

//   Future<void> refreshDashboard() async {
//     await fetchDashboardData();
//   }
// }

//sunday//
import 'dart:convert';
import 'package:cp_tmtl_sensor_zig/AppPreferences/app_areferences.dart';
import 'package:cp_tmtl_sensor_zig/api/dev/dev_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class DashboardController extends GetxController {
  // =====================================================
  // APP INFO
  // =====================================================

  RxString appName = ''.obs;
  RxString version = ''.obs;
  RxString buildNumber = ''.obs;

  // =====================================================
  // LOADING
  // =====================================================

  RxBool isLoading = false.obs;

  // =====================================================
  // MODEL SELECTION
  // =====================================================

  RxInt selectedModelIndex = 0.obs;

  final RxMap<String, dynamic> selectedModel = <String, dynamic>{}.obs;

  // =====================================================
  // API URL
  // =====================================================

  static const String dashboardApiUrl =
      "http://192.168.50.200:7106/itracex-traceabilityservice/v1/api/traceability/test";

  // =====================================================
  // ENGINE MODELS
  // =====================================================

  final RxList<Map<String, dynamic>> engineModels =
      <Map<String, dynamic>>[].obs;

  // =====================================================
  // DEFAULT MODEL IDS
  // =====================================================

  final List<String> modelNos = [
    "TD 2.2 L3",
    "TCD 2.2 L4",
    "TCD 2.9 L4",
    "D 2.9 L4",
    "TD 2.9",
  ];

  // =====================================================
  // GET CURRENT MODEL
  // =====================================================

  Map<String, dynamic> get currentModel {
    if (engineModels.isEmpty) {
      return {};
    }

    return engineModels[selectedModelIndex.value];
  }

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {
    super.onInit();

    loadAppInfo();

    fetchDashboardData();
  }

  // =====================================================
  // APP INFO
  // =====================================================

  Future<void> loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();

      appName.value = info.appName;
      version.value = info.version;
      buildNumber.value = info.buildNumber;
    } catch (e) {
      appName.value = "ATPL Tool";
    }
  }

  // =====================================================
  // SELECT MODEL
  // =====================================================

  void selectModel(int index) {
    selectedModelIndex.value = index;

    selectedModel.assignAll(
      engineModels[index],
    );
  }

  // =====================================================
  // FETCH DASHBOARD API
  // =====================================================

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      String? token = await AppPreferences.getToken();

      // =================================================
      // DATE RANGE
      // =================================================

      final DateTime now = DateTime.now();

      final DateTime fromDate = now.subtract(const Duration(days: 30));

      // =================================================
      // REQUEST BODY
      // =================================================

      final Map<String, dynamic> requestBody = {
        "type": "SENSOR_TEST",
        "stationId": "sensortesting_1",
        "fromDate":
            "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
        "toDate":
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        "modelNo": modelNos,
      };

      print("=================================================");
      print("📡 DASHBOARD API REQUEST");
      print("URL : $dashboardApiUrl");
      print("BODY: ${jsonEncode(requestBody)}");
      print("=================================================");

      // =================================================
      // API CALL
      // =================================================

      final response = await http
          .post(
        Uri.parse(dashboardApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
            "Request timed out. Please check network.",
          );
        },
      );

      // =================================================
      // RESPONSE BODY
      // =================================================

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      print("=================================================");
      print("📥 DASHBOARD API RESPONSE");
      print("STATUS CODE : ${response.statusCode}");
      print("BODY        : ${response.body}");
      print("=================================================");

      // =================================================
      // API LOG
      // =================================================

      DevService.instance.insertAPICall(
        AppAPIsCall(
          id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
          type: "POST ${response.statusCode}",
          path: dashboardApiUrl,
          dateTime: DateTime.now(),
          data: requestBody,
          response: responseBody,
        ),
      );

      // =================================================
      // SUCCESS
      // =================================================

      if (response.statusCode == 200) {
        if (responseBody["responseStatus"] == "SUCCESS") {
          // =============================================
          // CLEAR OLD LIST
          // =============================================

        engineModels.clear();

final List<dynamic> dashboardList =
    responseBody["data"]["data"] ?? [];

print("DASHBOARD LIST : $dashboardList");

for (var item in dashboardList) {

  engineModels.add({

    "name":
        item["modelId"]?.toString() ?? "-",

    "total":
        int.tryParse(
              item["totalTested"].toString(),
            ) ??
            0,

    "today":
        int.tryParse(
              item["todayTested"].toString(),
            ) ??
            0,

    "pass":
        int.tryParse(
              item["totalTestPass"].toString(),
            ) ??
            0,

    "fail":
        int.tryParse(
              item["totalTestFail"].toString(),
            ) ??
            0,

    "todayPass":
        int.tryParse(
              item["todayPassTest"].toString(),
            ) ??
            0,

    "todayFail":
        int.tryParse(
              item["todayFailedTest"].toString(),
            ) ??
            0,
  });

  print("MODEL : ${engineModels.last}");
}

if (engineModels.isNotEmpty) {

  selectedModelIndex.value = 0;

  selectedModel.value =
      Map<String, dynamic>.from(
          engineModels.first);

  print("SELECTED MODEL : $selectedModel");
}

          // =============================================
          // SELECT FIRST MODEL
          // =============================================

          if (engineModels.isNotEmpty) {
            selectedModel.assignAll(
              engineModels.first,
            );
          }

          Get.snackbar(
            "Success",
            "Dashboard data loaded successfully",
          );
        }

        // =============================================
        // API FAILURE
        // =============================================

        else {
          Get.snackbar(
            "Error",
            responseBody["responseStatusDetails"] ??
                "Failed to fetch dashboard data",
          );
        }
      }

      // =================================================
      // UNAUTHORIZED
      // =================================================

      else if (response.statusCode == 401) {
        Get.snackbar(
          "Unauthorized",
          "Session expired. Please login again.",
        );
      }

      // =================================================
      // SERVER ERROR
      // =================================================

      else {
        Get.snackbar(
          "Server Error",
          "Status Code: ${response.statusCode}",
        );
      }
    }

    // ===================================================
    // ERROR
    // ===================================================

    catch (e) {
      print("❌ DASHBOARD ERROR: $e");

      if (e.toString().contains("SocketException") ||
          e.toString().contains("semaphore") ||
          e.toString().contains("timeout")) {
        Get.snackbar(
          "Network Error",
          "Cannot reach server. Check your network connection.",
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to load dashboard data",
        );
      }
    }

    // ===================================================
    // FINALLY
    // ===================================================

    finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // REFRESH
  // =====================================================

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
