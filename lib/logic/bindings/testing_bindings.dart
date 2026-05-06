import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/testRecipeController.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/testingController.dart';
import 'package:get/get.dart';


class TestingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ESNController(), permanent: true);
    Get.put(TestRecipeController(), permanent: true); // Your PLC controller
  }
}