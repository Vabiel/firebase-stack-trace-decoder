part of 'edit_project_bloc.dart';

abstract class EditProjectEvent extends Equatable {
  const EditProjectEvent();
}

class EditProjectSavePressed extends EditProjectEvent {
  final String name;
  final String? preview;
  final List<ProjectVersion> versions;

  const EditProjectSavePressed({
    required this.name,
    required this.versions,
    this.preview,
  });

  @override
  List<Object?> get props => [
        name,
        preview,
        versions,
      ];
}

class EditProjectDeletePressed extends EditProjectEvent {
  final String projectUid;

  const EditProjectDeletePressed(this.projectUid);

  @override
  List<Object> get props => [projectUid];
}
