part of 'edit_project_bloc.dart';

abstract class EditProjectEvent extends Equatable {
  const EditProjectEvent();
}

class EditProjectSavePressed extends EditProjectEvent {
  final String name;
  final String version;
  final String? preview;
  final List<Platform> platforms;

  const EditProjectSavePressed({
    required this.name,
    required this.version,
    required this.platforms,
    this.preview,
  });

  @override
  List<Object?> get props => [
        name,
        version,
        preview,
        platforms,
      ];
}

class EditProjectDeletePressed extends EditProjectEvent {
  final String projectUid;

  const EditProjectDeletePressed(this.projectUid);

  @override
  List<Object> get props => [projectUid];
}
