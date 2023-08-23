import "dart:io";
import "dart:async";
import "dart:convert";

import "package:path_provider/path_provider.dart";

class FileUtil {
  const FileUtil(this.filePath);

  final String filePath;

  Future<String> _getLocalPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> _getLocalFile() async {
    final localPath = await _getLocalPath();
    return File("$localPath/$filePath");
  }

  Future<bool> exists() async {
    final file = await _getLocalFile();
    return file.exists();
  }

  Future<File> createFile(String initialContent) async {
    final file = await _getLocalFile();
    file.create();
    file.writeAsString(initialContent);
    return file;
  }

  Future<String> readFile() async {
    final file = await _getLocalFile();
    return file.readAsString();
  }

  Future<Map> readFileJSON() async {
    final file = await _getLocalFile();
    return jsonDecode(await file.readAsString());
  }
}
