import 'package:CP_TMTL_Sensor_Zig/api/app_envirments.dart';
import 'package:CP_TMTL_Sensor_Zig/app.dart';

void main() async {
  App.instance.initAndRunApp(
    devMode: false,
    appLog: false,
    apiLog: false,
    setDefault: false,
    samplePayment: false,
    baseURLType: AtomURLType.DEV,
  );
}