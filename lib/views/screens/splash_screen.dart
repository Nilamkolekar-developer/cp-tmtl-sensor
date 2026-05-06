import 'package:cp_tmtl_sensor_zig/logic/controller/splashController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003377),
      body: Center(
        child: Image.asset(
         'assets/new/tmtl-logo(1).png', // your image path
          width: 200, // adjust size if needed
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}