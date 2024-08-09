import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPreferencesService{
  final SharedPreferences local;
  final  String userKey = 'user';
  final  String emailKey = 'email';

  const SharedPreferencesService({required this.local});

  Future<void> setUserEmailLocal({required UserModel user})async{
    await local.setString(emailKey, user.email!);
  }

  String? getUserEmailLocal(){
    final email=local.getString(emailKey);

    if(email != null){
      return email;
    }
    return null;
  }

  Future<void> setUser({required UserModel user})async{
    final userJson = jsonEncode(user.toJson());
    await local.setString(userKey, userJson);
  }

  UserModel? getUser(){
   final userJson=local.getString(userKey);

   if(userJson != null){
     final Map<String,dynamic> userMap=jsonDecode(userJson);
     return UserModel.fromJson(userMap);
   }

   return null;
  }

  Future<void> clearData(String key) async{
    local.remove(key);
  }
}