import 'package:agmotest_banking/features/auth/domain/entities/userEntity.dart';

class UserModel extends User {
  UserModel({required String id, required String email, String? name})
    : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};

  User toEntity() => User(id: id, email: email, name: name);
}
