import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:firebase_stacktrace_decoder/application/path_provider.dart';
import 'package:firebase_stacktrace_decoder/cmd/exception/run_exception.dart';
import 'package:firebase_stacktrace_decoder/cmd/flutter_cmd.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:firebase_stacktrace_decoder/widgets/platform_tab_data/platform_tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

part 'main_screen_event.dart';

part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final FlutterCmd cmd;
  final ProjectLocalProvider projectLocalProvider;
  final ApplicationPathProvider pathProvider;

  MainScreenBloc(this.cmd, this.projectLocalProvider, this.pathProvider)
      : super(const MainScreenInitial()) {
    onBlocEvent(_eventToState);
  }

  Stream<MainScreenState> _eventToState(MainScreenEvent event) async* {
    if (event is MainScreenShown) {
      yield* _toLoadSuccess(event);
    } else if (event is MainScreenProjectChanged) {
      yield* _toLoadSuccess(event);
    } else if (event is MainScreenProjectRemoved) {
      yield* _onProjectRemoved(event);
    } else if (event is MainScreenStacktraceDragAndDropped) {
      yield* _onStacktraceDragAndDropped(event);
    } else if (event is MainScreenStacktraceManualDecoded) {
      yield* _onStacktraceManualDecoded(event);
    }
  }

  Stream<MainScreenState> _onStacktraceManualDecoded(
      MainScreenStacktraceManualDecoded event) async* {
    final stackTraceList = event.stackTraceList;
    if (stackTraceList.isNotEmpty) {
      final artifact = event.artifact;
      final tempDir = await pathProvider.getTempDir();
      final decodeList = <DecodeResult>[];
      yield const MainScreenDecodeInProgress();
      for (final stackTrace in stackTraceList) {
        if (stackTrace.isNotEmpty) {
          final tempFileName = pathProvider.getTempFileName();
          final fullPath = path.join(tempDir.path, tempFileName);
          final file = File(fullPath);
          final isSaveSuccess = await _saveTempFile(file, stackTrace);
          if (isSaveSuccess) {
            final data =
                await _decodeStackTrace(artifact, FileData.fromFile(file));
            decodeList.add(data);
            await file.delete();
          }
        }
      }
      yield MainScreenDecodeSuccess(decodeList);
    }
    yield* _toLoadSuccess(event);
  }

  Stream<MainScreenState> _onStacktraceDragAndDropped(
      MainScreenStacktraceDragAndDropped event) async* {
    final data = event.details;
    if (data.files.isNotEmpty) {
      yield const MainScreenDecodeInProgress();
      final decodeList = <DecodeResult>[];
      final artifact = event.artifact;
      for (final stacktrace in data.files) {
        final data =
            await _decodeStackTrace(artifact, FileData.fromXFile(stacktrace));
        decodeList.add(data);
      }
      yield MainScreenDecodeSuccess(decodeList);
    }
    yield* _toLoadSuccess(event);
  }

  Stream<MainScreenState> _onProjectRemoved(
      MainScreenProjectRemoved event) async* {
    final projectUid = event.projectUid;
    await projectLocalProvider.deleteByUid(projectUid);
    yield* _toLoadSuccess(event);
  }

  Stream<MainScreenState> _toLoadSuccess(MainScreenEvent event) async* {
    yield const MainScreenLoadInProgress();
    final list = await projectLocalProvider.getAll();
    yield MainScreenLoadSuccess(list);
  }

  Future<DecodeResult> _decodeStackTrace(
      Artifact artifact, FileData fileData) async {
    final mode = fileData.mode;
    try {
      final res =
          await cmd.symbolizeOrFail(fileData.filePath, artifact.filePath);
      final result = DecodeResult(
        filename: fileData.name,
        mode: mode,
        result: res.stdout.toString(),
      );
      return result;
    } catch (e) {
      if (e is RunException) {
        final result = DecodeResult(
          filename: fileData.name,
          mode: mode,
          result: e.message ?? 'Unknown error',
        );
        return result;
      } else {
        final result = DecodeResult(
          filename: fileData.name,
          mode: mode,
          result: e.toString(),
        );
        return result;
      }
    }
  }

  Future<bool> _saveTempFile(File file, String source) async {
    try {
      await file.writeAsString(source);
      return true;
    } catch (e) {
      debugPrint('error save file:\n${e.toString()}');
      return false;
    }
  }
}

extension MainScreenBlocExtension on MainScreenBloc {
  void shown() => add(const MainScreenShown());

  void changeProject() => add(const MainScreenProjectChanged());

  void removeProject(String projectUid) =>
      add(MainScreenProjectRemoved(projectUid));

  void decodeDragging(DropDoneDetails details, Artifact artifact) =>
      add(MainScreenStacktraceDragAndDropped(details, artifact));

  void decodeManual(Artifact artifact, List<String> stackTraceList) =>
      add(MainScreenStacktraceManualDecoded(artifact, stackTraceList));
}

class FileData {
  final XFile? xFile;
  final File? file;

  FileData({this.xFile, this.file})
      : assert(xFile == null && file != null || xFile != null && file == null);

  String get name => xFile?.name ?? path.basename(file!.path);

  String get filePath => xFile?.path ?? file!.path;

  DecodeMode get mode =>
      xFile == null ? DecodeMode.manual : DecodeMode.dragging;

  factory FileData.fromXFile(XFile xFile) => FileData(xFile: xFile);

  factory FileData.fromFile(File file) => FileData(file: file);
}
