import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/data/sources/network/firebase_auth_datasource.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoriesImpl implements AuthRepository {

  final FirebaseAuthDatasource dataSource;

  AuthRepositoriesImpl(this.dataSource);



  @override
  Future<User?> login(UserModel user) async{
    final firebaseUser=await dataSource.login(user);
    return firebaseUser;
  }

  @override
  Future<UserModel?> register(UserModel user) async {
    final firebaseUser=await dataSource.register(user);
    return firebaseUser != null ? UserModel(uid: firebaseUser.uid,email: firebaseUser.email!) : null;
  }

  @override
  Future<void> sendVerificationEmail() async{
    return await dataSource.sendVerificationEmail();
  }

}