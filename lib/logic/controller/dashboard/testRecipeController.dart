import 'dart:convert';
import 'dart:io';
import 'package:CP_TMTL_Sensor_Zig/common_widgets/popup.dart';
import 'package:CP_TMTL_Sensor_Zig/models/receipe_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class TestRecipeController extends GetxController {
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
            min: 3.0,
            max: 10.0,
            multiplier: 1.0,
            offset: 0.0,
            unit: "ohm",
            testResult: "ok"),
        SensorConfig(
            sensorName: "Oil Pressure",
            sensorType: "Analog",
            registerNumber: 1, // ✅ Must be an int
            min: 3.0,
            max: 10.0,
            multiplier: 1.0,
            offset: 0.0,
            unit: "ohm",
            testResult: "ok"),
        SensorConfig(
            sensorName: "Oil Pressure",
            sensorType: "Analog",
            registerNumber: 1, // ✅ Must be an int
            min: 3.0,
            max: 10.0,
            multiplier: 1.0,
            offset: 0.0,
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
            registerNumber: 2, // ✅ Must be an int
            min: 0.0,
            max: 10.0,
            multiplier: 1.0,
            offset: 0.0,
            unit: "ohm",
            testResult: "Not ok"),
      ],
    ),
  ].obs;

  Future<void> exportSingleRecipe(Recipe recipe) async {
    try {
      List<Map<String, dynamic>> singleData = [recipe.toJson()];
      String jsonString = jsonEncode(singleData);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Recipe: ${recipe.model}',
        fileName: 'recipe_${recipe.model!.replaceAll(' ', '_')}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonString);
        Get.dialog(
          CustomPopup(
            title: "Export Success",
            message: "Recipe ${recipe.model} exported.",
            // This will make the button red and add an icon
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        CustomPopup(
          title: "Export Failed",
          message: "Error:$e",
          isError: true, // This will make the button red and add an icon
        ),
      );
    }
  }
}
