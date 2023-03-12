import 'dart:io';

import 'package:path_provider/path_provider.dart' as provider;
import 'package:path/path.dart' as path;

/// Path provider for the application.
class ApplicationPathProvider {
  Future<Directory> getDatabaseDir() async {
    return _getApplicationDirectory('stacktrace_decoder');
  }

  Future<Directory> getOutputsDir() async {
    final mainDir = await getDatabaseDir();
    final result = _getSubDir(mainDir, 'outputs');
    return result;
  }

  Future<Directory> getTempDir() async {
    final mainDir = await getDatabaseDir();
    final result = _getSubDir(mainDir, 'temp');
    return result;
  }

  Future<Directory> _getApplicationDirectory([String? subDirName]) async {
    var result = await provider.getApplicationDocumentsDirectory();
    if (subDirName != null) result = await _getSubDir(result, subDirName);
    return result;
  }

  // ignore: unused_element
  Future<Directory> _getTemporaryDirectory(String subDirName) async {
    var parent = await provider.getTemporaryDirectory();
    var result = await _getSubDir(parent, subDirName);
    return result;
  }

  Future<Directory> _getSubDir(Directory parent, String subDirName) async {
    Directory result = Directory(path.join(parent.path, subDirName));

    if (!await result.exists()) {
      await result.create();
    }

    return result;
  }

  String getResultFilename(String decodeFilename) {
    final now = DateTime.now();
    final decodeName = path.basenameWithoutExtension(decodeFilename);
    final name = 'result_${decodeName}_${now.millisecondsSinceEpoch}.txt';
    return name;
  }

  String getTempFileName() {
    final now = DateTime.now();
    return 'temp_${now.millisecondsSinceEpoch}.txt';
  }
}
