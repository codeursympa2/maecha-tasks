import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';
@lazySingleton
class AddTaskLocal{
    final TaskRepository repository;

    const AddTaskLocal(this.repository);

    Future<void> call(TaskModel task)async{
      await repository.addTaskLocal(task);
    }
}