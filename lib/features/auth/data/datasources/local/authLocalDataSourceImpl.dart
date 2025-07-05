import 'dart:convert';

import 'package:agmotest_banking/features/auth/data/datasources/local/authLocalDataSource.dart';
import 'package:agmotest_banking/features/auth/data/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_KEY = 'USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> clearCacheUser() {
    // TODO: implement clearCacheUser
    return sharedPreferences.remove(USER_KEY);
  }

  @override
  Future<UserModel?> getCacheUser() {
    // TODO: implement getCacheUser
    final userJsonString = sharedPreferences.getString(USER_KEY);
    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final userMap = json.decode(userJsonString) as Map<String, dynamic>;
        return Future.value(UserModel.fromJson(userMap));
      } catch (e) {
        return Future.value(null);
      }
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> setChaceUser(UserModel user) {
    // TODO: implement setChaceUser
    return sharedPreferences.setString(USER_KEY, json.encode(user.toJson()));
  }
}
