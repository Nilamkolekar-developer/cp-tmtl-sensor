import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ESNController extends GetxController {
  final esnTextFieldController = TextEditingController();
  
  // This variable controls the button state
  var isValidated = false.obs;

  void validateESN() {
    // Add your validation logic here
    if (esnTextFieldController.text.isNotEmpty) {
      isValidated.value = true; // This will enable the Start Testing button
      Get.snackbar("Success", "ESN Validated Successfully");
    } else {
      isValidated.value = false;
      Get.snackbar("Error", "Please enter a valid ESN");
    }
  }
}