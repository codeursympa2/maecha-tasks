import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class DeleteTask{
  final TaskRepository repository;

  const DeleteTask({required this.repository});

  Future<void> call(TaskModel task)async{
    await repository.deleteTask(task);
  }
}