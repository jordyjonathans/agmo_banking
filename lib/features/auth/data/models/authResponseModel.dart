import 'package:agmotest_banking/features/auth/data/models/userModel.dart';
import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';

class AuthResponseModel {
  final UserModel user;

  AuthResponseModel({required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(user: UserModel.fromJson(json['user']));

  AuthResponse toEntity() => AuthResponse(user: user.toEntity());
}
