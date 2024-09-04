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

final class GetTasksEvent extends TaskEvent{
  const GetTasksEvent();
}

class FilterTasksEvent extends TaskEvent{
  final List<TaskModel> list;
  final int tag;
  const FilterTasksEvent({required this.list,required this.tag});

  @override
  // TODO: implement props
  List<Object?> get props => [list,tag];
}


final class GetTasksLocalEvent extends TaskEvent{
  const GetTasksLocalEvent();
}


class DeleteTaskRemoteEvent extends TaskEvent{
  final TaskModel task;

  const DeleteTaskRemoteEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class GetTaskEditEvent extends TaskEvent{
  final String idTask;
  const GetTaskEditEvent({required this.idTask});

  @override
  List<Object?> get props => [idTask];
}




class UpdateTaskEvent extends TaskEvent{
  final TaskModel task;

  const UpdateTaskEvent({required this.task});

  @override
  // TODO: implement props
  List<Object?> get props => [task];
}
