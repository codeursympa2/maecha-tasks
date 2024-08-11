// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i9;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../../src/features/authentification/application/usecases/login_user.dart'
    as _i26;
import '../../src/features/authentification/application/usecases/register_user.dart'
    as _i27;
import '../../src/features/authentification/application/usecases/send_verification_email.dart'
    as _i28;
import '../../src/features/authentification/data/repositories/auth_repositories_impl.dart'
    as _i20;
import '../../src/features/authentification/data/sources/network/firebase_auth_datasource.dart'
    as _i16;
import '../../src/features/authentification/data/sources/network/firestore_auth_datasource.dart'
    as _i13;
import '../../src/features/authentification/domain/repositories/auth_repository.dart'
    as _i19;
import '../../src/features/task/application/controllers/task_controller.dart'
    as _i10;
import '../../src/features/task/application/usecases/local/add_task_local.dart'
    as _i17;
import '../../src/features/task/application/usecases/local/check_task_title_local.dart'
    as _i18;
import '../../src/features/task/application/usecases/remote/add_task.dart'
    as _i21;
import '../../src/features/task/application/usecases/remote/check_task_title.dart'
    as _i22;
import '../../src/features/task/application/usecases/remote/delete_task.dart'
    as _i23;
import '../../src/features/task/application/usecases/remote/get_tasks.dart'
    as _i24;
import '../../src/features/task/application/usecases/remote/update_tasks.dart'
    as _i25;
import '../../src/features/task/data/repositories/task_repository_impl.dart'
    as _i15;
import '../../src/features/task/data/sources/local/task_local_data_source.dart'
    as _i7;
import '../../src/features/task/data/sources/network/task_remote_data_source.dart'
    as _i12;
import '../../src/features/task/domain/repositories/task_repository.dart'
    as _i14;
import '../services/bottom_sheet_service.dart' as _i6;
import '../services/easy_loading/easy_loading_service.dart' as _i5;
import '../services/firebase_service.dart' as _i4;
import '../services/shared_preferences_service.dart' as _i11;
import 'injectable.dart' as _i29;

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
    gh.factory<_i7.TaskLocalDataSource>(() => _i7.TaskLocalDataSource());
    gh.lazySingleton<_i8.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i9.FirebaseFirestore>(() => appModule.firebaseFirestore);
    gh.lazySingleton<_i10.TaskController>(() => _i10.TaskController());
    gh.lazySingleton<_i11.SharedPreferencesService>(() =>
        _i11.SharedPreferencesService(local: gh<_i3.SharedPreferences>()));
    gh.factory<_i12.TaskRemoteDataSource>(
        () => _i12.TaskRemoteDataSource(db: gh<_i9.FirebaseFirestore>()));
    gh.factory<_i13.FirestoreAuthDatasource>(
        () => _i13.FirestoreAuthDatasource(gh<_i9.FirebaseFirestore>()));
    gh.lazySingleton<_i14.TaskRepository>(() => _i15.TaskRepositoryImpl(
          remoteDataSource: gh<_i12.TaskRemoteDataSource>(),
          localDataSource: gh<_i7.TaskLocalDataSource>(),
        ));
    gh.factory<_i16.FirebaseAuthDatasource>(() => _i16.FirebaseAuthDatasource(
          gh<_i8.FirebaseAuth>(),
          gh<_i13.FirestoreAuthDatasource>(),
        ));
    gh.lazySingleton<_i17.AddTaskLocal>(
        () => _i17.AddTaskLocal(gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i18.CheckTaskTitleLocal>(
        () => _i18.CheckTaskTitleLocal(gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i19.AuthRepository>(
        () => _i20.AuthRepositoriesImpl(gh<_i16.FirebaseAuthDatasource>()));
    gh.lazySingleton<_i21.AddTask>(
        () => _i21.AddTask(repository: gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i22.CheckTaskTitle>(
        () => _i22.CheckTaskTitle(repository: gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i23.DeleteTask>(
        () => _i23.DeleteTask(repository: gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i24.GetTasks>(
        () => _i24.GetTasks(repository: gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i25.UpdateTasks>(
        () => _i25.UpdateTasks(repository: gh<_i14.TaskRepository>()));
    gh.lazySingleton<_i26.LoginUser>(
        () => _i26.LoginUser(gh<_i19.AuthRepository>()));
    gh.lazySingleton<_i27.RegisterUser>(
        () => _i27.RegisterUser(gh<_i19.AuthRepository>()));
    gh.lazySingleton<_i28.SendVerificationEmail>(
        () => _i28.SendVerificationEmail(gh<_i19.AuthRepository>()));
    return this;
  }
}

class _$AppModule extends _i29.AppModule {}
