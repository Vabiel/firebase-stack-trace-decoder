import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/application/di_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<AppShown>(_onShown);
    on<AppLaunchScreenHidden>(_onLaunchScreenHidden);
  }

  /// Состояние показа приложения.
  Future<void> _onShown(AppShown event, Emitter<AppState> emit) async {
    emit(const AppLoadInProgress());
    if (!DependencyInjectionInitializer.isInitialized) {
      await DependencyInjectionInitializer.initialize();
    }
    emit(const AppReady());
    log('App ready');
    emit(const AppReadySuccess());
  }

  void _onLaunchScreenHidden(
      AppLaunchScreenHidden event, Emitter<AppState> emit) {
    log('App started');
    emit(const AppLoadSuccess());
  }
}

extension AppBlocExtension on AppBloc {
  void shown() => add(const AppShown());
}
