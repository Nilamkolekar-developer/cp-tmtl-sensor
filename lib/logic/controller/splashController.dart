
// import 'package:cp_tmtl_sensor_zigApp/utils/app_constants.dart';
import 'package:cp_tmtl_sensor_zig/routes/routes_string.dart';
import 'package:cp_tmtl_sensor_zig/utils/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(Duration(seconds: Constants.splashDelay), () {
      getScreen();
    });
    super.onInit();
  }

  Future<void> getScreen() async { 
       Get.offAndToNamed(Routes.loginScreen);
    }
     
  }