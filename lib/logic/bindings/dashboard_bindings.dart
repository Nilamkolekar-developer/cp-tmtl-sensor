import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/dasboardController.dart';
import 'package:CP_TMTL_Sensor_Zig/logic/controller/dashboard/settingsController.dart';
import 'package:get/get.dart';

class DashboardBindings extends Bindings{
  @override
  void dependencies() {
   Get.put(DashboardController());
   Get.find<PLCController>();
  }
  
}