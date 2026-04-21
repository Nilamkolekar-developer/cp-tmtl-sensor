import 'dart:io';
import 'dart:typed_data';
import 'package:CP_TMTL_Sensor_Zig/AppPreferences/app_areferences.dart';
import 'package:CP_TMTL_Sensor_Zig/common_widgets/popup.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/settingsController.dart';
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

  CameraController? cameraController;
  var sensorResults = <Map<String, dynamic>>[].obs;

  // ✅ ADD these to TestRecipeController (where recipeList is defined)

@override
void onInit() {
  super.onInit();
  _loadRecipes(); // add this line to existing onInit
}
  var recipeList = <Recipe>[].obs;
Future<void> _loadRecipes() async {
  final List<Recipe> saved = await AppPreferences.getRecipes();
  if (saved.isNotEmpty) {
    recipeList.assignAll(saved);
    print("✅ Restored ${saved.length} recipes");
  }
}

Future<void> persistRecipes() async {
  await AppPreferences.saveRecipes(recipeList.toList());
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

  void validateESN() {
    String esn = esnTextFieldController.text.trim();
    if (esn.isEmpty) return;

    serialNumber.value = "SN-$esn";
    variantCode.value = "V-B8_DIESEL";
    modelNumber.value = "TD 2.2 L3";

    // The 15 Sensor Specification List
    sensorResults.assignAll([
      {
        "sr": 1,
        "part": "Camshaft speed",
        "reg": 13,
        "m": 1.0,
        "c": 0.0,
        "min": 700.0,
        "max": 1100.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 2,
        "part": "Crankshaft speed",
        "reg": 14,
        "m": 1.0,
        "c": 0.0,
        "min": 700.0,
        "max": 1100.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 3,
        "part": "Coolant temperature",
        "reg": 15,
        "m": 1.0,
        "c": 0.0,
        "min": 1000.0,
        "max": 4000.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 4,
        "part": "Charge air pressure",
        "reg": 16,
        "m": 0.1,
        "c": 0.0,
        "min": 0.7,
        "max": 4.5,
        "unit": "V",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 5,
        "part": "Charge air temperature",
        "reg": 17,
        "m": 1.0,
        "c": 0.0,
        "min": 1000.0,
        "max": 3500.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 6,
        "part": "Fuel rail pressure",
        "reg": 18,
        "m": 0.01,
        "c": 0.0,
        "min": 0.4,
        "max": 0.6,
        "unit": "V",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 7,
        "part": "Low fuel pressure",
        "reg": 19,
        "m": 0.01,
        "c": 0.0,
        "min": 0.4,
        "max": 0.6,
        "unit": "V",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 8,
        "part": "Engine oil pressure",
        "reg": 20,
        "m": 0.01,
        "c": 0.0,
        "min": 0.4,
        "max": 0.6,
        "unit": "V",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 9,
        "part": "Injector cylinder 1",
        "reg": 21,
        "m": 1.0,
        "c": 0.0,
        "min": -3.0,
        "max": 1.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 10,
        "part": "Injector cylinder 2",
        "reg": 22,
        "m": 1.0,
        "c": 0.0,
        "min": -3.0,
        "max": 1.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 11,
        "part": "Injector cylinder 3",
        "reg": 23,
        "m": 1.0,
        "c": 0.0,
        "min": -3.0,
        "max": 1.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 12,
        "part": "MPROP actuator",
        "reg": 24,
        "m": 1.0,
        "c": 0.0,
        "min": 2.0,
        "max": 4.0,
        "unit": "Ohm",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 13,
        "part": "EGR voltage",
        "reg": 25,
        "m": 0.1,
        "c": 0.0,
        "min": 4.0,
        "max": 12.0,
        "unit": "V",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 14,
        "part": "EGR current",
        "reg": 26,
        "m": 0.1,
        "c": 0.0,
        "min": -1.0,
        "max": 2.5,
        "unit": "A",
        "val": "-",
        "status": "PENDING"
      },
      {
        "sr": 15,
        "part": "Starter relay current",
        "reg": 27,
        "m": 0.01,
        "c": 0.0,
        "min": 1.21,
        "max": 1.63,
        "unit": "A",
        "val": "-",
        "status": "PENDING"
      }
    ]);

    isValidated.value = true;
    Get.snackbar("Success", "Barcode Detected: $esn",
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white);
  }

  Future<void> startTestingSequence() async {
    final plcCtrl = Get.find<PLCController>();

    // Safety 1: Pre-check Connection
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

      // Safety 2: Mid-loop Connection Check
      if (!plcCtrl.isConnected.value) {
        _handleAbort("PLC connection lost during testing.");
        return;
      }

      sensor['status'] = "TESTING...";
      sensor['val'] = "-";
      sensorResults.refresh();

      sendGeneratorDataRequest(regAddr);

      // --- WAIT FOR RESPONSE (3s Timeout) ---
      int timeout = 0;
      bool received = false;
      while (timeout < 30) {
        await Future.delayed(const Duration(milliseconds: 100));

        if (!plcCtrl.isConnected.value) {
          _handleAbort(
              "Socket disconnected while waiting for Register $regAddr.");
          return;
        }

        if (sensor['val'] != "-") {
          received = true;
          break;
        }
        timeout++;
      }

      // Safety 3: Stop immediately on No Response
      if (!received) {
        sensor['status'] = "FAIL: TIMEOUT";
        sensorResults.refresh();
        _showPopup("Sequence Halted",
            "No response for ${sensor['part']}. Testing stopped.", true);
        isTesting.value = false;
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    isTesting.value = false;
    _showPopup("Complete", "Full verification finished successfully.", false);
  }

  void handlePlcData(int reg, int rawX) {
    int index = sensorResults.indexWhere((s) => s['reg'] == reg);
    if (index != -1) {
      var s = sensorResults[index];

      // Scaling: y = mx + c
      double m = s['m'] ?? 1.0;
      double c = s['c'] ?? 0.0;
      double y = (m * rawX) + c;

      s['val'] = "${y.toStringAsFixed(2)} ${s['unit']}";
      s['status'] = (y >= s['min'] && y <= s['max']) ? "OK" : "NOT OK";

      sensorResults.refresh();
    }
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
      0x0a
    ];
    plcCtrl.sendPacket(packet);
  }

  void _handleAbort(String msg) {
    isTesting.value = false;
    _showPopup("Test Aborted", msg, true);
  }

  void _showPopup(String title, String msg, bool isError) {
    Get.dialog(CustomPopup(title: title, message: msg, isError: isError));
  }
}
