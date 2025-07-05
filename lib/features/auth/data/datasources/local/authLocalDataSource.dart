import 'package:agmotest_banking/features/auth/data/models/userModel.dart';

abstract class AuthLocalDataSource {
  Future<void> setChaceUser(UserModel token);
  Future<UserModel?> getCacheUser();
  Future<void> clearCacheUser();
}
