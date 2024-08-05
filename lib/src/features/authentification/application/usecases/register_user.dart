import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/repositories/auth_repository.dart';

@lazySingleton
class RegisterUser{
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserModel?> call(UserModel user) async{
    return await repository.register(user);
  }
}