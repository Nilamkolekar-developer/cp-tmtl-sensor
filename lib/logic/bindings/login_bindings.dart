import 'package:CP_TMTL_Sensor_Zig/logic/controller/auth/loginController.dart';
import 'package:get/get.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
   Get.put(LoginController());
  }
  
}