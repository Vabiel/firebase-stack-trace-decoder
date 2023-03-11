import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/di_initializer.dart';
import 'package:firebase_stacktrace_decoder/repositories/project_local_provider/project_local_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:get/get.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    onBlocEvent(_eventToState);
  }

  Stream<AppState> _eventToState(AppEvent event) async* {
    if (event is AppShown) {
      yield* _onShown(event);
    } else if (event is AppLaunchScreenShown) {
      yield* _onLaunchScreenShown(event);
    }
  }

  /// Состояние показа приложения.
  Stream<AppState> _onShown(AppShown event) async* {
    yield const AppLoadInProgress();
    if (!DependencyInjectionInitializer.isInitialized) {
      await DependencyInjectionInitializer.initialize();
    }
    yield const AppReady();
    log('App ready');
    yield const AppReadySuccess();
  }

  Stream<AppState> _onLaunchScreenShown(AppLaunchScreenShown event) async* {
    log('App started');
    yield const AppLoadSuccess();
  }
}

extension AppBlocExtension on AppBloc {
  void shown() => add(const AppShown());
}
