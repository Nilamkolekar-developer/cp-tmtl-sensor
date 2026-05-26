import 'package:flutter/material.dart';
import 'package:cp_tmtl_sensor_zig/api/app_envirments.dart';
import 'package:cp_tmtl_sensor_zig/app.dart';
import 'package:cp_tmtl_sensor_zig/services/log_file.dart'; // ✅ FIXED PATH

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LogFile.init();

  App.instance.initAndRunApp(
    devMode: true,
    appLog: true,
    apiLog: false,
    setDefault: true,
    samplePayment: true,
    baseURLType: AtomURLType.PROD,
  );
}