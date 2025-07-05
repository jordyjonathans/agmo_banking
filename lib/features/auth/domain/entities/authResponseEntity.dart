import 'package:agmotest_banking/features/auth/domain/entities/userEntity.dart';
import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final User user;

  const AuthResponse({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props {
    return [user];
  }
}
