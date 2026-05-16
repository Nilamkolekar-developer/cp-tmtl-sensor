import 'package:cp_tmtl_sensor_zig/app.dart';

class AtomURLType {
  static const String LOCAL = "LOCAL";
  static const String DEV = 'DEV';
  static const String PROD = 'PROD';
}

class AppEnvironment {
  static const String _localUrl = "http://192.168.50.200:7102";
  static const String _devUrl = 'http://192.168.50.200:7102';
  static const String _prodUrl = 'http://192.168.50.200:7102';

  static bool get baseProdInstance {
    if (baseUrl == _prodUrl) {
      return true;
    } else {
      return false;
    }
  }

  static String get baseUrl {
    switch (App.instance.baseURLType) {
      case AtomURLType.DEV:
        return _devUrl;
      case AtomURLType.PROD:
        return _prodUrl;
      case AtomURLType.LOCAL:
        return _localUrl;
    }

    return "http://192.168.50.200:7102";
  }
}
