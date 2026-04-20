
import 'package:CP_TMTL_Sensor_Zig/logic/controller/splashController.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
