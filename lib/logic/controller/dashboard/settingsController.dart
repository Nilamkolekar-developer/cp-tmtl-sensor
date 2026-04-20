import 'dart:io';
import 'dart:async';
import 'package:autopeepal/common_widgets/popup.dart';
import 'package:autopeepal/logic/controller/dashboard/AddrecipeController.dart';
import 'package:autopeepal/logic/controller/dashboard/sensorAnalysisController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PLCController extends GetxController {
  var isConnected = false.obs;
  var isConnecting = false.obs;
  var debugStatus = "Idle".obs;
  var plcDataValue = 0.obs;

  final ipController = TextEditingController();
  final portController = TextEditingController();
  Socket? socket;
  Future<void> saveSettings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('plc_ip', ipController.text);
      await prefs.setString('plc_port', portController.text);
      print("Settings Saved: ${ipController.text}:${portController.text}");
    } catch (e) {
      Get.dialog(
        CustomPopup(
          title: "Error saving settings:",
          message: "$e",
          isError: true, // This will make the button red and add an icon
        ),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings(); // Load IP/Port automatically when screen opens
  }

  // --- LOAD FROM SHARED PREFERENCES ---
  Future<void> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ipController.text = prefs.getString('plc_ip') ?? '';
    portController.text = prefs.getString('plc_port') ?? '';
  }

  // --- 2. CONNECTION LOGIC ---
  Future<void> connectToPLC(String ip, String port) async {
    if (isConnecting.value) return;
    await _cleanupBeforeConnect();

    int? portNum = int.tryParse(port);
    if (portNum == null) return;

    try {
      isConnecting.value = true;
      debugStatus.value = "Connecting...";
      socket = await Socket.connect(ip, portNum,
          timeout: const Duration(seconds: 4));
      socket!.setOption(SocketOption.tcpNoDelay, true);

      isConnected.value = true;
      debugStatus.value = "Connected";

      socket!.listen(
        (data) => _handleResponse(data),
        onError: (err) => disconnect(),
        onDone: () => disconnect(),
        cancelOnError: true,
      );
    } catch (e) {
      debugStatus.value = "Connect Error";
      disconnect();
    } finally {
      isConnecting.value = false;
    }
  }

  void sendGeneratorDataRequest() {
    if (socket == null || !isConnected.value) return;

    //MODBUS TCP PACKET STRUCTURE (No CRC!)
    List<int> packet = [
      0x00, 0x01, // Transaction ID (0001)
      0x00, 0x00, // Protocol ID (Always 0 for Modbus)
      0x00, 0x06, // Length (6 bytes follow: UnitID + Func + Addr + Count)
      0x01, // Unit ID (Slave ID)
      0x03, // Function Code (Read Holding Register)
      0x00, 0x01, // Starting Address (Register 1)
      0x00, 0x01 // Quantity (Read 1 register)
    ];

    socket!.add(packet);
    _printHex("SENT", packet);
  }

  void _handleResponse(List<int> data) {
    _printHex("RESPONSE", data);
    // Header (7) + Func (1) + ByteCount (1) + Data (2) = 11 bytes
    if (data.length >= 11 && data[7] == 0x03) {
      int rawValue = (data[9] << 8) | data[10];
      plcDataValue.value = rawValue;

      // --- 1. ROUTE TO RECIPE ADDITION SCREEN ---
      if (Get.isRegistered<AddRecipeController>()) {
        final recipeCtrl = Get.find<AddRecipeController>();

        double m = double.tryParse(recipeCtrl.multiplier.value.text) ?? 1.0;
        double c = double.tryParse(recipeCtrl.offset.value.text) ?? 0.0;
        double minVal = double.tryParse(recipeCtrl.min.value.text) ?? 0.0;
        double maxVal = double.tryParse(recipeCtrl.max.value.text) ?? 0.0;

        double calculatedValue = (rawValue * m) + c;

        if (calculatedValue >= minVal && calculatedValue <= maxVal) {
          recipeCtrl.testResult.value.text =
              "ok (${calculatedValue.toStringAsFixed(2)})";
        } else {
          recipeCtrl.testResult.value.text =
              "Not ok (${calculatedValue.toStringAsFixed(2)})";
        }
      }

      // --- 2. ROUTE TO SENSOR ANALYSIS SCREEN (LIVE GRAPH) ---
      if (Get.isRegistered<SensorAnalysisController>()) {
        final analysisCtrl = Get.find<SensorAnalysisController>();

        // We pass the raw int value to the analysis controller
        // It will handle its own y = mx + c based on the "Active Sensor"
        analysisCtrl.addRealHardwarePoint(rawValue);
      }
    }
  }

  void sendPacket(List<int> packet) {
    if (socket != null && isConnected.value) {
      socket!.add(packet);
      _printHex("SENT", packet);
    } else {
      print("Cannot send: Socket is null or disconnected");
    }
  }

  void _printHex(String label, List<int> data) {
    String hex = data
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
    print("$label: $hex");
  }

  void disconnect() {
    socket?.destroy();
    socket = null;
    isConnected.value = false;
    debugStatus.value = "Disconnected";
  }

  Future<void> _cleanupBeforeConnect() async {
    isConnected.value = false;
    if (socket != null) {
      socket!.destroy();
      socket = null;
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
