import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/repositories/task_repository.dart';

@lazySingleton
class GetTotalTasksLocal {
  final TaskRepository repository;

  const GetTotalTasksLocal(this.repository);

  Future<int> call()async{
    return await repository.getTotalTasksLocal();
  }
}