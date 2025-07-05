import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';
import 'package:agmotest_banking/features/auth/domain/entities/userEntity.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
  Future<User?> getCachedUser();
}
