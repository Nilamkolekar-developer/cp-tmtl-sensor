import 'package:get/get.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/dasboardController.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/settingsController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(), permanent: true);
    Get.put(PLCController(), permanent: true); // Your PLC controller
  }
}