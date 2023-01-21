import 'dart:io';

import 'package:path_provider/path_provider.dart' as provider;
import 'package:path/path.dart' as path;

/// Path provider for the application.
class ApplicationPathProvider {


  Future<Directory> getDatabaseDir() async {
    return _getApplicationDirectory();
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
}
