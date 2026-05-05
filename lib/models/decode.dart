/// Result of decoding a single stack trace via `flutter symbolize`.
class DecodeResult {
  final String filename;
  final String result;
  final DecodeMode mode;

  const DecodeResult({
    required this.filename,
    required this.result,
    required this.mode,
  });
}

enum DecodeMode { manual, dragging }

extension DecodeModeX on DecodeMode {
  bool get isManual => this == DecodeMode.manual;
  bool get isDragging => this == DecodeMode.dragging;
}
