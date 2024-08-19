import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class GetTasksLocal {
  final TaskRepository repository;

  const GetTasksLocal(this.repository);

  Future<List<TaskModel>> call()async{
    return await repository.getTasksLocal();
  }
}