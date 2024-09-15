import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/auth_form_fields_model.dart';
import 'package:maecha_tasks/src/features/authentification/domain/value_objects/type_form_enum.dart';
part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {

  AuthFormBloc() : super(const AuthFormInitialState()) {

    on<AuthInitialFormEvent>((event, emit) async{
      emit(const AuthFormInitialState());
    });

    on<AuthValidateFormEvent>((event,emit) async{
      AuthFormFieldsModel field=event.fields;

      late String stateLastNameMessage;
      late String stateFirstNameMessage;
      late String stateTelMessage;
      late String stateEmailMessage;
      late String statePasswordMessage;
      late String statePasswordConfMessage;

      bool formInvalid=false;

      //Login form
      final RegExp emailRegex = RegExp(
        r'^[^@]+@[^@]+\.[^@]+$',
      );
      if(field.emailField == "" || field.emailField!.isEmpty){
        formInvalid=true;
        stateEmailMessage=emailErrorMessage;
      }else if (!emailRegex.hasMatch(field.emailField!)) {
        formInvalid=true;
        stateEmailMessage=emailRegexMessage;
      }else{
          stateEmailMessage="";
      }


      if(field.passwordField == ""){
        formInvalid=true;
        statePasswordMessage=passwordErrorMessage;
      }else{
        //Regex pour le mot de passe
        final RegExp uppercaseRegex = RegExp(r'(?=.*[A-Z])');
        final RegExp digitRegex = RegExp(r'(?=.*\d)');
        final RegExp specialCharRegex = RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])');
        final RegExp minLengthRegex = RegExp(r'.{8,}');

        //Si c'est register
       if(event.typeFormEnum == TypeFormEnum.register){
         if (!uppercaseRegex.hasMatch(field.passwordField!)) {
           formInvalid=true;
           statePasswordMessage= regexUppercaseString;
         }
         else if (!digitRegex.hasMatch(field.passwordField!)) {
           formInvalid=true;
           statePasswordMessage= regexDigitString;
         }
         else if (!specialCharRegex.hasMatch(field.passwordField!)) {
           formInvalid=true;
           statePasswordMessage= regexSpecialCharString;
         }
         else if (!minLengthRegex.hasMatch(field.passwordField!)) {
           formInvalid=true;
           statePasswordMessage= regexMinLengthString;
         }
         else{
           statePasswordMessage="";
         }
       }else{
         //Sinon login
         statePasswordMessage="";
       }
      }

      //Pour le champs register
      if(event.typeFormEnum == TypeFormEnum.register ){

        if(field.firstNameField == ""){
          formInvalid=true;
          stateFirstNameMessage=firstNameErrorMessage;
        }else{
          stateFirstNameMessage="";
        }

        if(field.lastNameField == ""){
          formInvalid=true;
          stateLastNameMessage=lastNameErrorMessage;
        }else{
          stateLastNameMessage="";
        }

        if(field.telField == ""){
          formInvalid=true;
          stateTelMessage=telErrorMessage;
        }else{
          if(field.telField!.length != 9){
            formInvalid=true;
            stateTelMessage=telErrorMessage;
          }else{
            stateTelMessage="";
          }
        }

        if(field.passwordConfField == ""){
          formInvalid=true;
          statePasswordConfMessage=passwordConfErrorMessage;
        }else{
          if(field.passwordField != field.passwordConfField){
            formInvalid=true;
            statePasswordConfMessage="Les deux mots de passe ne correspondent pas";
          }else{
            statePasswordConfMessage="";
          }

        }
      }

      if(formInvalid){
        if(event.typeFormEnum == TypeFormEnum.register ){
          emit(AuthFormInvalidState(
              errors: AuthFormFieldsModel(
                  firstNameField: stateFirstNameMessage,
                  lastNameField: stateLastNameMessage,
                  emailField: stateEmailMessage,
                  passwordField: statePasswordMessage,
                  passwordConfField: statePasswordConfMessage,
                  telField: stateTelMessage
              )
          ));
        }else{
          emit(AuthFormInvalidState(
              errors: AuthFormFieldsModel(
                  emailField: stateEmailMessage,
                  passwordField: statePasswordMessage,
              )
          ));
        }

      }else{
        emit(const AuthFormValidState());
      }
    });
  }
}
