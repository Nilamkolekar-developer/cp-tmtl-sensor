import 'package:autopeepal/models/receipe_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class recipeAdditionReadOnlyController extends GetxController {
  final modelController = TextEditingController().obs;
  final typeController = TextEditingController().obs;
  final sensorName = TextEditingController().obs;
  final sensorType = TextEditingController().obs;
  final registerNumber = TextEditingController().obs;
  final multiplier = TextEditingController().obs;
  final offset = TextEditingController().obs;
  final min = TextEditingController().obs;
  final max = TextEditingController().obs;
  @override
  void onInit() {
    super.onInit();
    // 1. Get the argument passed during navigation
    if (Get.arguments != null && Get.arguments is Recipe) {
      _fillData(Get.arguments as Recipe);
    }
  }

  void _fillData(Recipe recipe) {
    // 2. Inject the argument data into your RxTextEditingControllers
    modelController.value.text = recipe.model;
    typeController.value.text = recipe.type;
    sensorName.value.text = (recipe.sensors.isNotEmpty ? recipe.sensors[0].sensorName : "")!;
    //multiplier.value.text = recipe.multiplier[0] ?? "";
    registerNumber.value.text = recipe.recipeId;
    // offset.value.text = recipe.offset ?? "";
    // min.value.text = recipe.min ?? "";
    // max.value.text = recipe.max ?? "";
  }
}
