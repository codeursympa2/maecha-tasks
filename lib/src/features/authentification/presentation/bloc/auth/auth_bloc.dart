import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maecha_tasks/global/injectable/injectable.dart';
import 'package:maecha_tasks/global/services/shared_preferences_service.dart';
import 'package:maecha_tasks/src/constants/strings/query_responses_strings.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/login_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/logout_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/register_user.dart';
import 'package:maecha_tasks/src/features/authentification/application/usecases/send_verification_email.dart';
import 'package:maecha_tasks/src/features/authentification/data/sources/network/firestore_auth_datasource.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final LoginUser loginUser;
  final RegisterUser registerUser;
  final SendVerificationEmail sendVerificationEmail;
  final SharedPreferencesService sharedPreferencesService;
  final FirestoreAuthDatasource firestoreAuthDatasource;
  final LogoutUser logoutUser;


  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.sendVerificationEmail,
    required this.sharedPreferencesService,
    required this.firestoreAuthDatasource,
    required this.logoutUser
  }) : super(const AuthInitialState()) {
    on<LoginUserEvent>((event, emit) async{
      emit(const AuthLoadingState());
      try{
        // Vérifiez s'il y a déjà une session active
        // final currentUser = getIt<FirebaseAuth>().currentUser;
        // if (currentUser != null) {
        //   emit(const AuthFailureState(message: 'Une session est déjà active. Veuillez vous déconnecter avant de vous reconnecter.'));
        //   return;
        // }

        final user = await loginUser.call(event.userModel);

        if (user != null && user.emailVerified) {
          emit(const AuthLoginSuccessState(message: loginSuccessfully));
          //on sauvegarde l'email s'il l'user check sinon on le supprime
          event.isChecked ?
          sharedPreferencesService.setUserEmailLocal(user: UserModel(email: user.email!))
              :
          sharedPreferencesService.clearData(sharedPreferencesService.emailKey);

          //current user info
          UserModel currentUser=await firestoreAuthDatasource.getCurrentUser(user.uid);
          //On sauvegarde les informations de l'utilisateur
          sharedPreferencesService.setUser(user: UserModel(
              email: currentUser.email,
              uid: user.uid,
              lastName: currentUser.lastName,
              firstName: currentUser.firstName
          ));
        } else {
          emit(const AuthFailureState(message: emailNotVerified));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          emit(const AuthFailureState(message: wrongCredentials));
        }else{
          emit(const AuthFailureState(message: unknownError));
        }
      }
    });

  on<RegisterUserEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try{
        await registerUser.call(event.userModel);
        emit(const AuthRegisterSuccessState(message: accountCreated));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(const AuthFailureState(message: "The password provided is too weak."));
        } else if (e.code == 'email-already-in-use') {
          emit(const AuthFailureState(message: emailExist));
        }
      } catch (e) {
        emit(const AuthFailureState(message: failedCreatedAccount));
      }
    });

    on<CheckConnectUserEvent>((event,emit) async{
      UserModel? userLocal=sharedPreferencesService.getUser();
      const int seconds=2;
      //
      final currentUser = getIt<FirebaseAuth>().currentUser;

      if(userLocal != null && currentUser != null){
        await Future.delayed(const Duration(seconds:seconds),() => emit(const AuthAuthenticatedState()),);
      }else{
        await Future.delayed(const Duration(seconds:seconds),() => emit(const AuthUnauthenticatedState()),);
      }
    });

    on<LogoutUserEvent>((event,emit)async{
      try{
        sharedPreferencesService.clearData(sharedPreferencesService.userKey);
        await logoutUser.call().whenComplete(() => emit(const UserLogoutState(message: "Vous êtes déconnecté.")));
      }catch(e){
        emit(const AuthFailureState(message: failedLogoutUser));
      }
    });
  }



}
