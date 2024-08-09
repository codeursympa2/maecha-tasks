import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class CheckTaskTitle{
  final TaskRepository repository;

  const CheckTaskTitle({required this.repository});

  Future<bool> call(TaskModel task)async{
    return await repository.checkTaskTitle(task);
  }
}