import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/add_task_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/check_task_title_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/delete_all_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/get_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/get_total_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/add_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/check_task_title.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/delete_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/get_tasks.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/update_tasks.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  //remote
  final AddTask addTask;
  final DeleteTask deleteTask;
  final GetTasks getTasks;
  final UpdateTasks updateTask;
  final CheckTaskTitle checkTaskTitle;
  //local
  final CheckTaskTitleLocal checkTaskTitleLocal;
  final AddTaskLocal addTaskLocal;
  final GetTasksLocal getTasksLocal;
  final GetTotalTasksLocal getTotalTasksLocal;
  final DeleteAllTasksLocal deleteAllTasksLocal;
  //
  final SharedPreferencesService local;

  //
  final ConnectivityCheckerBloc connCheckerBloc;

  TaskBloc(
      {
      required this.addTask,
      required this.addTaskLocal,
      required this.deleteTask,
      required this.getTasks,
      required this.updateTask,
      required this.checkTaskTitle,
      required this.checkTaskTitleLocal,
      required this.getTotalTasksLocal,
      required this.getTasksLocal,
      required this.deleteAllTasksLocal,
      required this.local,
      required this.connCheckerBloc
      }) : super(const TaskInitialState()) {
    on<TaskInitialEvent>((event, emit) {
      emit(const TaskInitialState());
    });

    //online save
    on<CreateTaskRemoteEvent>((event,emit)async{
      emit(const TaskLoadingState());
      try{
        if(await _checkTitleRemote(event.task)){
          await _createTaskRemote(event.task).whenComplete(()=> emit(const TaskCreateSuccessState(message: taskAdded)));
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


    //Syncronisation des données
    on<SyncDataToCloudFirestore>((event,emit)async{
      int totalTaskListLocal=await getTotalTasksLocal.call();
      //Si nous avons au moins 1 enregistrement en local
      if(totalTaskListLocal >= 1){
        emit(const SyncData()); //on notifie à l'utilisateur que la syncronisation est en cours
        //Récupération des tâches en local
        List<TaskModel> localData=await getTasksLocal.call();

       try{
         //Tableau des tâches dupliqués
         int doub=0;
         //On parcours la liste et ajoute 1 à 1 à cloudFirestore
         for(var task in localData){
           //Si nous n'avons t pa
           if(await _checkTitleRemote(task)){
             await _createTaskRemote(task.copyWith(user:local.getUser()));
           }else{
             doub++;
           }
         }
         //On vide maitenant la partie local
         await deleteAllTasksLocal.call();

         //Notification de doublons
         String message=doub > 1 ? "Plusieurs doublons supprimés" : "Un doublon supprimé";
         doub >= 1 ? await Future.delayed(const Duration(seconds: 2),()=> emit(DoublonState(message))) : null;

         emit(const SyncDataCompleted());
         add(const GetTasksEvent());
       }catch(e){
         print(e);
         emit(const SyncDataFailure());
       }
      }
    });

    on<GetTasksEvent>((event,emit) async{
      emit(const TaskLoadingState());
      try{
        List<TaskModel> list = [];

        // Vérifie l'état actuel de la connectivité
        final currentState = connCheckerBloc.state;

        if (currentState is ConnectionInternetState) {
          // Connexion Internet disponible
          list = await getTasks.call(TaskModel.getTasks(user: local.getUser()));
        } else if (currentState is NoConnectionInternetState) {
          // Pas de connexion, récupérer les tâches localement
          await Future.delayed(const Duration(seconds: 2),() async {
            list = await getTasksLocal.call();
          });
        }

        if(list.isNotEmpty){
          emit(TaskLoadedState(taskList: list));
        }else{
          emit(const EmptyListTasksState());
        }
      }catch(e){
        print(e);
        emit(const TaskFailureState(message: failedLoadList));
      }
    });

    on<FilterTasksEvent>((event,emit){
      if (event.tag == -1) {
        emit(TaskLoadedState(taskList: event.list)) ;
      }else{
        final now = DateTime.now();

        final filteredTasks = event.list.where((task) {
          if (task.dateTime == null) return false;

          switch (event.tag) {
            case 0: // Aujourd'hui
              return isSameDay(task.dateTime!, now);
            case 1: // Hier
              final yesterday = now.subtract(const Duration(days: 1));
              return isSameDay(task.dateTime!, yesterday);
            case 2: // Demain
              final tomorrow = now.add(const Duration(days: 1));
              return isSameDay(task.dateTime!, tomorrow);
            case 3: // Semaine prochaine
              final nextWeekStart = now.add(Duration(days: (7 - now.weekday + 1)));
              final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
              return task.dateTime!.isAfter(nextWeekStart) &&
                  task.dateTime!.isBefore(nextWeekEnd);
            case 4: // Mois passé
              final lastMonth = DateTime(now.year, now.month - 1);
              return isSameMonth(task.dateTime!, lastMonth);
            case 5: // Mois prochain
              final nextMonth = DateTime(now.year, now.month + 1);
              return isSameMonth(task.dateTime!, nextMonth);
            default: // Aujourd'hui
              return isSameDay(task.dateTime!, now);
          }
        }).toList();


         emit(ListTaskFilteredState(taskList: filteredTasks));
      }

    });

  }



  Future<void> _createTaskRemote(TaskModel task)async{
    //recupération de currentUser
    UserModel user=local.getUser()!;
      await addTask.call(task.copyWith(user: user));
  }

  Future<bool> _checkTitleRemote(TaskModel task)async{
    return !(await checkTaskTitle.call(TaskModel.getTitle(title: task.title, user: local.getUser(),)));
  }
}
