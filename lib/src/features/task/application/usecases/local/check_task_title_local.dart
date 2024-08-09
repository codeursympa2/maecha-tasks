import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class CheckTaskTitleLocal{
  final TaskRepository repository;

  const CheckTaskTitleLocal(this.repository);

  Future<bool> call(TaskModel task)async{
    return await repository.checkTaskTitleLocal(task);
  }
}