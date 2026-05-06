import 'package:cp_tmtl_sensor_zig/logic/controller/auth/loginController.dart';
import 'package:cp_tmtl_sensor_zig/logic/controller/dashboard/settingsController.dart';
import 'package:get/get.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
   Get.put(LoginController());
   Get.find<PLCController>();
  }
  
}