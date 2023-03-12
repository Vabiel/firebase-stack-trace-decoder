part of 'main_screen_bloc.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();
}

class MainScreenShown extends MainScreenEvent {
  const MainScreenShown();

  @override
  List<Object?> get props => const [];
}

class MainScreenProjectChanged extends MainScreenEvent {
  const MainScreenProjectChanged();

  @override
  List<Object> get props => const [];
}

class MainScreenProjectRemoved extends MainScreenEvent {
  final String projectUid;

  const MainScreenProjectRemoved(this.projectUid);

  @override
  List<Object?> get props => [projectUid];
}

class MainScreenStacktraceDragAndDropped extends MainScreenEvent {
  final DropDoneDetails details;
  final Artifact artifact;

  const MainScreenStacktraceDragAndDropped(this.details, this.artifact);

  @override
  List<Object?> get props => [details, artifact];
}

class MainScreenStacktraceManualDecoded extends MainScreenEvent {
  final Artifact artifact;
  final List<String> stackTraceList;

  const MainScreenStacktraceManualDecoded(this.artifact, this.stackTraceList);

  @override
  List<Object?> get props => [artifact, stackTraceList];
}
