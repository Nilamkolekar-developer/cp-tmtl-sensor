import 'dart:async';
import 'package:autopeepal/common_widgets/popup.dart';
import 'package:autopeepal/logic/controller/dashboard/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SensorAnalysisController extends GetxController {
  // --- FORM CONTROLLERS ---
  final modelController = TextEditingController().obs;
  final typeController = TextEditingController().obs;
  final sensorName = TextEditingController().obs;
  final sensorType = TextEditingController().obs;
  final registerNumber = TextEditingController().obs;
  final multiplier = TextEditingController().obs;
  final offset = TextEditingController().obs;
  final min = TextEditingController().obs;
  final max = TextEditingController().obs;
  final unit = TextEditingController().obs;

  // --- UI & SELECTION STATE ---
  var addedSensors = <Map<String, dynamic>>[].obs;
  var isAddingSensor = false.obs;
  var isAnalyzing = false.obs;

  // --- RECIPE LOGIC ---

  // --- ANALYSIS DATA ---
  var activeSensor = <String, dynamic>{}.obs;
  var liveDataPoints = <double>[].obs;
  Timer? _timer;

  void fillFormFromRecipeSensor(Map<String, dynamic> sensor) {
    sensorName.value.text = sensor['name'];
    sensorType.value.text = sensor['type'];
    registerNumber.value.text = sensor['register'];
    min.value.text = sensor['min'].toString();
    max.value.text = sensor['max'].toString();
    unit.value.text = sensor['unit'];
  }

  void saveSensorToTable() {
    addedSensors.add({
      'name': sensorName.value.text,
      'type': sensorType.value.text,
      'register': registerNumber.value.text,
      'min': double.tryParse(min.value.text) ?? 0.0,
      'max': double.tryParse(max.value.text) ?? 100.0,
      'unit': unit.value.text,
      'samplingRate': 1.0,
    });
    _clearForm();
    isAddingSensor.value = false;
  }

  void _clearForm() {
    sensorName.value.clear();
    sensorType.value.clear();
    registerNumber.value.clear();
    min.value.clear();
    max.value.clear();
    unit.value.clear();
  }

  var isChoosingFromRecipe = false.obs;
  final ScrollController chartScrollController = ScrollController();

  var isPaused = false.obs;
  var isStreaming = false.obs; // Tracks if the connection is active
  var maxDataPoints = 5000.obs; // Controls the "scroll" window size

  // Call this method when new data arrives from your hardware/API
  void onDataReceived(double newValue) {
    if (isPaused.value || !isStreaming.value) return;

    liveDataPoints.add(newValue);

    // Creates the scrolling effect by removing old data
    // if (liveDataPoints.length > maxDataPoints) {
    //   liveDataPoints.removeAt(0);
    // }
  }

  var liveMin = 0.0.obs;
  var liveMax = 0.0.obs;

  // void startAnalysis(Map<String, dynamic> sensor) {
  //   activeSensor.value = sensor;
  //   isAnalyzing.value = true;
  //   isStreaming.value = true;
  //   isPaused.value = false;

  //   // Reset data and stats
  //   liveDataPoints.clear();
  //   liveMin.value = double.infinity;
  //   liveMax.value = -double.infinity;

  //   // 1. 🔥 EXTRACT DYNAMIC SAMPLING RATE
  //   // Pull from the sensor map (defaulting to 1.0 if null)
  //   double rateInSeconds = sensor['samplingRate'] ?? 1.0;

  //   // Convert seconds to milliseconds for the timer
  //   int intervalMs = (rateInSeconds * 1000).toInt();

  //   _timer?.cancel();

  //   // 2. 🔥 START TIMER WITH DYNAMIC INTERVAL
  //   _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
  //     if (isPaused.value) return;

  //     double sMin = double.tryParse(activeSensor['min'].toString()) ?? 0.0;
  //     double sMax = double.tryParse(activeSensor['max'].toString()) ?? 100.0;

  //     // Generate mock data (Replace this with your real Modbus/OBD2 call)
  //     double newValue = sMin + Random().nextDouble() * (sMax - sMin);

  //     liveDataPoints.add(newValue);

  //     // Update live peak statistics
  //     if (newValue < liveMin.value) liveMin.value = newValue;
  //     if (newValue > liveMax.value) liveMax.value = newValue;

  //     // 3. AUTO-SCROLL LOGIC
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (chartScrollController.hasClients) {
  //         chartScrollController.animateTo(
  //           chartScrollController.position.maxScrollExtent,
  //           duration: const Duration(milliseconds: 200),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     });
  //   });
  // }
  // Inside SensorAnalysisController
  void sendGeneratorDataRequest(int registerAddress) {
    // Expected: 1 argument
    final plcCtrl = Get.find<PLCController>();

    if (!plcCtrl.isConnected.value) {
      isStreaming.value = false;
      isAnalyzing.value = false;
      Get.dialog(
        CustomPopup(
          title: "PLC Connection Lost",
          message:
              "Hardware communication was interrupted. Please check your Modbus TCP settings and cable.",
          isError: true, // This will make the button red and add an icon
        ),
      );
    }
    // Your bit shifting logic
    int hiAddr = (registerAddress >> 8) & 0xFF;
    int loAddr = registerAddress & 0xFF;

    List<int> packet = [
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x06,
      0x01,
      0x03,
      hiAddr,
      loAddr,
      0x00,
      0x01
    ];

    plcCtrl.sendPacket(packet);
  }

// 1. This starts the analysis
  void startAnalysis(Map<String, dynamic> sensor) {
    activeSensor.value = sensor;
    isAnalyzing.value = true;
    isStreaming.value = true;
    isPaused.value = false;
    liveDataPoints.clear();
    liveMin.value = double.infinity;
    liveMax.value = -double.infinity;

    // Start the polling loop
    _runAnalysisLoop();
  }

// 2. The recursive loop that keeps the socket busy
  Future<void> _runAnalysisLoop() async {
    while (isStreaming.value) {
      if (!isPaused.value) {
        // Get register from sensor map (handles 0x10 or "16")
        String regStr = activeSensor['register'].toString();
        int regAddress =
            int.tryParse(regStr.replaceFirst("0x", ""), radix: 16) ??
                int.tryParse(regStr) ??
                0;

        // Send the request via your existing socket logic
        sendGeneratorDataRequest(regAddress);
      }

      // Wait based on the sampling rate before next request
      double rate = activeSensor['samplingRate'] ?? 1.0;
      await Future.delayed(Duration(milliseconds: (rate * 1000).toInt()));
    }
  }

// 3. THIS IS CALLED BY PLC_CONTROLLER whenever a response arrives
  void addRealHardwarePoint(int rawValue) {
    if (isPaused.value || !isAnalyzing.value) return;

    // Pull formula factors from the active sensor template
    double m =
        double.tryParse(activeSensor['multiplier']?.toString() ?? "1.0") ?? 1.0;
    double c =
        double.tryParse(activeSensor['offset']?.toString() ?? "0.0") ?? 0.0;

    // Apply y = mx + c
    double processedValue = (rawValue * m) + c;

    // Add to chart
    liveDataPoints.add(processedValue);

    // Update Stats
    if (processedValue < liveMin.value) liveMin.value = processedValue;
    if (processedValue > liveMax.value) liveMax.value = processedValue;

    // Auto-scroll logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chartScrollController.hasClients) {
        chartScrollController
            .jumpTo(chartScrollController.position.maxScrollExtent);
      }
    });
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
    print("Is Paused: ${isPaused.value}"); // Debug to console
  }

  void stopAnalysis() {
    _timer?.cancel(); // Cancel timer on stop
    isStreaming.value = false;
    isPaused.value = false;
    liveDataPoints.clear();
    isAnalyzing.value = false;
  }

  final List<Map<String, dynamic>> sensorRecipes = [
    {
      'name': 'Engine RPM',
      'type': 'Digital',
      'register': '0x10',
      'min': 0,
      'max': 8000,
      'unit': 'RPM',
      'multiplier': 1.0,
      'offset': 0
    },
    {
      'name': 'Coolant Temp',
      'type': 'Analog',
      'register': '0x15',
      'min': -40,
      'max': 150,
      'unit': '°C',
      'multiplier': 1.0,
      'offset': 0
    },
    {
      'name': 'Battery Voltage',
      'type': 'Analog',
      'register': '0x20',
      'min': 0,
      'max': 18,
      'unit': 'V',
      'multiplier': 0.1,
      'offset': 0
    },
  ];

  void addSensorFromRecipe(Map<String, dynamic> recipe) {
    // Add a copy to the inventory table
    addedSensors.add(Map<String, dynamic>.from(recipe));
    Get.back(); // Close the popup
    Get.dialog(
      CustomPopup(
        title: "Success",
        message: "${recipe['name']} added to inventory",
        // This will make the button red and add an icon
      ),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
