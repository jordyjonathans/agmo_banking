import 'package:agmotest_banking/features/auth/data/models/authResponseModel.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
}
