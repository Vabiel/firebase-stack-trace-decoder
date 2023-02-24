import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

part 'edit_project_event.dart';

part 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  final Project? input;
  late final ProjectLocalProvider _projectLocalProvider;

  EditProjectBloc(this.input) : super(const EditProjectInitial()) {
    final di = GetIt.instance;
    _projectLocalProvider = di.get();
    on<EditProjectSavePressed>(_saveProject);
    on<EditProjectDeletePressed>(_deleteProject);
  }

  Future<void> _saveProject(
      EditProjectSavePressed event, Emitter<EditProjectState> emit) async {
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
      const uuid = Uuid();
      final uid = uuid.v4();

      updatedProject = Project(
        uid: uid,
        name: name,
        version: version,
        platforms: platforms,
        preview: preview,
      );
    }
    try {
      await _projectLocalProvider.save(updatedProject);
      emit(EditProjectActionComplete(
          CompleteResult(ActionResult.saveSuccess, updatedProject)));
    } catch (error) {
      debugPrint('save error: $error');
      emit(const EditProjectActionComplete(
          CompleteResult(ActionResult.saveFailed)));
    }
  }

  Future<void> _deleteProject(
      EditProjectDeletePressed event, Emitter<EditProjectState> emit) async {
    try {
      final uid = event.projectUid;
      await _projectLocalProvider.deleteByUid(uid);
      emit(const EditProjectActionComplete(
          CompleteResult(ActionResult.deleteSuccess)));
    } catch (error) {
      debugPrint('delete error: $error');
      emit(const EditProjectActionComplete(
          CompleteResult(ActionResult.deleteFailed)));
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
