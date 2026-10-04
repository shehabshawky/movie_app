import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'cached_user';
  final SharedPreferences? sharedPreferences;

  AuthLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
