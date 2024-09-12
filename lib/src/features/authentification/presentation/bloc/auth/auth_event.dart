part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthInitialEvent extends AuthEvent{
  const AuthInitialEvent();
}

class LoginUserEvent extends AuthEvent{
  final UserModel userModel;
  final bool isChecked;
  const LoginUserEvent({required this.userModel,required this.isChecked});

  @override
  List<Object?> get props => [userModel,isChecked];
}

class RegisterUserEvent extends AuthEvent{
  final UserModel userModel;

  const RegisterUserEvent({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}

final class CheckConnectUserEvent extends AuthEvent{
  const CheckConnectUserEvent();
}
final class LogoutUserEvent extends AuthEvent{
  const LogoutUserEvent();
}

