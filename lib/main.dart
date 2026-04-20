import 'package:CP_TMTL_Sensor_Zig/api/app_envirments.dart';
import 'package:CP_TMTL_Sensor_Zig/app.dart';

void main() async {
  App.instance.initAndRunApp(
    devMode: true,
    appLog: true,
    apiLog: false,
    setDefault: true,
    samplePayment: true,
    baseURLType: AtomURLType.PROD, 
  );
}
