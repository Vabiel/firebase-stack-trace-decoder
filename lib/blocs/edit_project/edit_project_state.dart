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
  final CompleteResult completeResult;

  const EditProjectActionComplete(this.completeResult);

  @override
  List<Object> get props => [completeResult];
}

class CompleteResult {
  final ActionResult result;
  final Project? project;

  const CompleteResult(this.result, [this.project]);

  @override
  String toString() {
    return 'CompleteResult{result: $result, project: $project}';
  }
}

enum ActionResult {
  saveSuccess,
  saveFailed,
  deleteSuccess,
  deleteFailed,
}
