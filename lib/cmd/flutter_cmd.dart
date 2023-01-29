import 'dart:io';

import 'package:firebase_stacktrace_decoder/cmd/cmd.dart';
import 'package:logging/logging.dart';

class FlutterCmd extends CmdBase {
  final Cmd cmd;
  final bool isVerbose;
  @override
  final Logger logger;

  bool? _hasFvm;

  FlutterCmd(
    this.cmd, {
    this.isVerbose = false,
    Logger? logger,
  }) : logger = logger ?? Logger('flutter');

  /// Runs `flutter` command.
  Future<ProcessResult> run(
    String command, {
    List<String>? arguments,
    bool immediatePrintStd = true,
    bool immediatePrintErr = true,
    String? workingDir,
  }) async {
    const flutter = 'flutter';

    final String executable;
    final args = <String>[];

    final hasFvm = _hasFvm ??= await _checkIfHasFvm();
    if (hasFvm) {
      executable = _fvmCmd();
      args.add(flutter);
    } else {
      executable = _getPlatformSpecificExecutableName(flutter);
    }

    if (isVerbose) args.add('-v');
    args.add(command);
    if (arguments != null) args.addAll(arguments);

    logger.fine('Run: $executable ${args.join(" ")}');

    return cmd.run(
      executable,
      arguments: args,
      workingDir: workingDir,
      immediatePrintStd: immediatePrintStd,
      immediatePrintErr: immediatePrintErr,
    );
  }

  Future<ProcessResult> runCmdOrFail(
    String cmd, {
    List<String>? arguments,
    bool printStdOut = true,
    bool immediatePrint = true,
  }) async {
    assert(printStdOut || !immediatePrint,
        "You can't disable std output if immediatePrint enabled");
    return runOrFail(
      () => run(
        cmd,
        arguments: arguments,
        immediatePrintStd: immediatePrint && printStdOut,
        immediatePrintErr: false,
      ),
      printStdOut: !immediatePrint && printStdOut,
    );
  }

  /// Runs `flutter doctor` command.
  Future<ProcessResult> doctor({
    List<String>? arguments,
    bool immediatePrintStd = true,
    bool immediatePrintErr = true,
    String? workingDir,
  }) async {
    return run(
      'doctor',
      arguments: <String>[
        if (arguments != null) ...arguments,
      ],
      workingDir: workingDir,
      immediatePrintStd: immediatePrintStd,
      immediatePrintErr: immediatePrintErr,
    );
  }

  /// Runs `flutter symbolize` command.
  Future<ProcessResult> symbolize(
    String input,
    String debugInfo, {
    List<String>? arguments,
    bool immediatePrintStd = true,
    bool immediatePrintErr = true,
    String? workingDir,
  }) async {
    return run(
      'symbolize',
      arguments: <String>[
        '--input=$input',
        '--debug-info=$debugInfo',
        if (arguments != null) ...arguments,
      ],
      workingDir: workingDir,
      immediatePrintStd: immediatePrintStd,
      immediatePrintErr: immediatePrintErr,
    );
  }

  Future<ProcessResult> symbolizeOrFail(
    String input,
    String debugInfo, {
    List<String>? arguments,
    bool printStdOut = true,
    bool immediatePrint = true,
  }) async {
    assert(printStdOut || !immediatePrint,
        "You can't disable std output if immediatePrint enabled");
    return runOrFail(
      () => symbolize(
        input,
        debugInfo,
        arguments: arguments,
        immediatePrintStd: immediatePrint && printStdOut,
        immediatePrintErr: false,
      ),
      printStdOut: !immediatePrint && printStdOut,
    );
  }

  String _getPlatformSpecificExecutableName(String name) {
    if (Platform.isWindows) {
      return '$name.bat';
    }

    return name;
  }

  String _fvmCmd() => _getPlatformSpecificExecutableName('fvm');

  Future<bool> _checkIfHasFvm() async {
    logger.fine('Checking FVM');

    try {
      final res = await cmd.run(
        _fvmCmd(),
        arguments: ['--version'],
        immediatePrintStd: false,
        immediatePrintErr: false,
      );

      if (res.exitCode == 0) {
        logger.info('Use FVM v${res.stdout}');
        return true;
      } else {
        logger.fine('Failed: ${res.stderr} [code: ${res.exitCode}]');
      }
    } on ProcessException catch (e) {
      logger.fine('Failed: ${e.message} [code: ${e.errorCode}]');
    }

    logger.fine('No FVM');
    return false;
  }
}
