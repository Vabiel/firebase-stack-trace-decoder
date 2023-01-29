import 'package:file_picker/file_picker.dart';

class OpenFileDialog {
  static Future<FilePickerResult?> pickSymbol({
    String? dialogTitle,
  }) {
    return _pickSymbols(
      dialogTitle: dialogTitle,
    );
  }

  static Future<FilePickerResult?> pickSymbols({
    String? dialogTitle,
  }) {
    return _pickSymbols(dialogTitle: dialogTitle, allowMultiple: true);
  }

  static Future<FilePickerResult?> _pickSymbols({
    bool allowMultiple = false,
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
    );
  }

  static Future<FilePickerResult?> pickFiles({
    bool allowMultiple = false,
    String? dialogTitle,
  }) {
    return _pickFiles(
      allowMultiple: allowMultiple,
      dialogTitle: dialogTitle,
    );
  }

  static Future<FilePickerResult?> _pickFiles({
    bool allowMultiple = false,
    String? dialogTitle,
  }) {
    return FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      dialogTitle: dialogTitle,
    );
  }

  const OpenFileDialog._();
}
