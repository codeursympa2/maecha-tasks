import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class GetTasks{
  final TaskRepository repository;

  const GetTasks({required this.repository});

  Future<List<TaskModel>> call(TaskModel task)async{
    return await repository.getTasks(task);
  }
}