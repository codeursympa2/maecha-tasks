import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';

@injectable
class FirestoreAuthDatasource{
  final FirebaseFirestore db;
  final String  collectionPath="users";

  FirestoreAuthDatasource(this.db);

  Future<void> saverUser(UserModel user)async{
    await db.collection(collectionPath).doc(user.uid).set(user.toJson()).whenComplete(() =>
        print("User saved to Firestore")
    ).catchError((error) =>
        print("Failed to save user: $error")
    );
  }

  Future<UserModel> getCurrentUser(String uid)async{
    final userJson=await db.collection(collectionPath).doc(uid).get();
    return UserModel.fromJson(userJson.data()!);
  }

}