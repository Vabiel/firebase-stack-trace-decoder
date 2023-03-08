part of 'decode_result_bloc.dart';

abstract class DecodeResultEvent extends Equatable {
  const DecodeResultEvent();
}

class DecodeResultShown extends DecodeResultEvent {
  const DecodeResultShown();

  @override
  List<Object> get props => const [];
}

class DecodeResultSaveFilePressed extends DecodeResultEvent {
  final DecodeResult result;

  const DecodeResultSaveFilePressed(this.result);

  @override
  List<Object> get props => [result];
}

class DecodeResultSaveAllFilesPressed extends DecodeResultEvent {
  final List<DecodeResult> resultList;

  const DecodeResultSaveAllFilesPressed(this.resultList);

  @override
  List<Object> get props => [resultList];
}
