part of 'decode_result_bloc.dart';

abstract class DecodeResultState extends Equatable {
  const DecodeResultState();
}

class DecodeResultInitial extends DecodeResultState {
  const DecodeResultInitial();

  @override
  List<Object> get props => const [];
}

class DecodeResultSaveInProcess extends DecodeResultState {
  const DecodeResultSaveInProcess();

  @override
  List<Object> get props => const [];
}

class DecodeResultSaveSuccess extends DecodeResultState {
  final String folderPath;

  const DecodeResultSaveSuccess(this.folderPath);

  @override
  List<Object> get props => [folderPath];
}

class DecodeResultSaveFailed extends DecodeResultState {
  const DecodeResultSaveFailed();

  @override
  List<Object> get props => const [];
}
