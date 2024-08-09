import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/add_task_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/check_task_title_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/add_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/check_task_title.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/delete_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/get_tasks.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/update_tasks.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AddTask addTask;
  final AddTaskLocal addTaskLocal;
  final DeleteTask deleteTask;
  final GetTasks getTasks;
  final UpdateTasks updateTask;
  final CheckTaskTitle checkTaskTitle;
  final CheckTaskTitleLocal checkTaskTitleLocal;
  final SharedPreferencesService local;

  TaskBloc(this.addTask,this.addTaskLocal, this.deleteTask, this.getTasks, this.updateTask,this.checkTaskTitle,this.checkTaskTitleLocal,this.local) : super(const TaskInitialState()) {
    on<TaskInitialEvent>((event, emit) {
      emit(const TaskInitialState());
    });

    //online save
    on<CreateTaskRemoteEvent>((event,emit)async{
      emit(const TaskLoadingState());
      try{
        //recupération de currentUser
        UserModel user=local.getUser()!;
        if(!(await checkTaskTitle.call(TaskModel.getTitle(title: event.task.title, user: user,)))){
          await addTask.call(event.task.copyWith(user: user)).whenComplete(()=> emit(const TaskCreateSuccessState(message: taskAdded)));
        }else{
          emit(const TitleExistState(message: titleExist));
        }
      } catch(e){
        emit( TaskFailureState(message: "$failureAddTask\n: $e"));
      }
    });

    //local save
    on<CreateTaskLocaleEvent>((event,emit)async{
      emit(const TaskLoadingState());
      try{
        const duration =Duration(seconds: 1);
        //recupération de currentUser
        UserModel user=local.getUser()!;
        if(!(await checkTaskTitleLocal.call(event.task))){
           await addTaskLocal.call(event.task.copyWith(user:user))
               .whenComplete(()=> Future.delayed(duration,() => emit(const TaskCreateSuccessState(message: taskAdded)),));
        }else{
           await Future.delayed(duration,()=> emit(const TitleExistState(message: titleExist)));
        }
      } catch(e){
        emit( TaskFailureState(message: "$failureAddTask \n: $e"));
      }
    });


  }
}
