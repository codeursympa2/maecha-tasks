part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {
  const AuthInitialState();
}

final class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthSuccessState extends AuthState {
  final String message;
  const AuthSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthAuthenticatedState extends AuthState{
  const AuthAuthenticatedState();
}

final class AuthUnauthenticatedState extends AuthState{
  const AuthUnauthenticatedState();
}