part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class AppShown extends AppEvent {
  const AppShown();

  @override
  List<Object> get props => const [];
}

class AppLaunchScreenHidden extends AppEvent {
  const AppLaunchScreenHidden();

  @override
  List<Object> get props => const [];
}
