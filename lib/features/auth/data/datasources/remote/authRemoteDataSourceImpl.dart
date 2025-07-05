import 'package:agmotest_banking/features/auth/data/datasources/remote/authRemoteDataSource.dart';
import 'package:agmotest_banking/features/auth/data/models/authResponseModel.dart';
import 'package:agmotest_banking/features/auth/data/models/userModel.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'jordy.sjarif@test.com' && password == 'TestPass123') {
      final user = UserModel(id: 'test001', email: email, name: 'Jordy Sjarif');
      return AuthResponseModel(user: user);
    } else {
      throw ('Invalid email or password.');
    }
  }
}
