import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardController extends GetxController {
  RxString appName = ''.obs;
  RxString version = ''.obs;
  RxString buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    appName.value = info.appName;
    version.value = info.version;
    buildNumber.value = info.buildNumber;
  }
}
