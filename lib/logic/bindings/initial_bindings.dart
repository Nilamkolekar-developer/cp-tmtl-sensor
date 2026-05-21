import 'package:get/get.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/dasboardController.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/settingsController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(), permanent: true);
    Get.put(PLCController(), permanent: true); // Your PLC controller
  }
}