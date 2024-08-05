import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/data/sources/network/firestore_datasource.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';

@injectable
class FirebaseAuthDatasource{
  final FirebaseAuth firebaseAuth;
  final FirestoreDatasource db;

  FirebaseAuthDatasource(this.firebaseAuth,this.db);

  //Pour la connexion
  Future<User?> login(UserModel user) async{
    final userCredential= await firebaseAuth.signInWithEmailAndPassword(email: user.email, password: user.password!);
    return userCredential.user;
  }

  //Pour l'inscription
  Future<User?> register(UserModel user) async{
    final userCredential=await firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: user.password!,);

    //On le sauvegarde dans firestore
    await db.saverUser(
        UserModel.userToCloudFirestore(userCredential.user!.uid,user.firstName,user.lastName,userCredential.user!.email!)
    );

    //Envoie de l'email
    await userCredential.user?.sendEmailVerification();
    //On retourne l'utilisateur
    return userCredential.user;
  }

  //envoi de l'email
  Future<void> sendVerificationEmail() async{
    final user =firebaseAuth.currentUser;  //recupération de l'utilisateur courant
    //Si nous l'avons et son email n'est pas verifié
    if(user != null && !user.emailVerified){
      await firebaseAuth.setLanguageCode("fr");
      //Nous renvoyons l'email
      await user.sendEmailVerification();
    }
  }


}