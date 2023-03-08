part of 'main_screen_bloc.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();
}

class MainScreenInitial extends MainScreenState {
  const MainScreenInitial();

  @override
  List<Object> get props => const [];
}

class MainScreenLoadInProgress extends MainScreenState {
  const MainScreenLoadInProgress();

  @override
  List<Object> get props => const [];
}

class MainScreenLoadSuccess extends MainScreenState {
  final List<Project> projects;
  const MainScreenLoadSuccess(this.projects);

  @override
  List<Object> get props => [projects];
}

class MainScreenDecodeSuccess extends MainScreenState {
  final List<DecodeResult> decodeList;
  const MainScreenDecodeSuccess(this.decodeList);

  @override
  List<Object> get props => [decodeList];
}

class MainScreenDecodeInProgress extends MainScreenState {
  const MainScreenDecodeInProgress();

  @override
  List<Object> get props => const [];
}
