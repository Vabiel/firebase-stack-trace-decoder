import 'package:desktop_drop/desktop_drop.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:firebase_stacktrace_decoder/cmd/exception/run_exception.dart';
import 'package:firebase_stacktrace_decoder/cmd/flutter_cmd.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:firebase_stacktrace_decoder/widgets/drop_target_box/drop_target_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'main_screen_event.dart';

part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  late final FlutterCmd cmd;
  late final ProjectLocalProvider projectLocalProvider;

  MainScreenBloc(this.cmd, this.projectLocalProvider)
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
    }
  }

  Stream<MainScreenState> _onStacktraceDragAndDropped(
      MainScreenStacktraceDragAndDropped event) async* {
    final data = event.details;
    if (data.files.isNotEmpty) {
      yield const MainScreenDecodeInProgress();
      final decodeList = <DecodeResult>[];
      final artifact = event.artifact;
      for (final stacktrace in data.files) {
        try {
          final res =
              await cmd.symbolizeOrFail(stacktrace.path, artifact.filePath);
          final result = DecodeResult(
            filename: stacktrace.name,
            result: res.stdout.toString(),
          );
          decodeList.add(result);
        } catch (e) {
          if (e is RunException) {
            final result = DecodeResult(
              filename: stacktrace.name,
              result: e.message ?? 'Unknown error',
            );
            decodeList.add(result);
          } else {
            final result = DecodeResult(
              filename: stacktrace.name,
              result: e.toString(),
            );
            decodeList.add(result);
          }
        }
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
}

extension MainScreenBlocExtension on MainScreenBloc {
  void shown() => add(const MainScreenShown());

  void changeProject() => add(const MainScreenProjectChanged());

  void removeProject(String projectUid) =>
      add(MainScreenProjectRemoved(projectUid));

  void decodeStacktrace(DropDoneDetails details, Artifact artifact) =>
      add(MainScreenStacktraceDragAndDropped(details, artifact));
}
