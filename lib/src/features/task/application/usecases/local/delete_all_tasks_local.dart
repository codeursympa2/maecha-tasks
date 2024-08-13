import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class DeleteAllTasksLocal {
  final TaskRepository repository;

  const DeleteAllTasksLocal(this.repository);

  Future<void> call()async{
    await repository.deleteAllTaskLocal();
  }
}