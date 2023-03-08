part of 'edit_project_bloc.dart';

abstract class EditProjectState extends Equatable {
  const EditProjectState();
}

class EditProjectInitial extends EditProjectState {
  const EditProjectInitial();

  @override
  List<Object> get props => const [];
}

class EditProjectActionComplete extends EditProjectState {
  final ActionResult result;

  const EditProjectActionComplete(this.result);

  @override
  List<Object> get props => [result];
}

enum ActionResult {
  saveSuccess,
  saveFailed,
  deleteSuccess,
  deleteFailed,
}
