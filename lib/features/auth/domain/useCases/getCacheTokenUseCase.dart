import 'package:agmotest_banking/features/auth/domain/entities/userEntity.dart';
import 'package:agmotest_banking/features/auth/domain/repositories/authRepository.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<User?> call() {
    return repository.getCachedUser();
  }
}
