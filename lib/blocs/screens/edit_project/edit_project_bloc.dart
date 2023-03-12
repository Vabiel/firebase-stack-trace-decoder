import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:firebase_stacktrace_decoder/application/uid_utils.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_project_event.dart';

part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  final Project? input;
  final ProjectLocalProvider projectLocalProvider;

  EditProjectBloc({
    required this.projectLocalProvider,
    required this.input,
  }) : super(const EditProjectInitial()) {
    onBlocEvent(_eventToState);
  }

  Stream<EditProjectState> _eventToState(EditProjectEvent event) async* {
    if (event is EditProjectSavePressed) {
      yield* _saveProject(event);
    } else if (event is EditProjectDeletePressed) {
      yield* _deleteProject(event);
    }
  }

  Stream<EditProjectState> _saveProject(EditProjectSavePressed event) async* {
    final name = event.name;
    final version = event.version;
    final platforms = event.platforms;
    final preview = event.preview;
    Project updatedProject;

    if (input != null) {
      updatedProject = input!.copyWith(
        name: name,
        version: version,
        platforms: platforms,
        preview: preview,
      );
    } else {
      updatedProject = Project(
        uid: UidUtils.v4,
        name: name,
        version: version,
        platforms: platforms,
        preview: preview,
      );
    }
    try {
      await projectLocalProvider.save(updatedProject);
      yield const EditProjectActionComplete(ActionResult.saveSuccess);
    } catch (error) {
      debugPrint('save error: $error');
      yield const EditProjectActionComplete(ActionResult.saveFailed);
    }
  }

  Stream<EditProjectState> _deleteProject(
      EditProjectDeletePressed event) async* {
    try {
      final uid = event.projectUid;
      await projectLocalProvider.deleteByUid(uid);
      yield const EditProjectActionComplete(ActionResult.deleteSuccess);
    } catch (error) {
      debugPrint('delete error: $error');
      yield const EditProjectActionComplete(ActionResult.deleteFailed);
    }
  }
}

extension EditProjectBlocExtension on EditProjectBloc {
  void saveProject({
    required String name,
    required String version,
    required List<Platform> platforms,
    String? preview,
  }) =>
      add(
        EditProjectSavePressed(
          name: name,
          version: version,
          platforms: platforms,
          preview: preview,
        ),
      );

  void deleteProject(String projectUid) =>
      add(EditProjectDeletePressed(projectUid));
}
