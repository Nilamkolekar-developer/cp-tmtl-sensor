
import 'dart:convert';
import 'dart:io';
import 'package:CP_TMTL_Sensor_Zig/common_widgets/popup.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/settingsController.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:CP_TMTL_Sensor_Zig/models/receipe_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRecipeController extends GetxController {
  // ── Mode ────────────────────────────────────────────────────────────────────
  var isWriteMode = false.obs;
  var isEditMode = false.obs;
  var isAddingSensor = false.obs;
  var hasTested = false.obs;
  var isEdit = false.obs;

  // ── Sensor table state ───────────────────────────────────────────────────────
  RxList<SensorConfig> addedSensors = <SensorConfig>[].obs;
  final RxSet<String> expandedSensors = <String>{}.obs;

  // ── Form controllers ─────────────────────────────────────────────────────────
  final modelController = TextEditingController().obs;
  final typeController = TextEditingController().obs;
  final sensorName = TextEditingController().obs;
  final sensorType = TextEditingController().obs;
  final registerNumber = TextEditingController().obs;
  final min = TextEditingController().obs;
  final max = TextEditingController().obs;
  final offset = TextEditingController(text: "1.0").obs;
  final multiplier = TextEditingController(text: "0.0").obs;
  final unit = TextEditingController().obs;
  final testResult = TextEditingController().obs;

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Recipe) {
      final recipe = Get.arguments as Recipe;
      modelController.value.text = recipe.model ?? "";
      typeController.value.text = recipe.type ?? "";
      addedSensors.assignAll(
        recipe.sensors.map<SensorConfig>((s) => SensorConfig(
              sensorName: s.sensorName ?? "",
              sensorType: s.sensorType ?? "",
              registerNumber: s.registerNumber,
              min: s.min,
              max: s.max,
              multiplier: s.multiplier,
              offset: s.offset,
              unit: s.unit,
              testResult: s.testResult,
              operations: List.from(s.operations), // preserve logs
            )),
      );
          isEditMode.value = true;
    }
  }

  // Opens the sensor form pre-filled for a specific sensor
// but does NOT remove it from the list (unlike editSensor)
void openOperationForm(SensorConfig sensor) {
  isAddingSensor.value = true;
  sensorName.value.text = sensor.sensorName ?? '';
  sensorType.value.text = sensor.sensorType ?? '';
  registerNumber.value.text = (sensor.registerNumber ?? 0).toString();
  min.value.text = (sensor.min ?? 0.0).toString();
  max.value.text = (sensor.max ?? 0.0).toString();
  multiplier.value.text = (sensor.multiplier ?? 0.0).toString();
  offset.value.text = (sensor.offset ?? 0.0).toString();
  unit.value.text = sensor.unit ?? '';
  testResult.value.text = sensor.testResult ?? '';
  // ✅ sensor stays in addedSensors — NOT removed
}

  @override
  void onClose() {
    modelController.value.dispose();
    typeController.value.dispose();
    sensorName.value.dispose();
    sensorType.value.dispose();
    registerNumber.value.dispose();
    min.value.dispose();
    max.value.dispose();
    multiplier.value.dispose();
    offset.value.dispose();
    unit.value.dispose();
    testResult.value.dispose();
    super.onClose();
  }

  // ── Expand / collapse ────────────────────────────────────────────────────────
  void toggleSensorExpanded(String name) {
    if (expandedSensors.contains(name)) {
      expandedSensors.remove(name);
    } else {
      expandedSensors.add(name);
    }
  }

  // ── Sensor CRUD ──────────────────────────────────────────────────────────────
  void saveSensorToList() {
    if (sensorName.value.text.isEmpty) return;

    final double m = double.tryParse(multiplier.value.text) ?? 1.0;
    final double c = double.tryParse(offset.value.text) ?? 0.0;
    final double minVal = double.tryParse(min.value.text) ?? 0.0;
    final double maxVal = double.tryParse(max.value.text) ?? 0.0;
    final double x = double.tryParse(registerNumber.value.text) ?? 0.0;
    final double y = (m * x) + c;
    final String result = (y >= minVal && y <= maxVal) ? "ok" : "Not ok";

    testResult.value.text = result;

    addedSensors.add(SensorConfig(
      sensorName: sensorName.value.text,
      sensorType: sensorType.value.text,
      registerNumber: int.tryParse(registerNumber.value.text) ?? 0,
      min: minVal,
      max: maxVal,
      multiplier: m,
      offset: c,
      unit: unit.value.text,
      testResult: result,
      operations: [], // fresh log for new sensor
    ));

    hasTested.value = false;
  }

  void editSensor(SensorConfig sensor) {
    isAddingSensor.value = true;
    sensorName.value.text = sensor.sensorName ?? '';
    sensorType.value.text = sensor.sensorType ?? '';
    registerNumber.value.text = (sensor.registerNumber ?? 0).toString();
    min.value.text = (sensor.min ?? 0.0).toString();
    max.value.text = (sensor.max ?? 0.0).toString();
    multiplier.value.text = (sensor.multiplier ?? 0.0).toString();
    offset.value.text = (sensor.offset ?? 0.0).toString();
    unit.value.text = sensor.unit ?? '';
    testResult.value.text = sensor.testResult ?? '';
    //addedSensors.remove(sensor);
  }

  // ── Operation log (stored directly on SensorConfig) ──────────────────────────
  void logOperation({
    required String sensorName,
    required String operation, // "READ" or "WRITE"
    required String value,
  }) {
    final sensor =
        addedSensors.firstWhereOrNull((s) => s.sensorName == sensorName);
    if (sensor == null) return;

    sensor.addLog(
      operation: operation,
      registerAddress: registerNumber.value.text,
      value: value,
    );
    addedSensors.refresh(); // triggers Obx rebuild in view
  }

  // ── Recipe save ──────────────────────────────────────────────────────────────
  void addRecipe() {
    if (modelController.value.text.trim().isEmpty) {
      Get.snackbar("Error", "Model name is required");
      return;
    }

    try {
      final testController = Get.find<TestRecipeController>();

      final String currentSr = isEditMode.value
          ? (Get.arguments as Recipe).sr ?? ""
          : (testController.recipeList.length + 1).toString();

      final Recipe finalRecipe = Recipe(
        sr: currentSr,
        model: modelController.value.text.trim(),
        type: typeController.value.text.trim(),
        sensors: List.from(addedSensors),
      );

      if (isEditMode.value) {
        final int index =
            testController.recipeList.indexWhere((r) => r.sr == currentSr);
        if (index != -1) testController.recipeList[index] = finalRecipe;
      } else {
        testController.recipeList.add(finalRecipe);
      }

      testController.recipeList.refresh();
      _resetForm();
      Get.back();
    } catch (e) {
      print("DEBUG: Error adding recipe: $e");
    }
  }

  void _resetForm() {
    modelController.value.clear();
    typeController.value.clear();
    addedSensors.clear();
    expandedSensors.clear();
    isEditMode.value = false;
  }

  // void _clearSensorFields() {
  //   hasTested.value = false;
  //   sensorName.value.clear();
  //   sensorType.value.clear();
  //   registerNumber.value.clear();
  //   min.value.clear();
  //   max.value.clear();
  //   multiplier.value.text = "0.0";
  //   offset.value.text = "1.0";
  //   unit.value.clear();
  //   testResult.value.clear();
  // }

  // ── PLC communication ────────────────────────────────────────────────────────
  void _printHex(String label, List<int> data) {
    final String hex = data
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
    print("$label: $hex");
  }

  void _showErrorPopup() {
    Get.dialog(CustomPopup(
      title: "PLC Offline",
      message: "Hardware communication lost. Check connection.",
      isError: true,
    ));
  }

  void sendGeneratorDataRequest(int registerAddress) {
    final plcCtrl = Get.find<PLCController>();
    if (!plcCtrl.isConnected.value) {
      Get.dialog(CustomPopup(
        title: "PLC Connection Lost",
        message:
            "Hardware communication was interrupted. Please check your Modbus TCP settings and cable.",
        isError: true,
      ));
      return;
    }

    final int hiAddr = (registerAddress >> 8) & 0xFF;
    final int loAddr = registerAddress & 0xFF;

    final List<int> packet = [
      0x00, 0x01, 0x00, 0x00, 0x00, 0x06,
      0x01, 0x03,
      hiAddr, loAddr,
      0x00, 0x01,
    ];

    plcCtrl.sendPacket(packet);
    hasTested.value = true;
    _printHex("SENT via PLCController", packet);
  }

   sendGeneratorDataRequest1(int registerAddress) {
    final plcCtrl = Get.find<PLCController>();

    final int hiAddr = (registerAddress >> 8) & 0xFF;
    final int loAddr = registerAddress & 0xFF;

    final List<int> packet = [
      0x00, 0x01, 0x00, 0x00, 0x00, 0x06,
      0x01, 0x03,
      hiAddr, loAddr,
      0x00, 0x01,
    ];

    final String hexCommand = packet
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');

    print("DEBUG: [READ HIT] -> Register: $registerAddress");
    print("RAW HEX: [ $hexCommand ]");

    plcCtrl.sendPacket(packet);
    hasTested.value = true;
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
      0x00, 0x01, 0x00, 0x00, 0x00, 0x06,
      0x01, 0x06,
      hiAddr, loAddr,
      hiVal, loVal,
    ];

    final String hexCommand = packet
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');

    print("DEBUG: Sending Write Command to PLC");
    print("HEX DATA: [ $hexCommand ]");
    print("TARGET REGISTER: $registerAddress | VALUE: $valueToWrite");

    plcCtrl.sendPacket(packet);
  }

  // ── Import JSON ──────────────────────────────────────────────────────────────
  Future<void> importRecipes() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null) return;

      final File file = File(result.files.single.path!);
      final String jsonInput = await file.readAsString();
      final dynamic decodedData = jsonDecode(jsonInput);

      final Map<String, dynamic> recipeMap =
          (decodedData is List) ? decodedData.first : decodedData;
      final Recipe importedRecipe = Recipe.fromJson(recipeMap);

      modelController.value.text = importedRecipe.model ?? '';
      typeController.value.text = importedRecipe.type ?? '';

      addedSensors.assignAll(
        importedRecipe.sensors.map<SensorConfig>((s) => SensorConfig(
              sensorName: s.sensorName ?? "",
              sensorType: s.sensorType ?? "",
              registerNumber: s.registerNumber,
              min: s.min,
              max: s.max,
              multiplier: s.multiplier,
              offset: s.offset,
              unit: s.unit,
              testResult: s.testResult,
              operations: List.from(s.operations),
            )),
      );
    
      Get.dialog(CustomPopup(
        title: "Success",
        message: "Imported ${importedRecipe.model}",
      ));
    } catch (e) {
      Get.dialog(CustomPopup(
        title: "Import Failed",
        message: "Error: $e",
        isError: true,
      ));
    }
  }
}