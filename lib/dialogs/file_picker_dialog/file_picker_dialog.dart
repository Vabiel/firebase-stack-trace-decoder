import 'package:file_picker/file_picker.dart';

class FilePickerDialog {
  static Future<FilePickerResult?> pickSymbol({
    String? dialogTitle,
  }) {
    return _pickSymbols(
      dialogTitle: dialogTitle,
      allowMultiple: false,
    );
  }

  static Future<FilePickerResult?> pickSymbols({
    String? dialogTitle,
  }) {
    return _pickSymbols(dialogTitle: dialogTitle);
  }

  static Future<FilePickerResult?> _pickSymbols({
    bool allowMultiple = true,
    String? dialogTitle,
  }) {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['symbols'],
      allowMultiple: allowMultiple,
      dialogTitle: dialogTitle,
    );
  }

  static Future<PlatformFile?> pickImage({
    String? dialogTitle,
  }) {
    return _pickImage(dialogTitle: dialogTitle);
  }

  static Future<PlatformFile?> _pickImage({
    String? dialogTitle,
  }) async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: dialogTitle,
    );
    if (res != null && res.files.isNotEmpty) {
      return res.files.first;
    }
    return null;
  }

  static Future<FilePickerResult?> pickFile({
    String? dialogTitle,
  }) {
    return _pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: false,
    );
  }

  static Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
  }) {
    return _pickFiles(
      dialogTitle: dialogTitle,
    );
  }

  static Future<FilePickerResult?> _pickFiles({
    bool allowMultiple = true,
    String? dialogTitle,
  }) {
    return FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      dialogTitle: dialogTitle,
    );
  }

  static Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? dialogTitle,
  }) {
    return FilePicker.platform.getDirectoryPath(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
    );
  }

  static Future<String?> saveFile({
    String? initialDirectory,
    String? dialogTitle,
  }) {
    return FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
    );
  }

  const FilePickerDialog._();
}
