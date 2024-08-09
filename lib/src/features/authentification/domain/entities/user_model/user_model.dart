import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable{
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;

  const UserModel({
    this.uid,
    this.firstName,
    this.lastName,
    required this.email,
    this.password
  });

  const UserModel.toLocal({
    required this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.password
  });



  const UserModel.userToCloudFirestore(this.uid, this.firstName, this.lastName,this.email,{this.password = ""});

  // Méthode générée pour la désérialisation
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // Méthode générée pour la sérialisation
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [uid,firstName,lastName,email,password];

}