import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocExtension<E, S> on Bloc<E, S> {
  FutureOr<void> onBlocEvent(Stream<S> Function(E event) mapEventToState) {
    on<E>(
        (event, emit) =>
            emit.forEach(mapEventToState(event), onData: (S state) => state),
        transformer: sequential());
  }

  Future<T?> waitForState<T extends S>() async {
    assert(T != Object && T != S, 'You should provide state type explicitly');

    if (state is T) return state as T;

    await for (final item in stream) {
      if (item is T) return item;

      if (state is T) return state as T;
    }

    return null;
  }
}
