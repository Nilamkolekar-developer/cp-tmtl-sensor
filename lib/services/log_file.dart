import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LogFile {
  static File? _file;

  static Future<void> init() async {
    // Windows Documents folder (safe way)
    final documentsPath =
        "${Platform.environment['USERPROFILE']}\\Documents";

    final dir = Directory(documentsPath);

    _file = File("${dir.path}\\app_log.txt");

    if (!await _file!.exists()) {
      await _file!.create(recursive: true);
    }
  }

  static Future<void> write(String text) async {
    if (_file == null) {
      await init();
    }

    final time = DateTime.now().toIso8601String();

    await _file!.writeAsString(
      "[$time] $text\n",
      mode: FileMode.append,
    );
  }
}