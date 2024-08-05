part of 'auth_form_bloc.dart';

sealed class AuthFormState extends Equatable {
  const AuthFormState();

  @override
  List<Object?> get props => [];
}

final class AuthFormInitialState extends AuthFormState {
    const AuthFormInitialState();
}

final class AuthFormValidState extends AuthFormState {
    const AuthFormValidState();
}

class AuthFormInvalidState extends AuthFormState {
  final AuthFormFieldsModel errors;
  const AuthFormInvalidState({required this.errors});

  @override
  List<Object?> get props => [errors];
}




