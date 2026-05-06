import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/dasboardController.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/settingsController.dart';
import 'package:get/get.dart';

class DashboardBindings extends Bindings{
  @override
  void dependencies() {
   Get.put(DashboardController());
   Get.find<PLCController>();
  }
  
}