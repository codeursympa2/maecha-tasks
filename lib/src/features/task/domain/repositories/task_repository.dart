import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';

abstract class TaskRepository {
    Future<List<TaskModel>> getTasks(TaskModel task);
    Future<List<TaskModel>> getTasksLocal();

    Future<void> addTask(TaskModel task);
    Future<void> addTaskLocal(TaskModel task);

    Future<void> updateTask(TaskModel task);

    Future<void> deleteTask(TaskModel task);
    Future<void> deleteTaskLocal(TaskModel task);
    Future<void> deleteAllTaskLocal();

    Future<bool> checkTaskTitle(TaskModel task);
    Future<bool> checkTaskTitleLocal(TaskModel task);

    Future<int> getTotalTasksLocal();
}