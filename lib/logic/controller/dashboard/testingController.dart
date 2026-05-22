import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cp_tmtl_sensor_zig/AppPreferences/app_areferences.dart';
import 'package:cp_tmtl_sensor_zig/api/app_envirments.dart';
import 'package:cp_tmtl_sensor_zig/api/app_urls.dart';
import 'package:cp_tmtl_sensor_zig/api/dev/dev_service.dart';
import 'package:cp_tmtl_sensor_zig/common_widgets/popup.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/settingsController.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:cp_tmtl_sensor_zig/models/receipe_model.dart';
import 'package:cp_tmtl_sensor_zig/routes/routes_string.dart';
import 'package:cp_tmtl_sensor_zig/themes/app_textstyles.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:zxing_lib/zxing.dart';
import 'package:zxing_lib/common.dart';

class ESNController extends GetxController {
  final esnTextFieldController = TextEditingController();
  final FocusNode esnFocusNode = FocusNode();

  // Reactive States
  var isValidated = false.obs;
  var isTesting = false.obs;
  var isScanning = false.obs;

  var serialNumber = "-".obs;
  var variantCode = "-".obs;
  var modelNumber = "-".obs;
  var modelValidationId = "-".obs;
  var selectedRecipe = Rxn<Recipe>();
  CameraController? cameraController;
  var sensorResults = <Map<String, dynamic>>[].obs;

  // ✅ ADD these to TestRecipeController (where recipeList is defined)
// In ESNController
var expandedSensors = <String>{}.obs;

void toggleSensorExpanded(String key) {
  if (expandedSensors.contains(key)) {
    expandedSensors.remove(key);
  } else {
    expandedSensors.add(key);
  }
}
  @override
  void onInit() {
    super.onInit();
// add this line to existing onInit
  }

  // loadSensorsFromRecipe() {
  //   final testCtrl = Get.find<TestRecipeController>();

  //   print("🔍 [LOAD] Requested model: ${modelNumber.value}");
  //   print("📦 [AVAILABLE RECIPES]: ${testCtrl.recipeList.length}");

  //   final recipe = testCtrl.recipeList.firstWhereOrNull(
  //     (r) => r.model == modelNumber.value,
  //   );

  //   if (recipe == null) {
  //     print("❌ [LOAD FAILED] No recipe found for model: ${modelNumber.value}");
  //     Get.snackbar("Error", "No matching recipe found for model");
  //     return;
  //   }

  //   selectedRecipe.value = recipe;

  //   print("✅ [RECIPE FOUND]");
  //   print("➡️ Model: ${recipe.model}");
  //   print("➡️ Sensor count: ${recipe.sensors.length}");

  //   sensorResults.assignAll(
  //     recipe.sensors.map((s) {
  //       final map = {
  //         "reg": s.registerNumber,
  //         "part": s.sensorName,
  //         "type": s.sensorType,
  //         //"reg": s.registerNumber,
  //         "m": s.multiplier,
  //         "c": s.offset,
  //         "min": s.min,
  //         "max": s.max,
  //         "unit": s.unit,
  //         "val": "-",
  //         "status": "PENDING"
  //       };

  //       print("📡 [SENSOR LOADED] $map"); // 👈 important debug per sensor
  //       return map;
  //     }).toList(),
  //   );

  //   print("🎯 [FINAL] Total sensors mapped: ${sensorResults.length}");
  //   print("🚀 Sensors successfully loaded for model: ${recipe.model}");
  // }
  loadSensorsFromRecipe() {
    final testCtrl = Get.find<TestRecipeController>();

    print("🔍 [LOAD] Requested model: ${modelNumber.value}");
    print("📦 [AVAILABLE RECIPES]: ${testCtrl.recipeList.length}");

    final recipe = testCtrl.recipeList.firstWhereOrNull(
      (r) => r.model == modelNumber.value,
    );

    if (recipe == null) {
      print("❌ [LOAD FAILED] No recipe found for model: ${modelNumber.value}");
      Get.snackbar("Error", "No matching recipe found for model");
      return;
    }

    selectedRecipe.value = recipe;

    print("✅ [RECIPE FOUND]");
    print("➡️ Model: ${recipe.model}");
    print("➡️ Sensor count: ${recipe.sensors.length}");

    sensorResults.assignAll(
      recipe.sensors.map((s) {
        final map = {
          "reg": s.registerNumber,
          "part": s.sensorName,
          "type": s.sensorType,
          "m": s.multiplier,
          "c": s.offset,
          "min": s.min,
          "max": s.max,
          "unit": s.unit,
          "val": "-",
          "status": "PENDING",
          "operations": s.operations, // ✅ ADD THIS
        };

        print(
            "📡 [SENSOR LOADED] reg=${map['reg']} | part=${map['part']} | ops=${(map['operations'] as List).length}");
        return map;
      }).toList(),
    );

    print("🎯 [FINAL] Total sensors mapped: ${sensorResults.length}");
    print("🚀 Sensors successfully loaded for model: ${recipe.model}");
  }

  // void validateESN() {
  //   String esn = esnTextFieldController.text.trim();
  //   if (esn.isEmpty) return;

  //   serialNumber.value = "SN-$esn";

  //   // Logic to determine model based on ESN content
  //   if (esn.contains("9780070602205")) {
  //     modelNumber.value = "TD 2.2 L3";
  //     variantCode.value = "V-B8_DIESEL";
  //   } else if (esn.contains("STATHNL000002088")) {
  //     modelNumber.value = "TCD 2.2 L4";
  //     variantCode.value = "V-C1_DIESEL";
  //   } else if (esn.startsWith("9781119550822")) {
  //     modelNumber.value = "TCD 2.9 L4";
  //     variantCode.value = "V-IND_99";
  //   } else {
  //     modelNumber.value = "Default Model";
  //     variantCode.value = "V-GENERIC";
  //   }

  //   loadSensorsFromRecipe(); // This will now load based on the updated model/variant
  //   isValidated.value = true;
  // }
  RxBool isLoading = false.obs;
  // Future<void> validateESN() async {
  //   String esn = esnTextFieldController.text.trim();
  //   if (esn.isEmpty) {
  //     Get.snackbar("Error", "Please enter an ESN",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }

  //   final String formattedEsn = "SN-$esn";

  //   try {
  //     isLoading.value = true;
  //     print("📡 [ESN VALIDATION] Sending: $formattedEsn");

  //     String? savedToken = await AppPreferences.getToken();
  //     final String baseUrl = AppEnvironment.baseUrl;
  //     final String validateUrl = "$baseUrl${AppURLs.engineNumberCheck}";
  //     final response = await http.post(
  //       Uri.parse(validateUrl),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //         // Prefix must be exactly "JWT " followed by your token
  //         "Authorization": "JWT $savedToken",
  //       },
  //       body: jsonEncode({"engine_serial_no": formattedEsn}),
  //     );  

  //     print("📡 [RESPONSE] Status: ${response.statusCode}");
  //     print("📡 [RESPONSE] Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);

  //       if (responseData['success'] == true && responseData['data'] != null) {
  //         final data = responseData['data'];

  //         serialNumber.value = formattedEsn;

  //         // ✅ Updated keys to match typical Autopeepal API patterns
  //         // Ensure these keys match exactly what the /validate/ ESN response returns
  //         modelNumber.value = data['model_no']?.toString() ?? "Unknown Model";
  //         variantCode.value =
  //             data['variant_code']?.toString() ?? "Unknown Variant";
  //         modelValidationId.value = responseData['data']['id'].toString();

  //         print(
  //             "✅ [ESN DATA] Model: ${modelNumber.value}, Variant: ${variantCode.value}");

  //         await loadSensorsFromRecipe();
  //         isValidated.value = true;

  //         Get.snackbar("Success", "ESN Validated",
  //             backgroundColor: Colors.green, colorText: Colors.white);
  //       } else {
  //         Get.snackbar("Invalid ESN",
  //             responseData['message'] ?? "No data found for this ESN",
  //             backgroundColor: Colors.orange);
  //       }
  //     } else if (response.statusCode == 401) {
  //       // ⚠️ Handle Session Expired
  //       print("🚨 [UNAUTHORIZED] Token is invalid or expired.");
  //       Get.snackbar("Session Expired", "Please login again",
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);

  //       // Clear token and redirect to login
  //       await AppPreferences.clearToken();
  //       Get.offAllNamed(Routes.loginScreen);
  //     } else {
  //       Get.snackbar(
  //           "Server Error", "Something went wrong (${response.statusCode})",
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     print("❌ [ESN VALIDATION ERROR] $e");
  //     Get.snackbar("Error", "Failed to connect to server");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> validateESN() async {
  String esn = esnTextFieldController.text.trim();
  if (esn.isEmpty) {
    Get.snackbar("Error", "Please enter an ESN",
        backgroundColor: Colors.redAccent, colorText: Colors.white);
    return;
  }

  final String formattedEsn = "SN-$esn";
  final requestBody = {"engine_serial_no": formattedEsn};

  try {
    isLoading.value = true;
    print("📡 [ESN VALIDATION] Sending: $formattedEsn");

    String? savedToken = await AppPreferences.getToken();
    final String validateUrl = "${AppEnvironment.baseUrl}${AppURLs.engineNumberCheck}";

    final response = await http.post(
      Uri.parse(validateUrl),
      headers: { 
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "JWT $savedToken",
      },
      body: jsonEncode(requestBody),
    );

    print("📡 [RESPONSE] Status: ${response.statusCode}");
    print("📡 [RESPONSE] Body: ${response.body}");

    // ✅ Log to DevScreen
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
      path: AppURLs.engineNumberCheck,
      dateTime: DateTime.now(),
      data: requestBody,
      response: parsedResponse,
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'];

        serialNumber.value = formattedEsn;
        modelNumber.value = data['model_no']?.toString() ?? "Unknown Model";
        variantCode.value = data['variant_code']?.toString() ?? "Unknown Variant";
        modelValidationId.value = data['id']?.toString() ?? "";

        print("✅ [ESN DATA] Model: ${modelNumber.value}, Variant: ${variantCode.value}");

        await loadSensorsFromRecipe();
        isValidated.value = true;

        Get.snackbar("Success", "ESN Validated",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar(
          "Invalid ESN",
          responseData['message'] ?? "No data found for this ESN",
          backgroundColor: Colors.orange,
        );
      }
    } else if (response.statusCode == 401) {
      print("🚨 [UNAUTHORIZED] Token is invalid or expired.");
      await AppPreferences.clearToken();
      Get.snackbar("Session Expired", "Please login again",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      Get.offAllNamed(Routes.loginScreen);

    } else {
      Get.snackbar(
        "Server Error", "Something went wrong (${response.statusCode})",
        backgroundColor: Colors.redAccent, colorText: Colors.white,
      );
    }
  } on SocketException {
    // ✅ Log network error
    DevService.instance.insertAPICall(AppAPIsCall(
      id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
      type: 'POST ERROR',
      path: AppURLs.engineNumberCheck,
      dateTime: DateTime.now(),
      data: requestBody,
      response: {"error": "SocketException", "message": "No internet connection"},
    ));
    Get.snackbar("No Connection", "Check your internet and try again",
        backgroundColor: Colors.redAccent, colorText: Colors.white);

  } on TimeoutException {
    // ✅ Log timeout
    DevService.instance.insertAPICall(AppAPIsCall(
      id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
      type: 'POST TIMEOUT',
      path: AppURLs.engineNumberCheck,
      dateTime: DateTime.now(),
      data: requestBody,
      response: {"error": "TimeoutException", "message": "Request timed out"},
    ));
    Get.snackbar("Timeout", "Server took too long to respond",
        backgroundColor: Colors.orange, colorText: Colors.white);

  } catch (e) {
    // ✅ Log exception
    DevService.instance.insertAPICall(AppAPIsCall(
      id: "${DateTime.now().millisecondsSinceEpoch} ${DateTime.now().toIso8601String()}",
      type: 'POST EXCEPTION',
      path: AppURLs.engineNumberCheck,
      dateTime: DateTime.now(),
      data: requestBody,
      response: {"error": "Exception", "message": e.toString()},
    ));
    print("❌ [ESN VALIDATION ERROR] $e");
    Get.snackbar("Error", "Failed to connect to server");

  } finally {
    isLoading.value = false;
  }
}

  // --- 1. THE DECODING ENGINE (Pure Dart) ---
  bool _decodeFromBytes(Uint8List bytes) {
    try {
      final img.Image? baseImage = img.decodeImage(bytes);
      if (baseImage == null) {
        print("SCAN_DEBUG: Decoder failed to process image bytes.");
        return false;
      }

      final img.Image processedImage = img.grayscale(baseImage);
      final Int32List pixels =
          Int32List(processedImage.width * processedImage.height);

      int index = 0;
      for (final pixel in processedImage) {
        pixels[index++] = pixel.r.toInt();
      }

      LuminanceSource source = RGBLuminanceSource(
        processedImage.width,
        processedImage.height,
        pixels,
      );

      BinaryBitmap bitmap = BinaryBitmap(HybridBinarizer(source));
      final reader = MultiFormatReader();
      final Result result = reader.decode(bitmap);

      if (result.text.isNotEmpty) {
        print("SCAN_DEBUG: Successfully decoded text: ${result.text}");
        esnTextFieldController.text = result.text;
        return true;
      }
    } catch (e) {
      // Normal: ZXing throws an exception if no barcode is found in the image
    }
    return false;
  }

  Future<void> sc() async {
    if (isScanning.value) return;
    _isProcessing = false; // ✅ Reset guard
    _isHandlingSuccess = false; // ✅ Reset flag

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showPopup("Hardware Error", "No webcam found.", true);
        return;
      }

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.low, // ✅ LOW = smallest file = fastest delete
        enableAudio: false,
        imageFormatGroup: Platform.isWindows
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      isScanning.value = true;

      // ... rest of your dialog code unchanged ...
      Get.dialog(
        Obx(() => AlertDialog(
              title: const Text("Scan Engine Barcode"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: (isScanning.value &&
                            cameraController != null &&
                            cameraController!.value.isInitialized)
                        ? CameraPreview(cameraController!)
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 15),
                  const Text("Align barcode and hold steady (20cm)"),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: Text("Select from Gallery",
                        style: TextStyles.textfieldTextStyle),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _closeScannerUI,
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.red)),
                )
              ],
            )),
        barrierDismissible: false,
      );

      _runScanLoop();
    } catch (e) {
      _showPopup("Camera Error", "Hardware access denied.", true);
    }
  }

  Future<void> _runScanLoop() async {
    _isHandlingSuccess = false;

    try {
      // ✅ Try streaming first (works on mobile + newer Windows camera plugin)
      await cameraController!.startImageStream((CameraImage cameraImage) async {
        if (_isHandlingSuccess) return;

        try {
          final Uint8List bytes = _convertCameraImageToBytes(cameraImage);
          if (_decodeFromBytes(bytes)) {
            _isHandlingSuccess = true;
            await cameraController?.stopImageStream();
            _handleAutoClose();
          }
        } catch (e) {
          // Skip bad frames silently
        }
      });

      print("✅ [SCAN] Image stream started successfully.");
    } catch (e) {
      // ✅ Stream not supported — use frame grab loop (no file saving)
      print("⚠️ [SCAN] Stream failed ($e). Using frame grab fallback.");
      _runCaptureFallbackLoop();
    }
  }

  bool _isProcessing = false; // ✅ Prevent overlapping decode calls

  Future<void> _runCaptureFallbackLoop() async {
    while (isScanning.value && !_isHandlingSuccess) {
      if (cameraController == null || !cameraController!.value.isInitialized)
        break;
      if (_isProcessing) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      _isProcessing = true;

      try {
        final XFile file = await cameraController!.takePicture();
        final String filePath = file.path;
        final Uint8List bytes = await File(filePath).readAsBytes();

        // ✅ Delete immediately before decoding
        try {
          await File(filePath).delete();
        } catch (_) {}

        if (_decodeFromBytes(bytes)) {
          _isHandlingSuccess = true;
          _handleAutoClose();
          break;
        }
      } catch (e) {
        print("📸 Frame grab: $e");
      } finally {
        _isProcessing = false;
      }

      await Future.delayed(const Duration(milliseconds: 700));
    }
  }

// Helper: Convert YUV CameraImage to JPEG/PNG-like bytes
  Uint8List _convertCameraImageToBytes(CameraImage cameraImage) {
    final img.Image image = img.Image(
      width: cameraImage.width,
      height: cameraImage.height,
    );

    final plane = cameraImage.planes[0]; // Y plane (luminance)
    final bytes = plane.bytes;

    for (int y = 0; y < cameraImage.height; y++) {
      for (int x = 0; x < cameraImage.width; x++) {
        final int pixelValue = bytes[y * plane.bytesPerRow + x];
        image.setPixelRgb(x, y, pixelValue, pixelValue, pixelValue);
      }
    }

    return Uint8List.fromList(img.encodeJpg(image));
  }

  // Inside ESNController
  bool _isHandlingSuccess = false;

  void _handleAutoClose() {
    print("DEBUG: _handleAutoClose called.");
    isScanning.value = false;
    _isProcessing = false;

    // ✅ Clean up any leftover camera temp files on Windows
    if (Platform.isWindows) {
      _cleanWindowsTempImages();
    }

    bool isOpen = Get.isDialogOpen ?? false;
    if (isOpen) {
      Get.back();
      print("DEBUG: Get.back() executed.");
    }

    if (cameraController != null) {
      cameraController?.dispose();
      cameraController = null;
    }
  }

  void _cleanWindowsTempImages() {
    try {
      // Windows camera plugin saves to %TEMP% folder
      final tempDir = Directory(Platform.environment['TEMP'] ?? '');
      if (!tempDir.existsSync()) return;

      tempDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.jpeg'))
          .forEach((f) {
        try {
          f.deleteSync();
        } catch (_) {}
      });

      print("🧹 Temp images cleaned.");
    } catch (e) {
      print("⚠️ Cleanup error: $e");
    }
  }

  void _closeScannerUI() {
    _isHandlingSuccess = true;
    isScanning.value = false;

    _safeStopStream().then((_) {
      if (Get.isDialogOpen ?? false) Get.back();
      Future.delayed(const Duration(milliseconds: 300), () => _disposeCamera());
    });
  }

  Future<void> _safeStopStream() async {
    try {
      if (cameraController != null &&
          cameraController!.value.isInitialized &&
          cameraController!.value.isStreamingImages) {
        await cameraController!.stopImageStream();
      }
    } catch (e) {
      print("⚠️ stopImageStream error (safe): $e");
    }
  }

  Future<void> pickFromGallery() async {
    try {
      await _safeStopStream();
      isScanning.value = false;

      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.path != null) {
        final bytes = await File(result.files.single.path!).readAsBytes();

        if (_decodeFromBytes(bytes)) {
          _handleAutoClose();
        } else {
          print("❌ No barcode found in selected image");
          isScanning.value = true;
          _runScanLoop();
        }
      } else {
        // User cancelled — restart
        isScanning.value = true;
        _runScanLoop();
      }
    } catch (e) {
      print("Gallery Error: $e");
    }
  }

  void _disposeCamera() {
    if (cameraController != null) {
      cameraController!.dispose();
      cameraController = null;
    }
  }

  var responseMap = <int, bool>{}.obs;
 

  void handlePlcData(int reg, int rawX) {
    int index = sensorResults.indexWhere((s) => s['reg'] == reg);
    if (index == -1) {
      print("❌ [DEBUG] No sensor found for Register: $reg");
      return;
    }

    var s = sensorResults[index];
    s['raw'] = rawX;

    String typeStr = (s['type'] ?? s['formula'] ?? "").toString().toLowerCase();
    String name = s['sensorName'] ?? "Unknown Sensor";

    double actualValue = 0.0;

    print("\n===================================================");
    print("🔍 [PROCESSING] Name: $name | Register: $reg");
    print("📥 [PLC RAW] Value: $rawX");

    // =====================================================
    // ⚡ CURRENT SENSOR
    // =====================================================
    if (typeStr.contains("current")) {
      print("⚡ [MODE] CURRENT SENSOR");
      // Print typeStr
      print("🧩 typeStr = $typeStr");

      // STEP 1: Raw Input
      print("🧩 STEP 1: Raw Input");
      print("   -> Raw PLC Value: $rawX");

      // STEP 2: Voltage conversion
      double vout = rawX.toDouble() / 1000.0;
      print("🧩 STEP 2: Voltage Conversion");
      print("   -> Vout = rawX / 1000 = $vout V");

      // STEP 3: Offset
      double offset = 2.5;
      print("🧩 STEP 3: Offset Removal");
      print("   -> Offset = $offset V");
      print("   -> Vout - Offset = ${vout - offset}");

      // STEP 4: Current Formula
      print("🧩 STEP 4: Current Calculation");
      print("   -> Formula: I = (Vout - 2.5) / 0.185");
      print("   -> Substitution: ($vout - $offset) / 0.185");

      actualValue = (vout - offset) / 0.185;

      print("   -> Result Current: ${actualValue.toStringAsFixed(4)} A");
    }

    // =====================================================
    // 🔌 RESISTANCE SENSOR
    // =====================================================
    else if (typeStr.contains("resistance")) {
      print("⚙️ [MODE] RESISTANCE");

      // Print typeStr
      print("🧩 typeStr = $typeStr"); 

      double defaultR1 = 1000.0;
      if (typeStr.contains("resistance(2200)")) {
        defaultR1 = 2200.0;
      } else if (typeStr.contains("resistance(100)")) {
        defaultR1 = 100.0;
      }

      // STEP 1: R1
      double r1 = (s['multiplier'] as num?)?.toDouble() ?? defaultR1;
      print("🧩 STEP 1: R1 = $r1");

      // STEP 2: Vin
      double vin = (s['offset'] as num?)?.toDouble() ?? 5.0;
      print("🧩 STEP 2: Vin = $vin");

      // STEP 3: Vout
      double vout = (rawX.toDouble() / 1000.0) - 0.0001;
      print("🧩 STEP 3: Vout = $vout");

      if (vout >= vin) vout = vin - 0.001;
      if (vout < 0) vout = 0;

      // STEP 4: Formula
      double denominator = vin - vout;
      print("🧩 STEP 4: Denominator = $denominator");


      //actualValue = (r1 * vout) / denominator;
      // STEP 5: Final Resistance Value without decimal
       actualValue = ((r1 * vout) / denominator).round().toDouble();
      

      print("🧩 STEP 5: Resistance Result = $actualValue Ω");
    }

    // =====================================================
    // 📊 LINEAR SENSOR
    // =====================================================
    else {
      print("⚙️ [MODE] LINEAR");

      // STEP 1: Raw
      print("🧩 STEP 1: Raw = $rawX");

      // STEP 2: Signed conversion
      int signedRaw = rawX > 32767 ? rawX - 65536 : rawX;
      print("🧩 STEP 2: Signed = $signedRaw");

      // STEP 3: Params
      double m = (s['multiplier'] as num?)?.toDouble() ?? 0.001;
      double c = (s['offset'] as num?)?.toDouble() ?? 0.0;

      print("🧩 STEP 3: m = $m, c = $c");

      // STEP 4: Formula
      print("🧩 STEP 4: y = (m × x) + c");
      actualValue = (m * signedRaw) + c;

      print("   -> Result = $actualValue");
    }

    // =====================================================
    // 🖥 UI UPDATE
    // =====================================================
    s['val'] = actualValue.toStringAsFixed(2);

    print("🧩 STEP 5: UI Value = ${s['val']}");

    // =====================================================
    // 📊 RANGE CHECK (optional logic kept)
    // =====================================================
    double minL = (s['min'] as num?)?.toDouble() ?? 0.0;
    double maxL = (s['max'] as num?)?.toDouble() ?? 0.0;

    bool isOk = (actualValue >= minL && actualValue <= maxL);

    s['status'] = isOk ? "OK" : "NOT OK";

    print("🧩 STEP 6: Range Check");
    print("   -> Min: $minL");
    print("   -> Max: $maxL");
    print("   -> Status: ${s['status']}");

    print("===================================================\n");

    sensorResults.refresh();
  }

  void sendGeneratorDataRequest(int registerAddress) {
    final plcCtrl = Get.find<PLCController>();
    if (!plcCtrl.isConnected.value) return;

    int hi = (registerAddress >> 8) & 0xFF;
    int lo = registerAddress & 0xFF;

    List<int> packet = [
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x06,
      0x01,
      0x03,
      hi,
      lo,
      0x00,
      0x01
    ];

    plcCtrl.currentRegister = registerAddress; // ⭐ ADD THIS
    plcCtrl.sendPacket(packet);
  }

  void _handleAbort(String msg) {
    isTesting.value = false;
    _showPopup("Test Aborted", msg, true);
  }

  void _showPopup(String title, String msg, bool isError) {
    Get.dialog(CustomPopup(title: title, message: msg, isError: isError));
  }

  void _showErrorPopup() {
    Get.dialog(CustomPopup(
      title: "PLC Offline",
      message: "Hardware communication lost. Check connection.",
      isError: true,
    ));
  }

  writeGeneratorDataRequest(int registerAddress, int valueToWrite) {
    final plcCtrl = Get.find<PLCController>();
    if (!plcCtrl.isConnected.value) {
      _showErrorPopup();
      return;
    }

    final int hiAddr = (registerAddress >> 8) & 0xFF;
    final int loAddr = registerAddress & 0xFF;
    final int hiVal = (valueToWrite >> 8) & 0xFF;
    final int loVal = valueToWrite & 0xFF;

    final List<int> packet = [
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x06,
      0x01,
      0x06,
      hiAddr,
      loAddr,
      hiVal,
      loVal,
    ];

    final String hexCommand = packet
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');

    print("DEBUG: Sending Write Command to PLC");
    print("HEX DATA: [ $hexCommand ]");
    print("TARGET REGISTER: $registerAddress | VALUE: $valueToWrite");

    plcCtrl.sendPacket(packet);
  }

  Future<void> runEgrTestSequence() async {
    final plcCtrl = Get.find<PLCController>();

    if (!plcCtrl.isConnected.value) {
      _showErrorPopup();
      return;
    }

    const int readRegister = 36; // EGR current register
    const int writeRegister = 317; // EGR control register

    print("🚀 [TEST START] EGR Sequence initiated");

    // STEP 1: Initial Read
    print("📥 STEP 1: Reading initial EGR value");
    sendGeneratorDataRequest(readRegister);

    await _waitForResponse(readRegister);

    // STEP 2: Activate EGR
    print("✍️ STEP 2: Activating EGR");
    writeGeneratorDataRequest(writeRegister, 1);

    await Future.delayed(const Duration(seconds: 1));

    // STEP 3: Read after activation
    print("📥 STEP 3: Reading after activation");
    sendGeneratorDataRequest(readRegister);

    await _waitForResponse(readRegister);

    // STEP 4: Deactivate EGR
    print("🔄 STEP 4: Deactivating EGR");
    writeGeneratorDataRequest(writeRegister, 0);

    await Future.delayed(const Duration(seconds: 1));

    // STEP 5: Final Read
    print("📥 STEP 5: Final read after reset");
    sendGeneratorDataRequest(readRegister);

    await _waitForResponse(readRegister);

    print("✅ [TEST COMPLETE] EGR sequence finished");
  }

//   Future<void> sendResultsToServer() async {
//   if (sensorResults.isEmpty) {
//     print("⚠️ [SAVE] Aborted: sensorResults list is empty.");
//     Get.snackbar("No Data", "No test results to save",
//         backgroundColor: Colors.orange);
//     return;
//   }

//   if (modelValidationId.value.isEmpty) {
//     print("⚠️ [SAVE] Aborted: modelValidationId is empty.");
//     Get.snackbar("Error", "Validation ID missing. Re-validate ESN.",
//         backgroundColor: Colors.redAccent);
//     return;
//   }

//   try {
//     isLoading.value = true;
//     print("🚀 [SAVE START] Preparing payload for ID: ${modelValidationId.value}");

//     // 1. Map data
//     List<Map<String, dynamic>> payload = sensorResults.map((s) => {
//           "register": int.tryParse(s['reg'].toString()) ?? 0,
//           "component": s['part'].toString(),
//           "min": double.tryParse(s['min'].toString()) ?? 0.0,
//           "max": double.tryParse(s['max'].toString()) ?? 0.0,
//           "value": double.tryParse(s['val'].toString()) ?? 0.0,
//           "result": s['status'].toString(),
//         }).toList();

//     // Verification Print: See exactly what JSON is going out
//     String jsonPayload = jsonEncode(payload);
//     print("📦 [PAYLOAD]: $jsonPayload");

//     // 2. Setup URL and Token
//     final String url = "http://139.59.76.174:8080/api/v1/support/create/${modelValidationId.value}/model-validation-session/";
//     String? token = await AppPreferences.getToken();

//     print("🌐 [URL]: $url");
//     print("🔑 [AUTH]: JWT ${token?.substring(0, 10)}..."); // Printing only start of token for security

//     // 3. Make Request
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "JWT $token",
//       },
//       body: jsonPayload,
//     );

//     // 4. Response Logs
//     print("📡 [RESPONSE STATUS]: ${response.statusCode}");
//     print("📡 [RESPONSE BODY]: ${response.body}");

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       print("✅ [SAVE SUCCESS] Data accepted by server.");
//       Get.snackbar("Success", "Test results saved successfully",
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } else {
//       print("❌ [SAVE FAILED] Server returned an error.");
//       Get.snackbar("Error", "Failed to save data. (${response.statusCode})",
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     }
//   } catch (e) {
//     print("🔥 [EXCEPTION] Error in sendResultsToServer: $e");
//     Get.snackbar("Error", "An unexpected error occurred");
//   } finally {
//     isLoading.value = false;
//     print("🏁 [SAVE END] isLoading set to false.");
//   }
// }
  Future<void> sendResultsToServer() async {
    if (sensorResults.isEmpty) return;

    // 1. Prepare payload exactly like before
    List<Map<String, dynamic>> payload = sensorResults
        .map((s) => {
              "register": int.tryParse(s['reg'].toString()) ?? 0,
              "component": s['part'].toString(),
              "min": double.tryParse(s['min'].toString()) ?? 0.0,
              "max": double.tryParse(s['max'].toString()) ?? 0.0,
              "value": double.tryParse(s['val'].toString()) ?? 0.0,
              "result": s['status'].toString(),
            })
        .toList();

    final String url =
        "http://139.59.76.174:8080/api/v1/support/create/${modelValidationId.value}/model-validation-session/";

    try {
      isLoading.value = true;
      String? token = await AppPreferences.getToken();

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "JWT $token"
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Data synced to server",
            backgroundColor: Colors.green);
      } else {
        throw HttpException("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      // 🔴 OFFLINE DETECTED or SERVER DOWN
      print("📡 [OFFLINE] Saving to sync queue: $e");
      await _saveToSyncQueue(url, payload);

      Get.snackbar(
          "Offline Mode", "Results saved locally. Will sync when online.",
          backgroundColor: Colors.orange, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

// Save a failed request to a local file
  Future<void> _saveToSyncQueue(
      String url, List<Map<String, dynamic>> payload) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sync_queue.json');

      List<dynamic> queue = [];
      if (await file.exists()) {
        queue = jsonDecode(await file.readAsString());
      }

      // Add this request to the list
      queue.add({
        "url": url,
        "payload": payload,
        "timestamp": DateTime.now().toIso8601String(),
      });

      await file.writeAsString(jsonEncode(queue));
      print("📦 [QUEUE] Total pending items: ${queue.length}");
    } catch (e) {
      print("❌ [QUEUE ERROR] $e");
    }
  }

// Background task to push data when server is active
  Future<void> syncOfflineData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sync_queue.json');

      if (!await file.exists()) return;

      List<dynamic> queue = jsonDecode(await file.readAsString());
      if (queue.isEmpty) return;

      print("🔄 [SYNC] Attempting to push ${queue.length} pending items...");
      String? token = await AppPreferences.getToken();
      List<dynamic> remainingItems = [];

      for (var item in queue) {
        try {
          final response = await http
              .post(
                Uri.parse(item['url']),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "JWT $token"
                },
                body: jsonEncode(item['payload']),
              )
              .timeout(const Duration(seconds: 5));

          if (response.statusCode != 200 && response.statusCode != 201) {
            remainingItems.add(item); // Keep it in queue if server still errors
          }
        } catch (e) {
          remainingItems.add(item); // Keep it in queue if still offline
        }
      }

      // Update the file with whatever didn't sync
      await file.writeAsString(jsonEncode(remainingItems));

      if (remainingItems.length < queue.length) {
        Get.snackbar("Sync Complete", "Offline records updated on server",
            backgroundColor: Colors.blue);
      }
    } catch (e) {
      print("❌ [SYNC ERROR] $e");
    }
  }

  // Future<bool> _readWithTimeout(int regAddr) async {
  //   final plcCtrl = Get.find<PLCController>();

  //   sendGeneratorDataRequest(regAddr);

  //   int timeout = 0;

  //   while (timeout < 30) {
  //     await Future.delayed(const Duration(milliseconds: 100));

  //     if (!plcCtrl.isConnected.value) {
  //       return false;
  //     }

  //     int index = sensorResults.indexWhere((s) => s['reg'] == regAddr);

  //     if (index != -1 && sensorResults[index]['val'] != "-") {
  //       return true;
  //     }

  //     timeout++;
  //   }

  //   return false;
  // }

  // Future<bool> _readWithTimeout(int regAddr) async {
  //   final plcCtrl = Get.find<PLCController>();

  //   print(
  //       "📤 [READ REQUEST] Reg: $regAddr | PLC Connected: ${plcCtrl.isConnected.value}");

  //   // ✅ Guard: don't even try if PLC offline
  //   if (!plcCtrl.isConnected.value) {
  //     print("❌ [READ SKIP] PLC not connected for reg: $regAddr");
  //     return false;
  //   }

  //   sendGeneratorDataRequest(regAddr);

  //   int timeout = 0;

  //   while (timeout < 50) {
  //     // ✅ Increased from 30 to 50 (5 seconds total)
  //     await Future.delayed(const Duration(milliseconds: 100));

  //     int index = sensorResults.indexWhere((s) => s['reg'] == regAddr);

  //     if (index != -1 && sensorResults[index]['val'] != "-") {
  //       print(
  //           "✅ [READ OK] Reg: $regAddr | Val: ${sensorResults[index]['val']} | Attempts: $timeout");
  //       return true;
  //     }

  //     timeout++;
  //     if (timeout % 10 == 0) {
  //       print("⏳ [WAITING] Reg: $regAddr | Attempt: $timeout/50");
  //     }
  //   }

  //   print("⌛ [TIMEOUT] No response for reg: $regAddr after ${timeout * 100}ms");
  //   return false;
  // }

  Future<bool> _readWithTimeout(int regAddr) async {
    final plcCtrl = Get.find<PLCController>();

    print("📤 [READ REQUEST] Reg: $regAddr | PLC Connected: ${plcCtrl.isConnected.value}");

    if (!plcCtrl.isConnected.value) {
      print("❌ [READ SKIP] PLC not connected");
      return false;
    }

    sendGeneratorDataRequest(regAddr);

    int timeout = 0;
    while (timeout < 50) { // 5 seconds total
      await Future.delayed(const Duration(milliseconds: 100));

      // We look for the sensor that is currently assigned this register
      int index = sensorResults.indexWhere((s) => s['reg'] == regAddr);

      if (index != -1 && sensorResults[index]['val'] != "-") {
        print("✅ [READ OK] Reg: $regAddr | Val: ${sensorResults[index]['val']}");
        return true;
      }

      timeout++;
      if (timeout % 10 == 0) {
        print("⏳ [WAITING] Reg: $regAddr | Attempt: $timeout/50");
      }
    }

    print("⌛ [TIMEOUT] No response for reg: $regAddr");
    return false;
  }

  Future<bool> _waitForResponse(int reg) async {
    int timeout = 0;

    while (timeout < 30) {
      await Future.delayed(const Duration(milliseconds: 5));

      int index = sensorResults.indexWhere((s) => s['reg'] == reg);

      if (index != -1 && sensorResults[index]['val'] != "-") {
        return true;
      }

      timeout++;
    }

    return false;
  }

  // Future<void> startTestingSequence() async {
  //   final plcCtrl = Get.find<PLCController>();

  //   if (!plcCtrl.isConnected.value) {
  //     _showPopup("Hardware Offline", "Connect PLC first", true);
  //     return;
  //   }

  //   if (isTesting.value) return;
  //   isTesting.value = true;

  //   for (var sensor in sensorResults) {
  //     List operations = sensor['operations'] ?? [];

  //     print("\n🚀 [SENSOR START] ${sensor['part']}");

  //     for (int i = 0; i < operations.length; i++) {
  //       var op = operations[i];

  //       String operation = op.operation; // READ / WRITE
  //       int reg = int.tryParse(op.registerAddress) ?? sensor['reg'];
  //       int value = int.tryParse(op.value) ?? 0;

  //       print("▶️ Step ${i + 1}: $operation | Reg: $reg | Val: $value");

  //       // UI update
  //       sensor['status'] = "TESTING...";
  //       sensorResults.refresh();

  //       // =========================
  //       // 🔵 READ
  //       // =========================
  //       if (operation == "READ") {
  //         bool received = await _readWithTimeout(reg);

  //         if (!received) {
  //           sensor['status'] = "TIMEOUT";
  //           sensorResults.refresh();

  //           _handleAbort("Timeout at ${sensor['part']}");
  //           return;
  //         }
  //       }

  //       // =========================
  //       // 🟠 WRITE
  //       // =========================
  //       else if (operation == "WRITE") {
  //         writeGeneratorDataRequest(reg, value);

  //         await Future.delayed(const Duration(milliseconds: 500));
  //       }

  //       await Future.delayed(const Duration(milliseconds: 300));
  //     }

  //     // ✅ After all operations for this specific sensor are done
  //     sensor['status'] = "OK";
  //     sensorResults.refresh();
  //   }

  //   // ✅ SEQUENCE COMPLETE
  //   isTesting.value = false;

  //   // --- AUTOMATIC API CALL ---
  //   print("📡 [AUTO-SAVE] Sequence complete. Sending data to server...");
  //   await sendResultsToServer();

  //   _showPopup(
  //       "Complete", "Sequence executed and data saved successfully", false);
  // }

Future<void> startTestingSequence() async {
    final plcCtrl = Get.find<PLCController>();

    if (!plcCtrl.isConnected.value) {
      _showPopup("Hardware Offline", "Connect PLC first", true);
      return;
    }

    if (isTesting.value) return;
    isTesting.value = true;

    for (var sensor in sensorResults) {
      List operations = sensor['operations'] ?? [];
      print("\n🚀 [SENSOR START] ${sensor['part']}");

      // ✅ Store the original primary register to restore it later
      final int originalPrimaryReg = sensor['reg'] ?? 0;
      bool sensorPassed = true;

      for (int i = 0; i < operations.length; i++) {
        var op = operations[i];
        String operation = op.operation;
        int currentStepReg = int.tryParse(op.registerAddress) ?? originalPrimaryReg;
        int value = int.tryParse(op.value) ?? 0;

        print("▶️ Step ${i + 1}: $operation | Reg: $currentStepReg");

        sensor['status'] = "TESTING...";
        sensorResults.refresh();

        // --- WRITE OPERATION ---
        if (operation == "WRITE") {
          writeGeneratorDataRequest(currentStepReg, value);
          await Future.delayed(const Duration(milliseconds: 600));
        } 
        
        // --- READ OPERATION ---
        else if (operation == "READ") {
          // 🛡️ TRICK: Temporarily set the sensor's main reg to the step's reg
          // This allows 'handlePlcData' to find this sensor in the list.
          sensor['reg'] = currentStepReg;
          sensor['val'] = "-"; 
          sensorResults.refresh();

          bool received = await _readWithTimeout(currentStepReg);

          if (!received) {
            // Restore original reg before aborting
            sensor['reg'] = originalPrimaryReg;
            sensor['status'] = "TIMEOUT";
            sensorResults.refresh();
            _handleAbort("Timeout at register $currentStepReg");
            return;
          }

          // Logic Comparison (Pass/Fail check)
          double? actual = double.tryParse(sensor['val'].toString());
          double? min = (sensor['min'] as num?)?.toDouble();
          double? max = (sensor['max'] as num?)?.toDouble();

          if (actual != null && min != null && max != null) {
            if (actual < min || actual > max) {
              sensorPassed = false;
            }
          }
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // ✅ CRITICAL: Restore the original primary register after all steps are done
      sensor['reg'] = originalPrimaryReg;
      
      // Final result for this sensor
      sensor['status'] = sensorPassed ? "OK" : "NOT OK";
      sensorResults.refresh();
      print("🏁 [SENSOR DONE] ${sensor['part']} -> ${sensor['status']}");
    }

    isTesting.value = false;
    await sendResultsToServer();
    _showPopup("Complete", "Sequence executed and data saved successfully", false);
  }

  Future<void> startTestingSequence1() async {
  final plcCtrl = Get.find<PLCController>();

  if (!plcCtrl.isConnected.value) {
    _showPopup("Hardware Offline", "Connect PLC first", true);
    return;
  }

  if (isTesting.value) return;
  isTesting.value = true;

  for (var sensor in sensorResults) {
    List operations = sensor['operations'] ?? [];

    print("\n🚀 [SENSOR START] ${sensor['part']}");

    // ✅ Reset sensor state before starting
    sensor['val']    = "-";
    sensor['status'] = "TESTING...";
    sensorResults.refresh();

    bool sensorPassed = true;

    for (int i = 0; i < operations.length; i++) {
      var op = operations[i];

      String operation = op.operation;
      int reg   = int.tryParse(op.registerAddress) ?? (sensor['reg'] ?? 0);
      int value = int.tryParse(op.value) ?? 0;

      print("▶️ Step ${i + 1}: $operation | Reg: $reg | Val: $value");

      sensor['status'] = "TESTING...";
      sensorResults.refresh();

      // ── WRITE ────────────────────────────────────────────────────────
      if (operation == "WRITE") {
        writeGeneratorDataRequest(reg, value);
        sensor['status'] = "WRITING...";
        sensorResults.refresh();
        print("📤 WRITE reg=$reg value=$value");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // ── READ ─────────────────────────────────────────────────────────
      else if (operation == "READ") {
        // ✅ Reset val before reading so we get fresh data
        sensor['val'] = "-";
        sensorResults.refresh();

        bool received = await _readWithTimeout(reg);

        if (!received) {
          sensor['status'] = "TIMEOUT";
          sensor['val']    = "--";
          sensorResults.refresh();
          _handleAbort("Timeout at ${sensor['part']}");
          isTesting.value = false;
          return;
        }

        // ✅ handlePlcData already calculated & stored val — just use it
        String rawVal = sensor['val']?.toString() ?? "-";
        double? actualValue = double.tryParse(rawVal);

        print("📥 READ reg=$reg | Calculated val=$actualValue");

        // ✅ Compare with min/max from sensor map
        double? minVal = (sensor['min'] as num?)?.toDouble();
        double? maxVal = (sensor['max'] as num?)?.toDouble();

        if (actualValue != null && minVal != null && maxVal != null) {
          bool isInRange = actualValue >= minVal && actualValue <= maxVal;

          if (isInRange) {
            sensor['status'] = "OK";
            print("✅ PASS — $actualValue within [$minVal, $maxVal] ${sensor['unit'] ?? ''}");
          } else {
            sensor['status'] = "NOT OK";
            sensorPassed = false;
            print("❌ FAIL — $actualValue outside [$minVal, $maxVal] ${sensor['unit'] ?? ''}");
          }
        } else if (actualValue != null) {
          // No min/max defined — just store OK
          sensor['status'] = "OK";
          print("ℹ️ No min/max defined — val=$actualValue stored as OK");
        } else {
          sensor['status'] = "NOT OK";
          sensorPassed = false;
          print("❌ Could not parse val: $rawVal");
        }

        sensorResults.refresh();
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    // ✅ Final result for this sensor after all operations
    sensor['status'] = sensorPassed ? "OK" : "NOT OK";
    sensorResults.refresh();

    print("${sensorPassed ? '✅' : '❌'} [SENSOR DONE] ${sensor['part']} → ${sensor['status']}");
  }

  // ✅ All sensors done
  isTesting.value = false;
  print("📡 [AUTO-SAVE] Sequence complete. Sending to server...");
  await sendResultsToServer();
  _showPopup("Complete", "Sequence executed and data saved successfully", false);

}


  // Future<void> startTestingSequence() async {
  //   final plcCtrl = Get.find<PLCController>();

  //   if (!plcCtrl.isConnected.value) {
  //     _showPopup("Hardware Offline", "Connect PLC first", true);
  //     return;
  //   }

  //   if (isTesting.value) return;
  //   isTesting.value = true;

  //   for (var sensor in sensorResults) {
  //     List operations = sensor['operations'] ?? [];

  //     print("\n🚀 [SENSOR START] ${sensor['part']}");

  //     for (int i = 0; i < operations.length; i++) {
  //       var op = operations[i];

  //       String operation = op.operation; // READ / WRITE
  //       int reg = int.tryParse(op.registerAddress) ?? sensor['reg'];
  //       int value = int.tryParse(op.value) ?? 0;

  //       print("▶️ Step ${i + 1}: $operation | Reg: $reg | Val: $value");

  //       // UI update
  //       sensor['status'] = "TESTING...";
  //       sensorResults.refresh();

  //       // =========================
  //       // 🔵 READ
  //       // =========================
  //       if (operation == "READ") {
  //         bool received = await _readWithTimeout(reg);

  //         if (!received) {
  //           sensor['status'] = "TIMEOUT";
  //           sensorResults.refresh();

  //           _handleAbort("Timeout at ${sensor['part']}");
  //           return;
  //         }
  //       }

  //       // =========================
  //       // 🟠 WRITE
  //       // =========================
  //       else if (operation == "WRITE") {
  //         writeGeneratorDataRequest(reg, value);

  //         await Future.delayed(const Duration(milliseconds: 500));
  //       }

  //       await Future.delayed(const Duration(milliseconds: 300));
  //     }

  //     // ✅ After all operations
  //     sensor['status'] = "OK";
  //     sensorResults.refresh();
  //   }

  //   isTesting.value = false;

  //   _showPopup("Complete", "Sequence executed successfully", false);
  // }
}
