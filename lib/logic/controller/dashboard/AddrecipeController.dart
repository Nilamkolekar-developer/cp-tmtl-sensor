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
  // Main reactive list
  var recipeList = <Recipe>[
    Recipe(
      sr: "1",
      model: "AABBSSCC",
      type: "WDWW",
      sensors: [
        // ✅ Correctly instantiating SensorConfig
        SensorConfig(
            sensorName: "Oil Pressure",
            sensorType: "Analog",
            registerNumber: 1, // ✅ Must be an int
            min: 0.0,
            max: 10.0,
            multiplier: 1.0,
            offset: 10.0,
            unit: "ohm",
            testResult: "ok"),
      ],
    ),
    Recipe(
      sr: "2",
      model: "ASSSDFD",
      type: "DWWD",
      sensors: [
        SensorConfig(
            sensorName: "Coolant Temp",
            sensorType: "Analog",
            registerNumber: 101, // ✅ Must be an int
            min: 0.0,
            max: 120.0,
            multiplier: 1.0,
            offset: 0.0,
            unit: "ohm",
            testResult: "Not ok"),
      ],
    ),
  ].obs;

  RxBool isEditMode = false.obs;
  RxBool isAddingSensor = false.obs;
  RxList<SensorConfig> addedSensors = <SensorConfig>[].obs;

  // Observable TextControllers
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
  RxBool isEdit = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Recipe) {
      final recipe = Get.arguments as Recipe;
      modelController.value.text = recipe.model ?? "";
      typeController.value.text = recipe.type ?? "";

      // FIX: Explicitly map to <SensorConfig>
      if (recipe.sensors != null) {
        addedSensors.assignAll(recipe.sensors!
            .map<SensorConfig>((s) => SensorConfig(
                sensorName: s.sensorName ?? "",
                sensorType: s.sensorType ?? "",
                registerNumber: s.registerNumber,
                min: s.min,
                max: s.max,
                multiplier: s.multiplier,
                offset: s.offset,
                unit: s.unit,
                testResult: s.testResult))
            .toList());
      }
      isEditMode.value = true;
    }
  }

  void saveSensorToList() {
    if (sensorName.value.text.isEmpty) return;
    double m = double.tryParse(multiplier.value.text) ?? 1.0;
    double c = double.tryParse(offset.value.text) ?? 0.0;
    double minVal = double.tryParse(min.value.text) ?? 0.0;
    double maxVal = double.tryParse(max.value.text) ?? 0.0;
    double x = double.tryParse(registerNumber.value.text) ?? 0.0;
    double y = (m * x) + c;
    String result = (y >= minVal && y <= maxVal) ? "ok" : "Not ok";
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
      testResult: result, // Saving the calculated result
    ));
    hasTested.value = false;
    //_clearSensorFields();
  }

  void _clearSensorFields() {
    hasTested.value = false;
    sensorName.value.clear();
    sensorType.value.clear();
    registerNumber.value.clear();
    min.value.clear();
    max.value.clear();
    multiplier.value.text = "0.0";
    offset.value.text = "1.0";
    unit.value.clear();
    testResult.value.clear();
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

    addedSensors.remove(sensor);
  }

  // void addRecipe() {
  //   if (modelController.value.text.isNotEmpty) {
  //     var testController = Get.find<TestRecipeController>();

  //     String currentSr = isEditMode.value
  //         ? (Get.arguments as Recipe).sr ?? ""
  //         : (testController.recipeList.length + 1).toString();

  //     Recipe finalRecipe = Recipe(
  //       sr: currentSr,
  //       model: modelController.value.text.trim(),
  //       type: typeController.value.text.trim(),
  //       sensors: addedSensors.toList(),
  //     );

  //     if (isEditMode.value) {
  //       int index =
  //           testController.recipeList.indexWhere((r) => r.sr == currentSr);
  //       if (index != -1) testController.recipeList[index] = finalRecipe;
  //     } else {
  //       testController.recipeList.add(finalRecipe);
  //     }

  //     testController.recipeList.refresh();
  //     _resetForm();
  //     Get.back();
  //   }
  // }
  void addRecipe() {
  print("DEBUG: addRecipe called. Input: ${modelController.value.text}");

  if (modelController.value.text.trim().isEmpty) {
    print("DEBUG: Validation failed - Model name is empty");
    Get.snackbar("Error", "Model name is required");
    return;
  }

  try {
    var testController = Get.find<TestRecipeController>();
    print("DEBUG: Controller found. Current list length: ${testController.recipeList.length}");

    String currentSr = isEditMode.value
        ? (Get.arguments as Recipe).sr ?? ""
        : (testController.recipeList.length + 1).toString();

    Recipe finalRecipe = Recipe(
      sr: currentSr,
      model: modelController.value.text.trim(),
      type: typeController.value.text.trim(),
      sensors: List.from(addedSensors), // Create a fresh list instance
    );

    if (isEditMode.value) {
      int index = testController.recipeList.indexWhere((r) => r.sr == currentSr);
      if (index != -1) {
        testController.recipeList[index] = finalRecipe;
        print("DEBUG: Edited recipe at index $index");
      }
    } else {
      testController.recipeList.add(finalRecipe);
      print("DEBUG: Added new recipe. New length: ${testController.recipeList.length}");
    }

    testController.recipeList.refresh();
    _resetForm();
    Get.back();
    
  } catch (e) {
    print("DEBUG: Error adding recipe: $e");
  }
}

  RxBool hasTested = false.obs;

  void sendGeneratorDataRequest(int registerAddress) {
    // 🔥 FIND THE EXISTING PLC CONTROLLER
    final plcCtrl = Get.find<PLCController>();

    // Use the socket and connection status from the PLCController
    if (plcCtrl.isConnected.value == false) {
      print("ABORTED: PLCController is not connected.");
      Get.dialog(
        CustomPopup(
          title: "PLC Connection Lost",
          message:
              "Hardware communication was interrupted. Please check your Modbus TCP settings and cable.",
          isError: true, // This will make the button red and add an icon
        ),
      );
    }

    // 1. Calculate bytes
    int hiAddr = (registerAddress >> 8) & 0xFF;
    int loAddr = registerAddress & 0xFF;

    print("--- Modbus Request Preparation ---");
    print("Input Register (Decimal): $registerAddress");

    List<int> packet = [
      0x00, 0x01, // Transaction ID
      0x00, 0x00, // Protocol ID
      0x00, 0x06, // Length
      0x01, // Unit ID
      0x03, // Function Code
      hiAddr, loAddr,
      0x00, 0x01
    ];

    // 🔥 USE THE PLC_CONTROLLER'S SOCKET TO SEND
    plcCtrl.sendPacket(packet);
    hasTested.value = true;
    _printHex("SENT via PLCController", packet);
  }
// Inside PLCController class

  void _printHex(String label, List<int> data) {
    String hex = data
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(' ');
    print("$label: $hex");
  }

  void _resetForm() {
    modelController.value.clear();
    typeController.value.clear();
    addedSensors.clear();
    isEditMode.value = false;
  }

// Inside AddRecipeController

// 1. Existing Read Logic (Function Code 03)
// void sendGeneratorDataRequest1(int registerAddress) {
//   final plcCtrl = Get.find<PLCController>();
//   if (!plcCtrl.isConnected.value) {
//     _showErrorPopup();
//     return;
//   }

//   int hiAddr = (registerAddress >> 8) & 0xFF;
//   int loAddr = registerAddress & 0xFF;

//   List<int> packet = [
//     0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x01, 
//     0x03, // Function Code 03 (Read)
//     hiAddr, loAddr, 0x00, 0x01
//   ];

//   plcCtrl.sendPacket(packet);
//   hasTested.value = true;
// }
void sendGeneratorDataRequest1(int registerAddress) {
  final plcCtrl = Get.find<PLCController>();
  if (!plcCtrl.isConnected.value) {
    _showErrorPopup();
    return;
  }

  int hiAddr = (registerAddress >> 8) & 0xFF;
  int loAddr = registerAddress & 0xFF;

  List<int> packet = [
    0x00, 0x01, // Transaction ID
    0x00, 0x00, // Protocol ID
    0x00, 0x06, // Length
    0x01,       // Unit ID (Slave ID)
    0x03,       // Function Code 03 (Read Holding Registers)
    hiAddr, loAddr, // Starting Address
    0x00, 0x01  // Quantity of Registers (Read 1)
  ];

  // --- ADD THIS BLOCK TO SEE THE HIT ---
  String hexCommand = packet
      .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
  
  print("DEBUG: [READ HIT] -> Register: $registerAddress");
  print("RAW HEX: [ $hexCommand ]");
  // -------------------------------------

  plcCtrl.sendPacket(packet);
  hasTested.value = true;
}

// 2. New Write Logic (Function Code 06)
// void writeGeneratorDataRequest(int registerAddress, int valueToWrite) {
//   final plcCtrl = Get.find<PLCController>();
//   if (!plcCtrl.isConnected.value) {
//     _showErrorPopup();
//     return;
//   }

//   int hiAddr = (registerAddress >> 8) & 0xFF;
//   int loAddr = registerAddress & 0xFF;
//   int hiVal = (valueToWrite >> 8) & 0xFF;
//   int loVal = valueToWrite & 0xFF;

//   List<int> packet = [
//     0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x01, 
//     0x06, // Function Code 06 (Write Single Register)
//     hiAddr, loAddr, hiVal, loVal
//   ];

//   plcCtrl.sendPacket(packet);
// }
void writeGeneratorDataRequest(int registerAddress, int valueToWrite) {
  final plcCtrl = Get.find<PLCController>();
  if (!plcCtrl.isConnected.value) {
    _showErrorPopup();
    return;
  }

  int hiAddr = (registerAddress >> 8) & 0xFF;
  int loAddr = registerAddress & 0xFF;
  int hiVal = (valueToWrite >> 8) & 0xFF;
  int loVal = valueToWrite & 0xFF;

  List<int> packet = [
    0x00, 0x01, // Transaction ID
    0x00, 0x00, // Protocol ID
    0x00, 0x06, // Length
    0x01,       // Unit ID
    0x06,       // Function Code 06 (Write Single Register)
    hiAddr, loAddr,
    hiVal, loVal
  ];

  // --- ADD THIS TO SEE THE COMMAND ---
  String hexCommand = packet
      .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');
  
  print("DEBUG: Sending Write Command to PLC");
  print("HEX DATA: [ $hexCommand ]");
  print("TARGET REGISTER: $registerAddress | VALUE: $valueToWrite");
  // -----------------------------------

  plcCtrl.sendPacket(packet);
}

void _showErrorPopup() {
  Get.dialog(CustomPopup(
    title: "PLC Offline",
    message: "Hardware communication lost. Check connection.",
    isError: true,
  ));
}

  Future<void> importRecipes() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return;

      File file = File(result.files.single.path!);
      String jsonInput = await file.readAsString();
      dynamic decodedData = jsonDecode(jsonInput);

      Map<String, dynamic> recipeMap =
          (decodedData is List) ? decodedData.first : decodedData;
      Recipe importedRecipe = Recipe.fromJson(recipeMap);

      modelController.value.text = importedRecipe.model ?? '';
      typeController.value.text = importedRecipe.type ?? '';

      // FIX: Explicitly map to <SensorConfig>
      if (importedRecipe.sensors != null) {
        List<SensorConfig> mappedSensors = importedRecipe.sensors!
            .map<SensorConfig>((s) => SensorConfig(
                sensorName: s.sensorName ?? "",
                sensorType: s.sensorType ?? "",
                registerNumber: s.registerNumber,
                min: s.min,
                max: s.max,
                multiplier: s.multiplier,
                offset: s.offset,
                unit: s.unit,
                testResult: s.testResult))
            .toList();
        addedSensors.assignAll(mappedSensors);
      }
      Get.dialog(
        CustomPopup(
          title: "Success",
          message: "Imported ${importedRecipe.model}",
          // This will make the button red and add an icon
        ),
      );
    } catch (e) {
      Get.dialog(
        CustomPopup(
          title: "Import Failed",
          message: "Error:$e",
          isError: true, // This will make the button red and add an icon
        ),
      );
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    modelController.value.dispose();
    typeController.value.dispose();
    sensorName.value.dispose();
    sensorType.value.dispose();
    registerNumber.value.dispose();
    min.value.dispose();
    max.value.dispose();
    multiplier.value.dispose();
    offset.value.dispose();
    super.onClose();
  }
}
