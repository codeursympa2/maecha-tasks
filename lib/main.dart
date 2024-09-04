import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maecha_tasks/global/bloc/connectivity_checker_bloc.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/routes/app_router.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/constants/theme/light/theme_light.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/login_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/register_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/send_verification_email.dart';
import 'package:maecha_tasks/src/features/authentification/data/sources/network/firestore_auth_datasource.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/auth/auth_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/bottom_sheet/bottom_sheet_bloc.dart';
import 'package:maecha_tasks/src/features/authentification/presentation/bloc/form/auth_form_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/add_task_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/check_task_title_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/delete_all_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/get_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/local/get_total_tasks_local.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/add_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/check_task_title.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/delete_task.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/get_task_by_id.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/get_tasks.dart';
import 'package:maecha_tasks/src/features/task/application/usecases/remote/update_tasks.dart';
import 'package:maecha_tasks/src/features/task/data/sources/local/database_manager.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<DatabaseManager>().initializeDatabase();  // Initialiser la base de données ici
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCheckerBloc>(create: (context) => ConnectivityCheckerBloc()),
        //Authentification
        BlocProvider<AuthBloc>(create: (context)=> AuthBloc(
          loginUser: getIt<LoginUser>(),
          registerUser: getIt<RegisterUser>(),
          sendVerificationEmail: getIt<SendVerificationEmail>(),
          sharedPreferencesService: getIt<SharedPreferencesService>(),
          firestoreAuthDatasource: getIt<FirestoreAuthDatasource>()
        )),
        //Bottom sheet nav
        BlocProvider<BottomSheetBloc>(create: (context)=> BottomSheetBloc()),

        //Auth form
        BlocProvider<AuthFormBloc>(create: (context) => AuthFormBloc()),
        //Task
        BlocProvider<TaskBloc>(create: (context)=> TaskBloc(
            addTask:  getIt<AddTask>(),
            addTaskLocal:  getIt<AddTaskLocal>(),
            deleteTask:  getIt<DeleteTask>(),
            getTasks:  getIt<GetTasks>(),
            updateTask:  getIt<UpdateTasks>(),
            checkTaskTitle:  getIt<CheckTaskTitle>(),
            checkTaskTitleLocal:  getIt<CheckTaskTitleLocal>(),
            local:  getIt<SharedPreferencesService>(),
            deleteAllTasksLocal: getIt<DeleteAllTasksLocal>(),
            getTasksLocal: getIt<GetTasksLocal>(),
            getTotalTasksLocal: getIt<GetTotalTasksLocal>(),
            connCheckerBloc: getIt<ConnectivityCheckerBloc>(),
            getTaskById: getIt<GetTaskById>()
        ))
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: appName,
            routerConfig: AppRouter().router(context),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            theme: ThemeData(
              textTheme: textTheme,
              elevatedButtonTheme: elevatedButtonTheme,
              outlinedButtonTheme: outlinedButtonTheme,
              inputDecorationTheme: inputDecorationTheme,
              colorScheme: colorScheme,
              useMaterial3: true,
            ),
          );
        }
      ),
    );
  }
}