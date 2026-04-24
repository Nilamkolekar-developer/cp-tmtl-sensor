import 'dart:io';
import 'dart:typed_data';
import 'package:CP_TMTL_Sensor_Zig/common_widgets/popup.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/settingsController.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:CP_TMTL_Sensor_Zig/models/receipe_model.dart';
import 'package:CP_TMTL_Sensor_Zig/themes/app_textstyles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:zxing_lib/zxing.dart';
import 'package:zxing_lib/common.dart';
import 'package:file_picker/file_picker.dart';

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
  var selectedRecipe = Rxn<Recipe>();
  CameraController? cameraController;
  var sensorResults = <Map<String, dynamic>>[].obs;

  // ✅ ADD these to TestRecipeController (where recipeList is defined)

  @override
  void onInit() {
    super.onInit();
// add this line to existing onInit
  }

  void loadSensorsFromRecipe() {
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
          //"reg": s.registerNumber,
          "m": s.multiplier,
          "c": s.offset,
          "min": s.min,
          "max": s.max,
          "unit": s.unit,
          "val": "-",
          "status": "PENDING"
        };

        print("📡 [SENSOR LOADED] $map"); // 👈 important debug per sensor
        return map;
      }).toList(),
    );

    print("🎯 [FINAL] Total sensors mapped: ${sensorResults.length}");
    print("🚀 Sensors successfully loaded for model: ${recipe.model}");
  }

  void validateESN() {
    String esn = esnTextFieldController.text.trim();
    if (esn.isEmpty) return;

    serialNumber.value = "SN-$esn";

    // Logic to determine model based on ESN content
    if (esn.contains("9780070602205")) {
      modelNumber.value = "TD 2.2 L3";
      variantCode.value = "V-B8_DIESEL";
    } else if (esn.contains("STATHNL000002088")) {
      modelNumber.value = "TCD 2.2 L4";
      variantCode.value = "V-C1_DIESEL";
    } else if (esn.startsWith("9781119550822")) {
      modelNumber.value = "TCD 2.9 L4";
      variantCode.value = "V-IND_99";
    } else {
      modelNumber.value = "Default Model";
      variantCode.value = "V-GENERIC";
    }

    loadSensorsFromRecipe(); // This will now load based on the updated model/variant
    isValidated.value = true;
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

  // --- 3. LIVE WEBCAM SCANNER ---
  Future<void> sc() async {
    if (isScanning.value) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showPopup("Hardware Error", "No webcam found.", true);
        return;
      }

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isScanning.value = true;

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

  // Inside ESNController
  bool _isHandlingSuccess = false;

  // --- 1. THE SCAN LOOP ---
  Future<void> _runScanLoop() async {
    _isHandlingSuccess = false;

    while (isScanning.value) {
      // If a barcode was found by camera or gallery, kill the loop immediately
      if (_isHandlingSuccess ||
          cameraController == null ||
          !cameraController!.value.isInitialized) {
        break;
      }

      try {
        final XFile file = await cameraController!.takePicture();
        final Uint8List bytes = await file.readAsBytes();

        // If _decodeFromBytes returns TRUE, it means barcode was found
        if (_decodeFromBytes(bytes)) {
          _isHandlingSuccess = true;
          _handleAutoClose(); // Trigger the immediate close
          break;
        }
      } catch (e) {
        print("Scanning...");
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // --- 2. THE AUTO-CLOSE HANDLER ---
  void _handleAutoClose() {
    print("DEBUG: _handleAutoClose called.");

    // Update state first
    isScanning.value = false;

    // Check if dialog is open
    bool isOpen = Get.isDialogOpen ?? false;
    print("DEBUG: Is Get.dialog open? $isOpen");

    if (isOpen) {
      Get.back();
      print("DEBUG: Get.back() executed.");
    } else {
      print("DEBUG: Get.back() skipped because isDialogOpen was false.");
    }

    // Cleanup Hardware
    if (cameraController != null) {
      print("DEBUG: Disposing CameraController.");
      cameraController?.dispose();
      cameraController = null;
    }
  }

  // --- 3. GALLERY SCANNER (The Fix) ---
  Future<void> pickFromGallery() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        final bytes = await File(result.files.single.path!).readAsBytes();

        if (_decodeFromBytes(bytes)) {
          // If gallery finds a barcode, trigger the SAME auto-close logic
          _isHandlingSuccess = true;
          _handleAutoClose();
        } else {
          // Get.snackbar("Error", "No barcode found in image.",
          //     backgroundColor: Colors.orange, colorText: Colors.white);
        }
      }
    } catch (e) {
      print("Gallery Error: $e");
    }
  }

  void _closeScannerUI() {
    isScanning.value = false;
    _isHandlingSuccess = true;
    if (Get.isDialogOpen ?? false) Get.back();
    Future.delayed(const Duration(milliseconds: 300), () => _disposeCamera());
  }

  void _disposeCamera() {
    if (cameraController != null) {
      cameraController!.dispose();
      cameraController = null;
    }
  }

  // Future<void> startTestingSequence() async {
  //   final plcCtrl = Get.find<PLCController>();

  //   // Safety 1: Pre-check Connection
  //   if (!plcCtrl.isConnected.value || plcCtrl.socket == null) {
  //     _showPopup("Hardware Offline",
  //         "Please connect to the PLC before starting.", true);
  //     return;
  //   }

  //   if (isTesting.value) return;
  //   isTesting.value = true;

  //   for (int i = 0; i < sensorResults.length; i++) {
  //     var sensor = sensorResults[i];
  //     int regAddr = sensor['reg'];

  //     // Safety 2: Mid-loop Connection Check
  //     if (!plcCtrl.isConnected.value) {
  //       _handleAbort("PLC connection lost during testing.");
  //       return;
  //     }

  //     sensor['status'] = "TESTING...";
  //     sensor['val'] = "-";
  //     sensorResults.refresh();

  //     sendGeneratorDataRequest(regAddr);

  //     // --- WAIT FOR RESPONSE (3s Timeout) ---
  //     int timeout = 0;
  //     bool received = false;
  //     while (timeout < 30) {
  //       await Future.delayed(const Duration(milliseconds: 100));

  //       if (!plcCtrl.isConnected.value) {
  //         _handleAbort(
  //             "Socket disconnected while waiting for Register $regAddr.");
  //         return;
  //       }

  //       if (sensor['val'] != "-") {
  //         received = true;
  //         break;
  //       }
  //       timeout++;
  //     }

  //     // Safety 3: Stop immediately on No Response
  //     if (!received) {
  //       sensor['status'] = "FAIL: TIMEOUT";
  //       sensorResults.refresh();
  //       _showPopup("Sequence Halted",
  //           "No response for ${sensor['part']}. Testing stopped.", true);
  //       isTesting.value = false;
  //       return;
  //     }

  //     await Future.delayed(const Duration(milliseconds: 500));
  //   }

  //   isTesting.value = false;
  //   _showPopup("Complete", "Full verification finished successfully.", false);
  // }

  var responseMap = <int, bool>{}.obs;

//   void handlePlcData(int reg, int rawX) {
//     int index = sensorResults.indexWhere((s) => s['reg'] == reg);
//     if (index == -1) {
//       print("❌ [DEBUG] No sensor found for Register: $reg");
//       return;
//     }

//     var s = sensorResults[index];
//     s['raw'] = rawX;

//     String typeStr = (s['type'] ?? s['formula'] ?? "").toString().toLowerCase();
//     String name = s['sensorName'] ?? "Unknown Sensor";
//     double actualValue = 0.0;

//     print("\n===================================================");
//     print("🔍 [PROCESSING] Name: $name | Register: $reg");
//     print("📥 [PLC RAW] Value: $rawX");

//     if (typeStr.contains("resistance")) {
//       // ── STEP 1: Determine R1 Fallback ──
//       double defaultR1 = 1000.0;
//       if (typeStr.contains("resistance(2200)")) {
//         defaultR1 = 2200.0;
//       } else if (typeStr.contains("resistance(100)")) {
//         defaultR1 = 100.0;
//       }

//       // ── STEP 2: Get Params ──
//       // Priority: multiplier from UI > default based on type string > 1000.0
//       // ── STEP 1: Determine R1 ──
//       double r1 = (s['multiplier'] as num?)?.toDouble() ?? defaultR1;
//       print("🧩 STEP 1: R1 Calculation");
//       print("   -> Multiplier from sensor: ${s['multiplier']}");
//       print("   -> Default R1: $defaultR1");
//       print("   -> Final R1 used: $r1 Ω");

// // ── STEP 2: Determine Vin ──
//       double vin = (s['offset'] as num?)?.toDouble() ?? 5.0;
//       print("🧩 STEP 2: Vin Calculation");
//       print("   -> Offset from sensor: ${s['offset']}");
//       print("   -> Final Vin used: $vin V");

// // ── STEP 3: Raw to Voltage Conversion ──
//       double rawVoltage = rawX.toDouble() / 1000.0;
//       double vout = rawVoltage - 0.0001;

//       print("🧩 STEP 3: Vout Calculation");
//       print("   -> Raw PLC value: $rawX");
//       print("   -> Converted to Voltage (raw/1000): $rawVoltage V");
//       print("   -> Calibration offset: -0.0001 V");
//       print("   -> Final Vout: ${vout.toStringAsFixed(6)} V");

// // ── STEP 4: Safety Constraints ──
//       print("🧩 STEP 4: Safety Check");

//       if (vout >= vin) {
//         print("   ⚠️ Vout >= Vin ($vout >= $vin), applying clamp");
//         vout = vin - 0.001;
//       }

//       if (vout < 0) {
//         print("   ⚠️ Vout < 0 ($vout), setting to 0");
//         vout = 0.0;
//       }

//       print("   -> Vout after safety: ${vout.toStringAsFixed(6)} V");

// // ── STEP 5: Denominator Calculation ──
//       double denominator = vin - vout;

//       print("🧩 STEP 5: Denominator");
//       print("   -> Vin - Vout = $vin - $vout = $denominator");

// // ── STEP 6: Final Resistance Calculation ──
//       actualValue = (r1 * vout) / denominator;

//       print("🧩 STEP 6: Final R2 Calculation");
//       print("   -> Formula: (R1 × Vout) / (Vin - Vout)");
//       print("   -> Substitution: ($r1 × $vout) / ($denominator)");
//       print("   -> Final R2: ${actualValue.toStringAsFixed(2)} Ω");
// //       double r1 = (s['multiplier'] as num?)?.toDouble() ?? defaultR1;
// //       double vin = (s['offset'] as num?)?.toDouble() ?? 5.0;

// // // raw → voltage
// //       double vout = (rawX.toDouble() / 1000.0) - 0.0001;

// //       print("⚙️ [MODE] RESISTANCE");
// //       print("   -> Params: R1=$r1 Ω, Vin=$vin V");
// //       print("   -> Computed Vout: ${vout.toStringAsFixed(6)} V");

// // // PURE FORMULA (no safety)
// //       double denominator = vin - vout;
// //       double actualValue = (r1 * vout) / denominator;

// //       print("   -> Math: ($r1 * $vout) / ($vin - $vout)");
// //       print("   -> Result (R2): ${actualValue.toStringAsFixed(2)} Ω");
//     } else {
//       // ── CASE 2: LINEAR (y = mx + c) ──
//       print("⚙️ [MODE] LINEAR");

//       // ── STEP 1: Raw Value ──
//       print("🧩 STEP 1: Raw Input");
//       print("   -> Raw PLC Value: $rawX");

//       // ── STEP 2: Signed Conversion ──
//       int signedRaw = rawX > 32767 ? rawX - 65536 : rawX;

//       print("🧩 STEP 2: Signed Conversion");
//       print("   -> Raw Value: $rawX");
//       print("   -> Converted Signed Value: $signedRaw");

//       if (rawX > 32767) {
//         print(
//             "   ⚠️ Value exceeded 16-bit range, converted using 2's complement");
//       }

//       // ── STEP 3: Get m and c ──
//       double m = (s['multiplier'] as num?)?.toDouble() ?? 0.001;
//       double c = (s['offset'] as num?)?.toDouble() ?? 0.0;

//       print("🧩 STEP 3: Parameters");
//       print("   -> Multiplier (m): ${s['multiplier']}");
//       print("   -> Offset (c): ${s['offset']}");
//       print("   -> Final m used: $m");
//       print("   -> Final c used: $c");

//       // ── STEP 4: Apply Formula ──
//       print("🧩 STEP 4: Linear Calculation");
//       print("   -> Formula: y = (m × x) + c");
//       print("   -> Substitution: ($m × $signedRaw) + $c");

//       actualValue = (m * signedRaw) + c;

//       print("   -> Result (Actual Value): ${actualValue.toStringAsFixed(4)}");
//     }

// // ── STEP 5: Update UI Value ──
//     s['val'] = actualValue.toStringAsFixed(2);

//     print("🧩 STEP 5: UI Update");
//     print("   -> Display Value (rounded): ${s['val']}");

// // ── STEP 6: Range Check ──
//     double minL = (s['min'] as num?)?.toDouble() ?? 0.0;
//     double maxL = (s['max'] as num?)?.toDouble() ?? 0.0;

//     print("🧩 STEP 6: Range Validation");
//     print("   -> Min Limit: $minL");
//     print("   -> Max Limit: $maxL");

//     bool isOk = (actualValue >= minL && actualValue <= maxL);

//     print(
//         "   -> Condition: $minL <= ${actualValue.toStringAsFixed(4)} <= $maxL");
//     print("   -> Result: ${isOk ? "WITHIN RANGE" : "OUT OF RANGE"}");

// // ── STEP 7: Status Update ──
//     s['status'] = isOk ? "OK" : "NOT OK";

//     print("🧩 STEP 7: Final Status");
//     print("   -> Status: ${s['status']} ${isOk ? '✅' : '❌'}");

// // ── FINAL SUMMARY ──
//     print("📊 [FINAL SUMMARY]");
//     print("   -> Sensor: ${s['part']}");
//     print("   -> Register: ${s['reg']}");
//     print("   -> Final Value: ${s['val']}");
//     print("   -> Limits: [$minL to $maxL]");
//     print("   -> Status: ${s['status']}");
//     print("===================================================\n");

//     sensorResults.refresh();
//     //else {
//     //     // ── CASE 2: LINEAR (y = mx + c) ──
//     //     print("⚙️ [MODE] LINEAR");

//     //     // Convert to signed 16-bit
//     //     int signedRaw = rawX > 32767 ? rawX - 65536 : rawX;

//     //     double m = (s['multiplier'] as num?)?.toDouble() ?? 0.001;
//     //     double c = (s['offset'] as num?)?.toDouble() ?? 0.0;

//     //     actualValue = (m * signedRaw) + c;

//     //     print("   -> Params: m=$m, c=$c");
//     //     print("   -> Result: ${actualValue.toStringAsFixed(2)}");
//     //   }

//     //   // ── UPDATE UI DATA ──
//     //   s['val'] = actualValue.toStringAsFixed(2);

//     //   double minL = (s['min'] as num?)?.toDouble() ?? 0.0;
//     //   double maxL = (s['max'] as num?)?.toDouble() ?? 0.0;

//     //   bool isOk = (actualValue >= minL && actualValue <= maxL);
//     //   s['status'] = isOk ? "OK" : "NOT OK";

//     //   print("📊 [FINAL STATUS]");
//     //   print("   -> Display Value: ${s['val']}");
//     //   print("   -> Range Limits: [$minL to $maxL]");
//     //   print("   -> Status: ${s['status']} ${isOk ? '✅' : '❌'}");
//     //   print("===================================================\n");

//     //   sensorResults.refresh();
//   }
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

      actualValue = (r1 * vout) / denominator;

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

  // void sendGeneratorDataRequest(int registerAddress) {
  //   final plcCtrl = Get.find<PLCController>();
  //   if (!plcCtrl.isConnected.value) return;

  //   int hi = (registerAddress >> 8) & 0xFF;
  //   int lo = registerAddress & 0xFF;

  //   List<int> packet = [
  //     0x00,
  //     0x01,
  //     0x00,
  //     0x00,
  //     0x00,
  //     0x06,
  //     0x01,
  //     0x03,
  //     0x00,
  //     0x04,
  //     0x00,
  //     0x01
  //   ];
  //   plcCtrl.sendPacket(packet);
  // }

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

  // Future<bool> _runEgrSequence(Map<String, dynamic> sensor) async {
  //   try {
  //     const int readRegister = 36; // EGR current
  //     const int writeRegister = 317; // EGR control

  //    // print("🚀 [EGR] Step 1: Initial Read");

  //     // Step 1: Read initial value
  //     // sensor['val'] = "-";
  //     // sendGeneratorDataRequest(readRegister);

  //     // bool gotFirst = await _waitForResponse(readRegister);
  //     // if (!gotFirst) return false;

  //     // double before = double.tryParse(sensor['val'] ?? "0") ?? 0;

  //     // print("📊 Initial EGR Value: $before");

  //     // Step 2: Activate EGR
  //     print("✍️ [EGR] Activating...");
  //     writeGeneratorDataRequest(writeRegister, 1);

  //     await Future.delayed(const Duration(seconds: 2));

  //     // Step 3: Read after activation
  //     sensor['val'] = "-";
  //     sendGeneratorDataRequest(readRegister);

  //     bool gotSecond = await _waitForResponse(readRegister);
  //     if (!gotSecond) return false;

  //     double after = double.tryParse(sensor['val'] ?? "0") ?? 0;

  //     print("📊 After Activation: $after");

  //     // Step 4: Reset
  //     print("🔄 [EGR] Resetting...");
  //     writeGeneratorDataRequest(writeRegister, 0);

  //     print("✅ EGR test passed");
  //     return true;
  //   } catch (e) {
  //     print("❌ EGR Exception: $e");
  //     return false;
  //   }
  // }
  Future<bool> _runEgrSequence(Map<String, dynamic> sensor) async {
    try {
      const int readRegister = 36;
      const int writeRegister = 317;

      print("✍️ [EGR] Activating...");

      // STEP 1: ON
      await writeGeneratorDataRequest(writeRegister, 1);
      await Future.delayed(const Duration(seconds: 5));

      // STEP 2: READ
      sensor['val'] = "-";
      sendGeneratorDataRequest(readRegister);

      bool ok = await _waitForResponse(readRegister);
      if (!ok) {
        print("❌ No response after activation");
        return false;
      }

      double value = double.tryParse(sensor['val'].toString()) ?? 0;
      sensor['val'] = value.toStringAsFixed(2);
      print("📊 EGR VALUE: $value");

      // ✅ VALIDATION (THIS WAS MISSING)
      const double min = 1.21;
      const double max = 1.63;

      bool isOk = value >= min && value <= max;

      print("📏 RANGE: $min - $max");
      print("📊 STATUS: ${isOk ? "PASS ✅" : "FAIL ❌"}");

      // STEP 3: RESET
      print("🔄 Resetting...");
      await writeGeneratorDataRequest(writeRegister, 0);

      return isOk; // 🔥 IMPORTANT FIX
    } catch (e) {
      print("❌ EGR Exception: $e");
      return false;
    }
  }
//   Future<bool> _runEgrSequence(Map<String, dynamic> sensor) async {
//   try {
//     const int readRegister = 36;
//     const int writeRegister = 317;

//     print("🚀 [EGR] Initial Read");

//     // RESET STATE
//     sensor['val'] = null;
//     sensor['isUpdated'] = false;

//     sendGeneratorDataRequest(readRegister);

//     bool ok1 = await _waitForFreshResponse(sensor);
//     if (!ok1) return false;

//     double before = double.tryParse(sensor['val'].toString()) ?? 0;

//     print("📊 Before: $before");

//     print("✍️ Activating EGR");
//     writeGeneratorDataRequest(writeRegister, 1);

//     await Future.delayed(const Duration(milliseconds: 800));

//     sensor['val'] = null;
//     sensor['isUpdated'] = false;

//     sendGeneratorDataRequest(readRegister);

//     bool ok2 = await _waitForFreshResponse(sensor);
//     if (!ok2) return false;

//     double after = double.tryParse(sensor['val'].toString()) ?? 0;

//     print("📊 After: $after");

//     print("🔄 Reset EGR");
//     writeGeneratorDataRequest(writeRegister, 0);

//     return true;
//   } catch (e) {
//     print("❌ EGR Error: $e");
//     return false;
//   }
// }


  Future<bool> _readWithTimeout(int regAddr) async {
    final plcCtrl = Get.find<PLCController>();

    sendGeneratorDataRequest(regAddr);

    int timeout = 0;

    while (timeout < 30) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!plcCtrl.isConnected.value) {
        return false;
      }

      int index = sensorResults.indexWhere((s) => s['reg'] == regAddr);

      if (index != -1 && sensorResults[index]['val'] != "-") {
        return true;
      }

      timeout++;
    }

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

  Future<void> startTestingSequence() async {
    final plcCtrl = Get.find<PLCController>();

    // ✅ Safety 1: Pre-check Connection
    if (!plcCtrl.isConnected.value || plcCtrl.socket == null) {
      _showPopup("Hardware Offline",
          "Please connect to the PLC before starting.", true);
      return;
    }

    if (isTesting.value) return;
    isTesting.value = true;

    for (int i = 0; i < sensorResults.length; i++) {
      var sensor = sensorResults[i];
      int regAddr = sensor['reg'];
      String partName = (sensor['part'] ?? "").toString().toLowerCase();

      // ✅ Safety 2: Mid-loop connection check
      if (!plcCtrl.isConnected.value) {
        _handleAbort("PLC connection lost during testing.");
        return;
      }

      // Reset UI
      sensor['status'] = "TESTING...";
      sensor['val'] = "-";
      sensorResults.refresh();

      // if (partName.contains("starter") && partName.contains("relay")) {
      //   print("⚡ [STARTER RELAY DETECTED] Running EGR sequence...");

      //   bool success = await _runEgrSequence(sensor);

      //   if (!success) {
      //     sensor['status'] = "NOT OK";
      //     sensor['val'] = "FAIL";
      //     sensorResults.refresh();

      //     _showPopup("Sequence Halted", "Starter relay test failed.", true);

      //     isTesting.value = false;
      //     return;
      //   }

      //   sensor['status'] = "OK";
      //   sensor['val'] = value.toStringAsFixed(2);
      //   sensorResults.refresh();

      //   continue;
      // }
      if (partName.contains("starter") && partName.contains("relay")) {
  print("⚡ [STARTER RELAY DETECTED] Running EGR sequence...");

  bool success = await _runEgrSequence(sensor);

  if (!success) {
    sensor['status'] = "NOT OK";
    // ❌ DO NOT clear value
    sensorResults.refresh();

    _showPopup("Sequence Halted", "Starter relay test failed.", true);

    isTesting.value = false;
    return;
  }

  sensor['status'] = "OK";
  // ❌ DO NOT clear value
  sensorResults.refresh();

  continue;
}
      // =====================================================
      // ✅ NORMAL SENSOR FLOW
      // =====================================================
      bool received = await _readWithTimeout(regAddr);

      if (!received) {
        sensor['status'] = "FAIL: TIMEOUT";
        sensorResults.refresh();

        _showPopup("Sequence Halted",
            "No response for ${sensor['part']}. Testing stopped.", true);

        isTesting.value = false;
        return;
      }

      await Future.delayed(const Duration(milliseconds: 400));
    }

    isTesting.value = false;
    _showPopup("Complete", "Full verification finished successfully.", false);
  }
}
