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

final class TaskLoadingShimmerState extends TaskState {
  const TaskLoadingShimmerState();
}

class TaskLoadedState extends TaskState {
  final List<TaskModel> taskList;
  const TaskLoadedState({required this.taskList});

  @override
  // TODO: implement props
  List<Object?> get props => [taskList];
}

class ListTaskFilteredState extends TaskState {
  final List<TaskModel> taskList;
  const ListTaskFilteredState({required this.taskList});

  @override
  // TODO: implement props
  List<Object?> get props => [taskList];
}

class TaskCreateSuccessState extends TaskState{
  final String message;
  const TaskCreateSuccessState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class TaskDeleteSuccessState extends TaskState{
  final String message;
  const TaskDeleteSuccessState({required this.message});

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

class TaskDeleteFailureState extends TaskState{
  final String message;
  const TaskDeleteFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class TitleExistState extends TaskState{
  final String message;
  const TitleExistState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EmptyListTasksState extends TaskState{
  const EmptyListTasksState();
}


//
final class SyncData extends TaskState{
  const SyncData();
}

class SyncDataCompleted extends TaskState{
  const SyncDataCompleted();
}

final class SyncDataFailure extends TaskState{
  const SyncDataFailure();
}


class DoublonState extends TaskState{
  final String message;
  const DoublonState(this.message);
}


