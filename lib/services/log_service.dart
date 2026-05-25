import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LogService {
  static File? _file;

  static bool enabled = false;

  /// INIT LOG FILE
  static Future<void> init({required bool enableLog}) async {
    enabled = enableLog;

    if (!enabled) return;

    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/app_logs.txt');

    if (!await _file!.exists()) {
      await _file!.create();
    }
  }

  /// WRITE LOG (APPEND MODE)
  static Future<void> log(String message) async {
    if (!enabled) return;

    final time = DateTime.now().toIso8601String();
    final log = "[$time] $message\n";

    await _file?.writeAsString(
      log,
      mode: FileMode.append,
      flush: true,
    );
  }

  /// CLEAR LOG
  static Future<void> clear() async {
    if (!enabled) return;
    await _file?.writeAsString("");
  }
}