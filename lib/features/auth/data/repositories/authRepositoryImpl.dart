import 'package:agmotest_banking/features/auth/data/datasources/local/authLocalDataSource.dart';
import 'package:agmotest_banking/features/auth/data/datasources/remote/authRemoteDataSource.dart';
import 'package:agmotest_banking/features/auth/domain/entities/authResponseEntity.dart';
import 'package:agmotest_banking/features/auth/domain/entities/userEntity.dart';
import 'package:agmotest_banking/features/auth/domain/repositories/authRepository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User?> getCachedUser() {
    // TODO: implement getCachedUser
    return localDataSource.getCacheUser();
  }

  @override
  Future<AuthResponse> login(String email, String password) async {
    // TODO: implement login
    try {
      final authResponseModel = await remoteDataSource.login(email, password);
      await localDataSource.setChaceUser(authResponseModel.user);
      return authResponseModel.toEntity();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> logout() async {
    // TODO: implement logout
    await localDataSource.clearCacheUser();
  }
}
