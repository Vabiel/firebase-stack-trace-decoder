import 'package:file_picker/file_picker.dart';

class SystemDialog {
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
      allowedExtensions: ['.symbols'],
      allowMultiple: allowMultiple,
      dialogTitle: dialogTitle,
    );
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
    bool lockParentWindow = false,
    String? initialDirectory,
    String? dialogTitle,
  }) {
    return FilePicker.platform.getDirectoryPath(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      lockParentWindow: lockParentWindow,
    );
  }

  const SystemDialog._();
}
