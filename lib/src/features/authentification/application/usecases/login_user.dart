import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/repositories/auth_repository.dart';

@lazySingleton
class LoginUser{
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User?> call(UserModel user) async{
    return await repository.login(user);
  }
}