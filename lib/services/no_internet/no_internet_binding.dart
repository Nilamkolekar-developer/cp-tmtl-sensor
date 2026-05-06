import 'package:cp_tmtl_sensor_zig/services/no_internet/no_internet_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConnectionManagerController());
  }
}
