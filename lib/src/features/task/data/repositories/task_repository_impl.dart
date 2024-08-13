import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/data/sources/local/task_local_data_source.dart';
import 'package:maecha_tasks/src/features/task/data/sources/network/task_remote_data_source.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository{

  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  const TaskRepositoryImpl({required this.remoteDataSource,required this.localDataSource});

  @override
  Future<void> addTask(TaskModel  task) async{
    await remoteDataSource.createTask(task);
  }

  @override
  Future<void> deleteTask(TaskModel task)async {
    await remoteDataSource.deleteTask(task);
  }

  @override
  Future<List<TaskModel>> getTasks(TaskModel task) async{
    return await remoteDataSource.getTasks(task);
  }

  @override
  Future<void> updateTask(TaskModel task) async{
    await remoteDataSource.updateTask(task);
  }

  @override
  Future<bool> checkTaskTitle(TaskModel task)async {
    return await remoteDataSource.getTaskWithTitle(task.user!.uid!, task.title!);
  }

  @override
  Future<void> addTaskLocal(TaskModel task) async{
    await localDataSource.addTask(task);
  }

  @override
  Future<bool> checkTaskTitleLocal(TaskModel task) async{
    return await localDataSource.getTaskByTitle(task.title!);
  }

  @override
  Future<void> deleteTaskLocal(TaskModel task) async {
    await localDataSource.deleteTask(task.title!);
  }

  @override
  Future<List<TaskModel>> getTasksLocal()async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<int> getTotalTasksLocal()async {
    return await localDataSource.countTasks();
  }

  @override
  Future<void> deleteAllTaskLocal()async {
    localDataSource.deleteAllTasks();
  }
}