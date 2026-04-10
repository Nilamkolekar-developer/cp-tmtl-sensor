import 'dart:convert';
import 'dart:io';

import 'package:autopeepal/models/receipe_model.dart';
import 'package:autopeepal/models/sensor_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TestRecipeController extends GetxController {
  var recipeList = <Recipe>[
    Recipe(
        sr: "1",
        model: "AABBSSCC",
        type: "WDWW",
        recipeId: "TTP_ID",
        sensors: []),
    Recipe(
        sr: "2",
        model: "ASSSDFD",
        type: "DWWD",
        recipeId: "TTP_02",
        sensors: []),
  ].obs;

  // 2. Define Text Controllers for the Addition Screen
  final modelController = TextEditingController().obs;
  final typeController = TextEditingController().obs;
  final sensorName = TextEditingController().obs;
  final sensorType = TextEditingController().obs;
  final registerNumber = TextEditingController().obs;
  final multiplier = TextEditingController().obs;
  final offset = TextEditingController().obs;
  final min = TextEditingController().obs;
  final max = TextEditingController().obs;
// In your TestRecipeController
  RxList addedSensors = <SensorModel>[].obs;
  RxBool isAddingSensor = false.obs;
  // 2. Logic to save current field values to the list
  void saveSensorToList() {
    if (sensorName.value.text.isEmpty) return;

    addedSensors.add(SensorModel(
      name: sensorName.value.text,
      type: sensorType.value.text,
      register: registerNumber.value.text,
      min: min.value.text,
      max: max.value.text,
      multiplier: multiplier.value.text,
      offset: offset.value.text,
    ));

    // 3. Clear fields for next entry
    sensorName.value.clear();
    sensorType.value.clear();
    registerNumber.value.clear();
    min.value.clear();
    max.value.clear();
    multiplier.value.clear();
    offset.value.clear();
  }

  // 3. Method to add data
  void addRecipe() {
    if (modelController.value.text.isNotEmpty) {
      recipeList.add(
        Recipe(
          sr: (recipeList.length + 1).toString(),
          model: modelController.value.text,
          type: typeController.value.text,
          recipeId: "REC_${recipeList.length + 1}",
          sensors: [],
        ),
      );
      modelController.value.clear();
      typeController.value.clear();
      Get.back();

      Get.snackbar("Success", "New recipe added to the list");
    }
  }

  // Temporary list for sensors added on the current "Add" screen
  var currentSensors = <SensorConfig>[].obs;

  // 2. Final save: Engine + all added sensors
  void saveFullRecipe() {
    if (modelController.value.text.isNotEmpty && currentSensors.isNotEmpty) {
      recipeList.add(Recipe(
        sr: (recipeList.length + 1).toString(),
        model: modelController.value.text,
        type: typeController.value.text,
        recipeId: "REC_${recipeList.length + 1}",
        sensors: List.from(currentSensors),
      ));
      currentSensors.clear();
      modelController.value.clear();
      typeController.value.clear();
      Get.back();
    }
  }

  // Future<void> exportToJSON() async {
  //   try {
  //     List<Map<String, dynamic>> allData =
  //         recipeList.map((e) => e.toJson()).toList();
  //     String jsonString = jsonEncode(allData);
  //     String? outputFile = await FilePicker.platform.saveFile(
  //       dialogTitle: 'Please select where to save your recipe file:',
  //       fileName: 'recipe_data.json',
  //       type: FileType.custom,
  //       allowedExtensions: ['json'],
  //     );

  //     if (outputFile != null) {
  //       final file = File(outputFile);
  //       await file.writeAsString(jsonString);

  //       Get.snackbar("Export Success", "Recipes saved to $outputFile",
  //           snackPosition: SnackPosition.BOTTOM);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Export Failed", "Error: $e");
  //   }
  // }

  Future<void> exportSingleRecipe(Recipe recipe) async {
    try {
      // 1. Convert ONLY the selected recipe to a List containing one Map
      List<Map<String, dynamic>> singleData = [recipe.toJson()];
      String jsonString = jsonEncode(singleData);

      // 2. Open Save File Dialog with a default name based on the model
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Recipe: ${recipe.model}',
        fileName: 'recipe_${recipe.model.replaceAll(' ', '_')}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonString);
        Get.snackbar("Export Success", "Recipe ${recipe.model} exported.");
      }
    } catch (e) {
      Get.snackbar("Export Failed", "Error: $e");
    }
  }

  // // COMPLETE IMPORT LOGIC
  // Future<void> importRecipes() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['json'],
  //     );

  //     if (result != null) {
  //       File file = File(result.files.single.path!);
  //       String jsonInput = await file.readAsString();
  //       List<dynamic> jsonData = jsonDecode(jsonInput);
  //       List<Recipe> importedList =
  //           jsonData.map((e) => Recipe.fromJson(e)).toList();
  //       recipeList.assignAll(importedList);

  //       Get.snackbar("Import Success", "${importedList.length} Recipes loaded");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Import Failed", "Invalid file format or corrupted data.");
  //   }
  // }
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

    // Handle both single Recipe object or a List containing one Recipe
    Map<String, dynamic> recipeMap;
    if (decodedData is List) {
      recipeMap = decodedData.first;
    } else {
      recipeMap = decodedData;
    }

    Recipe importedRecipe = Recipe.fromJson(recipeMap);

    // 1. Populate Engine Details
    modelController.value.text = importedRecipe.model;
    typeController.value.text = importedRecipe.type;
registerNumber.value.text = importedRecipe.recipeId;
    // 2. Map SensorConfig objects to your SensorModel (used for the table)
    List<SensorModel> mappedSensors = importedRecipe.sensors.map((s) {
      return SensorModel(
        name: s.sensorName ?? "",
        type: s.sensorType ?? "",
        register: s.registerNumber?.toString() ?? "",
        min: s.min?.toString() ?? "",
        max: s.max?.toString() ?? "",
        multiplier: s.multiplier?.toString() ?? "",
        offset: s.offset?.toString() ?? "",
      );
    }).toList();

    // 3. Load into the table
    addedSensors.assignAll(mappedSensors);

    Get.snackbar("Import Success", 
      "Loaded ${importedRecipe.model} with ${mappedSensors.length} sensors.");
      
  } catch (e) {
    print("Import Error: $e");
    Get.snackbar("Import Failed", "Invalid JSON format for Recipe.");
  }
}

  @override
  void onClose() {
    modelController.value.dispose();
    typeController.value.dispose();
    super.onClose();
  }
}
