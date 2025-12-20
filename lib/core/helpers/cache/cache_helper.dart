import 'dart:convert';

import 'package:mega_plus/core/helpers/cache/cache_keys.dart';
import 'package:mega_plus/core/helpers/cache/user_cache_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences!.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  static Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  static Future<bool> logout() async {
    return await _preferences!.clear();
  }

  static Future login(UserCacheModel user) async {
    user.expireDateTime = DateTime.now().add(
      Duration(seconds: user.expiresIn!),
    );

    await _preferences!.setString(CacheKeys.token.name, user.accessToken!);
    await _preferences!.setString(
      CacheKeys.login.name,
      jsonEncode(user.toJson()),
    );
  }

  //? 1 -> need login
  //? 2 -> need refresh token
  //? 3 -> true
  static int checkLogin() {
    var login = _preferences!.getString(CacheKeys.login.name);
    var token = _preferences!.getString(CacheKeys.token.name);
    //? Check 1
    if (login == null && token == null) {
      return 1;
    }

    //? Check 2
    var loginData = UserCacheModel.fromJson(jsonDecode(login!));

    if (loginData.expireDateTime!.isBefore(DateTime.now())) {
      return 2;
    }
    return 3;
  }

  static UserCacheModel? getUserData() {
    var login = _preferences!.getString(CacheKeys.login.name);
    if (login == null) return null;

    var loginData = UserCacheModel.fromJson(jsonDecode(login));

    return loginData;
  }

  static Future<void> refreshToken(String newToken, int newExpiresIn) async {
    var login = _preferences!.getString(CacheKeys.login.name);
    var loginData = UserCacheModel.fromJson(jsonDecode(login!));

    loginData.accessToken = newToken;
    loginData.expiresIn = newExpiresIn;
    loginData.expireDateTime = DateTime.now().add(
      Duration(seconds: loginData.expiresIn!),
    );

    await _preferences!.setString(CacheKeys.token.name, loginData.accessToken!);
    await _preferences!.setString(
      CacheKeys.login.name,
      jsonEncode(loginData.toJson()),
    );
  }
}
