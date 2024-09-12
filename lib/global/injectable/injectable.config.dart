// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i10;
import 'package:firebase_auth/firebase_auth.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../../src/features/authentification/application/usecases/login_user.dart'
    as _i33;
import '../../src/features/authentification/application/usecases/logout_user.dart'
    as _i32;
import '../../src/features/authentification/application/usecases/register_user.dart'
    as _i34;
import '../../src/features/authentification/application/usecases/send_verification_email.dart'
    as _i35;
import '../../src/features/authentification/data/repositories/auth_repositories_impl.dart'
    as _i26;
import '../../src/features/authentification/data/sources/network/firebase_auth_datasource.dart'
    as _i18;
import '../../src/features/authentification/data/sources/network/firestore_auth_datasource.dart'
    as _i15;
import '../../src/features/authentification/domain/repositories/auth_repository.dart'
    as _i25;
import '../../src/features/task/application/controllers/task_controller.dart'
    as _i11;
import '../../src/features/task/application/usecases/local/add_task_local.dart'
    as _i20;
import '../../src/features/task/application/usecases/local/check_task_title_local.dart'
    as _i21;
import '../../src/features/task/application/usecases/local/delete_all_tasks_local.dart'
    as _i22;
import '../../src/features/task/application/usecases/local/get_tasks_local.dart'
    as _i23;
import '../../src/features/task/application/usecases/local/get_total_tasks_local.dart'
    as _i24;
import '../../src/features/task/application/usecases/remote/add_task.dart'
    as _i27;
import '../../src/features/task/application/usecases/remote/check_task_title.dart'
    as _i28;
import '../../src/features/task/application/usecases/remote/delete_task.dart'
    as _i29;
import '../../src/features/task/application/usecases/remote/get_task_by_id.dart'
    as _i19;
import '../../src/features/task/application/usecases/remote/get_tasks.dart'
    as _i30;
import '../../src/features/task/application/usecases/remote/update_tasks.dart'
    as _i31;
import '../../src/features/task/data/repositories/task_repository_impl.dart'
    as _i17;
import '../../src/features/task/data/sources/local/database_manager.dart'
    as _i7;
import '../../src/features/task/data/sources/local/task_local_data_source.dart'
    as _i12;
import '../../src/features/task/data/sources/network/task_remote_data_source.dart'
    as _i14;
import '../../src/features/task/domain/repositories/task_repository.dart'
    as _i16;
import '../../src/features/task/presentation/bloc/task_bloc/task_bloc.dart'
    as _i36;
import '../bloc/connectivity_checker_bloc.dart' as _i8;
import '../services/bottom_sheet_service.dart' as _i6;
import '../services/easy_loading/easy_loading_service.dart' as _i5;
import '../services/firebase_service.dart' as _i4;
import '../services/shared_preferences_service.dart' as _i13;
import 'injectable.dart' as _i37;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i4.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    await gh.factoryAsync<_i5.EasyLoadingService>(
      () => appModule.eazyLoadingService,
      preResolve: true,
    );
    await gh.factoryAsync<_i6.BottomSheetService>(
      () => appModule.bottomSheetServ,
      preResolve: true,
    );
    gh.factory<_i7.DatabaseManager>(() => _i7.DatabaseManager());
    gh.lazySingleton<_i8.ConnectivityCheckerBloc>(
        () => _i8.ConnectivityCheckerBloc());
    gh.lazySingleton<_i9.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i10.FirebaseFirestore>(() => appModule.firebaseFirestore);
    gh.lazySingleton<_i11.TaskController>(() => _i11.TaskController());
    gh.lazySingleton<_i12.TaskLocalDataSource>(
        () => _i12.TaskLocalDataSource(gh<_i7.DatabaseManager>()));
    gh.lazySingleton<_i13.SharedPreferencesService>(() =>
        _i13.SharedPreferencesService(local: gh<_i3.SharedPreferences>()));
    gh.factory<_i14.TaskRemoteDataSource>(
        () => _i14.TaskRemoteDataSource(db: gh<_i10.FirebaseFirestore>()));
    gh.factory<_i15.FirestoreAuthDatasource>(
        () => _i15.FirestoreAuthDatasource(gh<_i10.FirebaseFirestore>()));
    gh.lazySingleton<_i16.TaskRepository>(() => _i17.TaskRepositoryImpl(
          remoteDataSource: gh<_i14.TaskRemoteDataSource>(),
          localDataSource: gh<_i12.TaskLocalDataSource>(),
        ));
    gh.factory<_i18.FirebaseAuthDatasource>(() => _i18.FirebaseAuthDatasource(
          gh<_i9.FirebaseAuth>(),
          gh<_i15.FirestoreAuthDatasource>(),
        ));
    gh.lazySingleton<_i19.GetTaskById>(
        () => _i19.GetTaskById(repo: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i20.AddTaskLocal>(
        () => _i20.AddTaskLocal(gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i21.CheckTaskTitleLocal>(
        () => _i21.CheckTaskTitleLocal(gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i22.DeleteAllTasksLocal>(
        () => _i22.DeleteAllTasksLocal(gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i23.GetTasksLocal>(
        () => _i23.GetTasksLocal(gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i24.GetTotalTasksLocal>(
        () => _i24.GetTotalTasksLocal(gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i25.AuthRepository>(
        () => _i26.AuthRepositoriesImpl(gh<_i18.FirebaseAuthDatasource>()));
    gh.lazySingleton<_i27.AddTask>(
        () => _i27.AddTask(repository: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i28.CheckTaskTitle>(
        () => _i28.CheckTaskTitle(repository: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i29.DeleteTask>(
        () => _i29.DeleteTask(repository: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i30.GetTasks>(
        () => _i30.GetTasks(repository: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i31.UpdateTasks>(
        () => _i31.UpdateTasks(repository: gh<_i16.TaskRepository>()));
    gh.lazySingleton<_i32.LogoutUser>(
        () => _i32.LogoutUser(rep: gh<_i25.AuthRepository>()));
    gh.lazySingleton<_i33.LoginUser>(
        () => _i33.LoginUser(gh<_i25.AuthRepository>()));
    gh.lazySingleton<_i34.RegisterUser>(
        () => _i34.RegisterUser(gh<_i25.AuthRepository>()));
    gh.lazySingleton<_i35.SendVerificationEmail>(
        () => _i35.SendVerificationEmail(gh<_i25.AuthRepository>()));
    gh.lazySingleton<_i36.TaskBloc>(() => _i36.TaskBloc(
          addTask: gh<_i27.AddTask>(),
          addTaskLocal: gh<_i20.AddTaskLocal>(),
          deleteTask: gh<_i29.DeleteTask>(),
          getTasks: gh<_i30.GetTasks>(),
          updateTask: gh<_i31.UpdateTasks>(),
          checkTaskTitle: gh<_i28.CheckTaskTitle>(),
          checkTaskTitleLocal: gh<_i21.CheckTaskTitleLocal>(),
          getTotalTasksLocal: gh<_i24.GetTotalTasksLocal>(),
          getTasksLocal: gh<_i23.GetTasksLocal>(),
          deleteAllTasksLocal: gh<_i22.DeleteAllTasksLocal>(),
          local: gh<_i13.SharedPreferencesService>(),
          connCheckerBloc: gh<_i8.ConnectivityCheckerBloc>(),
          getTaskById: gh<_i19.GetTaskById>(),
        ));
    return this;
  }
}

class _$AppModule extends _i37.AppModule {}
