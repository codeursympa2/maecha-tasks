part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class TaskInitialEvent extends TaskEvent{
  const TaskInitialEvent();
}
class CreateTaskRemoteEvent extends TaskEvent{
  final TaskModel task;

  const CreateTaskRemoteEvent({required this.task});

  @override
  List<Object?> get props => [task];
}
class CreateTaskLocaleEvent extends TaskEvent{
  final TaskModel task;

  const CreateTaskLocaleEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

final class SyncDataToCloudFirestore extends TaskEvent{
  const SyncDataToCloudFirestore();
}

final class GetTasksRemote extends TaskEvent{
  const GetTasksRemote();
}
