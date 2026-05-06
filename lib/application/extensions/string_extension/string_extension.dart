import 'package:firebase_stacktrace_decoder/models/core/platform/platform.dart';

extension StrackTraceExtenion on String {
  String prepareStackTrace(PlatformType platformType) {
    const emptyStr = '';
    const commonPatternPart =
        r' _kDartIsolateSnapshotInstructions\+0x[0-9a-f]{4,8}';
    const androidPattern =
        r'#\d{2} abs [0-9a-f]+ virt [0-9a-f]{16}' + commonPatternPart;

    const iOSPattern = r'#\d{2} abs [0-9a-f]+' + commonPatternPart;
    const space = '    ';

    final androidPlatformRegExp = RegExp(androidPattern, caseSensitive: false);
    final iOSPlatformRegExp = RegExp(iOSPattern, caseSensitive: false);

    if (isNotEmpty) {
      final buffer = StringBuffer();
      RegExp regExp;

      switch (platformType) {
        case PlatformType.ios:
          regExp = iOSPlatformRegExp;
          break;
        case PlatformType.android:
        // TODO: support it
        case PlatformType.linux:
        case PlatformType.macos:
        case PlatformType.windows:
        case PlatformType.fuchsia:
          regExp = androidPlatformRegExp;
      }

      final matches = regExp.allMatches(this);

      for (var match in matches) {
        final line = match.group(0);
        buffer.writeln('$space$line');
      }

      return buffer.isNotEmpty ? buffer.toString() : emptyStr;
    }
    return emptyStr;
  }
}
