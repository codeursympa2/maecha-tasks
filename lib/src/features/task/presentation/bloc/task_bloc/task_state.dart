part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class TaskInitialState extends TaskState {
  const TaskInitialState();
}

final class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}


class TaskCreateSuccessState extends TaskState{
  final String message;
  const TaskCreateSuccessState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class TaskFailureState extends TaskState{
  final String message;
  const TaskFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class TitleExistState extends TaskState{
  final String message;
  const TitleExistState({required this.message});

  @override
  List<Object?> get props => [message];
}

