import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';

@injectable
class FirestoreDatasource{
  final FirebaseFirestore db;
  final String  collectionPath="users";

  FirestoreDatasource(this.db);

  Future<void> saverUser(UserModel user)async{

    await db.collection(collectionPath).doc(user.uid).set(user.toJson()).whenComplete(() =>
        print("User saved to Firestore")
    ).catchError((error) =>
        print("Failed to save user: $error")
    );
  }


}