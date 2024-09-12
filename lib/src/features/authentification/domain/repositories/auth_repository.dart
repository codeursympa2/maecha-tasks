import 'package:firebase_auth/firebase_auth.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';

abstract class AuthRepository{
  Future<User?> login(UserModel user);
  Future<UserModel?> register(UserModel user);
  Future<void> sendVerificationEmail();
  Future<void> logout();

}