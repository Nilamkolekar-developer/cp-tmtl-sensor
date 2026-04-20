
// import 'package:CP_TMTL_Sensor_ZigApp/utils/app_constants.dart';
import 'package:CP_TMTL_Sensor_Zig/routes/routes_string.dart';
import 'package:CP_TMTL_Sensor_Zig/utils/app_constants.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(Duration(seconds: Constants.splashDelay), () {
      getScreen();
    });
    super.onInit();
  }

  Future<void> getScreen() async { 
       Get.offAndToNamed(Routes.loginScreen);
    }
     
  }