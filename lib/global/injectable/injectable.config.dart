// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:firebase_auth/firebase_auth.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../../src/features/authentification/application/usecases/login_user.dart'
    as _i14;
import '../../src/features/authentification/application/usecases/register_user.dart'
    as _i15;
import '../../src/features/authentification/application/usecases/send_verification_email.dart'
    as _i16;
import '../../src/features/authentification/data/repositories/auth_repositories_impl.dart'
    as _i13;
import '../../src/features/authentification/data/sources/network/firebase_auth_datasource.dart'
    as _i11;
import '../../src/features/authentification/data/sources/network/firestore_datasource.dart'
    as _i10;
import '../../src/features/authentification/domain/repositories/auth_repository.dart'
    as _i12;
import '../services/bottom_sheet_service.dart' as _i6;
import '../services/easy_loading/easy_loading_service.dart' as _i5;
import '../services/firebase_service.dart' as _i4;
import '../services/shared_preferences_service.dart' as _i9;
import 'injectable.dart' as _i17;

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
    gh.lazySingleton<_i7.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i8.FirebaseFirestore>(() => appModule.firebaseFirestore);
    gh.lazySingleton<_i9.SharedPreferencesService>(
        () => _i9.SharedPreferencesService(local: gh<_i3.SharedPreferences>()));
    gh.factory<_i10.FirestoreDatasource>(
        () => _i10.FirestoreDatasource(gh<_i8.FirebaseFirestore>()));
    gh.factory<_i11.FirebaseAuthDatasource>(() => _i11.FirebaseAuthDatasource(
          gh<_i7.FirebaseAuth>(),
          gh<_i10.FirestoreDatasource>(),
        ));
    gh.lazySingleton<_i12.AuthRepository>(
        () => _i13.AuthRepositoriesImpl(gh<_i11.FirebaseAuthDatasource>()));
    gh.lazySingleton<_i14.LoginUser>(
        () => _i14.LoginUser(gh<_i12.AuthRepository>()));
    gh.lazySingleton<_i15.RegisterUser>(
        () => _i15.RegisterUser(gh<_i12.AuthRepository>()));
    gh.lazySingleton<_i16.SendVerificationEmail>(
        () => _i16.SendVerificationEmail(gh<_i12.AuthRepository>()));
    return this;
  }
}

class _$AppModule extends _i17.AppModule {}
