import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/repositories/auth_repository.dart';


@lazySingleton
class SendVerificationEmail{
  final AuthRepository repository;

  SendVerificationEmail(this.repository);

  Future<void> call(UserModel user) async{
    return await repository.sendVerificationEmail();
  }
}