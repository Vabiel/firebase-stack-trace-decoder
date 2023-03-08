part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();

  @override
  List<Object> get props => const [];
}

class AppLoadInProgress extends AppState {
  const AppLoadInProgress();

  @override
  List<Object> get props => const [];
}

class AppReady extends AppState {
  const AppReady();

  @override
  List<Object> get props => const [];
}

class AppReadySuccess extends AppState {
  const AppReadySuccess();

  @override
  List<Object> get props => const [];
}

class AppLoadSuccess extends AppState {

  const AppLoadSuccess();

  @override
  List<Object?> get props => const [];
}
