import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:firebase_stacktrace_decoder/application/path_provider.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

part 'decode_result_event.dart';

part 'decode_result_state.dart';

class DecodeResultBloc extends Bloc<DecodeResultEvent, DecodeResultState> {
  final ApplicationPathProvider pathProvider;
  late Directory _outputsDirectory;

  DecodeResultBloc(this.pathProvider) : super(const DecodeResultInitial()) {
    onBlocEvent(_eventToState);
  }

  Stream<DecodeResultState> _eventToState(DecodeResultEvent event) async* {
    if (event is DecodeResultShown) {
      await _onShown();
    } else if (event is DecodeResultSaveFilePressed) {
      yield* _onSaveFile(event);
    } else if (event is DecodeResultSaveAllFilesPressed) {
      yield* _onSaveAllFiles(event);
    }
  }

  Future<void> _onShown() async {
    _outputsDirectory = await pathProvider.getOutputsDir();
  }

  Stream<DecodeResultState> _onSaveFile(
      DecodeResultSaveFilePressed event) async* {
    yield const DecodeResultSaveInProcess();
    final outputsPath = _outputsDirectory.path;
    final result = event.result;
    final isSaveSuccess = await _saveFile(result, outputsPath);
    if (isSaveSuccess) {
      yield DecodeResultSaveSuccess(outputsPath);
    } else {
      yield const DecodeResultSaveFailed();
    }
  }

  Stream<DecodeResultState> _onSaveAllFiles(
      DecodeResultSaveAllFilesPressed event) async* {
    yield const DecodeResultSaveInProcess();

    final list = event.resultList;
    if (list.isNotEmpty) {
      yield const DecodeResultSaveInProcess();
      final outputsPath = _outputsDirectory.path;
      var successSaveCount = 0;
      var failedSaveCount = 0;
      for (final result in list) {
        final isSaveSuccess = await _saveFile(result, outputsPath);
        isSaveSuccess ? successSaveCount++ : failedSaveCount++;
        if (successSaveCount > 0) {
          yield DecodeResultSaveSuccess(outputsPath);
        } else {
          yield const DecodeResultSaveFailed();
        }
      }
    }
  }

  Future<bool> _saveFile(DecodeResult data, String outputsPath) async {
    final filename = pathProvider.getResultFilename(data.filename);
    File file = File(path.join(outputsPath, filename));
    try {
      await file.writeAsString(data.result);
      return true;
    } catch (e) {
      debugPrint('error save file:\n${e.toString()}');
      return false;
    }
  }
}

extension DecodeResultBlocExtension on DecodeResultBloc {
  void shown() => add(const DecodeResultShown());

  void saveFile(DecodeResult result) =>
      add(DecodeResultSaveFilePressed(result));

  void saveAllFiles(List<DecodeResult> decodeList) =>
      add(DecodeResultSaveAllFilesPressed(decodeList));
}
