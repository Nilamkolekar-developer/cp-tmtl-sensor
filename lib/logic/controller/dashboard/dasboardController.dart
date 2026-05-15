import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardController extends GetxController {
  RxString appName = ''.obs;
  RxString version = ''.obs;
  RxString buildNumber = ''.obs;
  RxInt selectedModelIndex = 0.obs;

  final RxList<Map<String, dynamic>> engineModels = [
    {
      "name": "TD 2.2 L3",
      "total": 120,
      "today": 45,
      "pass": 40,
      "fail": 3,
      "plan": 50
    },
    {
      "name": "TCD 2.2 L4",
      "total": 95,
      "today": 30,
      "pass": 25,
      "fail": 4,
      "plan": 40
    },
    {
      "name": "TCD 2.9 L4",
      "total": 150,
      "today": 60,
      "pass": 55,
      "fail": 2,
      "plan": 70
    },
    {
      "name": "D 2.9 L4",
      "total": 80,
      "today": 20,
      "pass": 15,
      "fail": 5,
      "plan": 30
    },
    {
      "name": "TD 2.9",
      "total": 60,
      "today": 15,
      "pass": 12,
      "fail": 1,
      "plan": 20
    },
  ].obs;

  // ✅ Add this — reactive selected model
  final selectedModel = <String, dynamic>{}.obs;

  // Keep your existing getter (still works for non-reactive use)
  Map<String, dynamic> get currentModel =>
      engineModels[selectedModelIndex.value];

  // ✅ Add this — call this from sidebar tap
  void selectModel(int index) {
    selectedModelIndex.value = index;
    selectedModel.value = engineModels[index]; // ✅ triggers Obx
  }

  @override
  void onInit() {
    super.onInit();
    selectedModel.value = engineModels[0]; // ✅ set initial
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      appName.value = info.appName;
      version.value = info.version;
      buildNumber.value = info.buildNumber;
    } catch (e) {
      appName.value = "ATPL Tool";
    }
  }
}
