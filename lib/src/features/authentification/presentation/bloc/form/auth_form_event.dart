part of 'auth_form_bloc.dart';

sealed class AuthFormEvent extends Equatable {
  const AuthFormEvent();
}

final class AuthInitialFormEvent extends AuthFormEvent{
  const AuthInitialFormEvent();

  @override
  List<Object?> get props => [];
}

class AuthValidateFormEvent extends AuthFormEvent{
  final AuthFormFieldsModel fields;
  final TypeFormEnum typeFormEnum;
  const AuthValidateFormEvent({required this.fields,required this.typeFormEnum});

  @override
  List<Object?> get props => [fields,typeFormEnum];
}