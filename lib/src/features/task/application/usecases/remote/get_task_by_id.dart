import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/data/repositories/task_repository_impl.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class GetTaskById{
  final TaskRepository repo;
  const GetTaskById({required this.repo});

  Future<TaskModel?> call(TaskModel task)async{
    return await repo.getTaskByIdRemote(task);
  }
}