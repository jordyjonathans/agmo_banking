import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';
import 'package:agmotest_banking/features/auth/domain/repositories/authRepository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResponse> execute(String email, String password) {
    return repository.login(email, password);
  }
}
