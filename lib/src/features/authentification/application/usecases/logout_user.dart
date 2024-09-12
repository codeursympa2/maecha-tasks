import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/repositories/auth_repository.dart';

@lazySingleton
class LogoutUser{
  final AuthRepository rep;

  LogoutUser({required this.rep});

  Future<void> call()async{
    await rep.logout();
  }
}