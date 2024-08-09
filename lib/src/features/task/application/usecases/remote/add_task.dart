import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class AddTask{
  final TaskRepository repository;

  const AddTask({required this.repository});

  Future<void> call(TaskModel task)async{
    await repository.addTask(task);
  }
}