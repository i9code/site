import 'dart:convert';
import 'package:swiftclub/kit/macro/macro.dart';
import 'local_storage.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class Storage {
  /// 类管理
  int getInt(String key) {
    if (has(key)) {
      return int.tryParse(localStorage.getItem(key));
    }
    return null;
  }

  void setInt(String key, int value) {
    localStorage.setItem(key, '$value');
  }

  String getString(String key) {
    if (has(key)) {
      return localStorage.getItem(key);
    }
    return '';
  }

  void setString(String key, String value) {
    localStorage.setItem(key, '$value');
  }

  bool getBool(String key) {
    if (has(key)) {
      return localStorage.getItem(key) == 'true';
    }
    return false;
  }

  void setBool(String key, bool value) {
    localStorage.setItem(key, '$value');
  }

  Map<String, dynamic> getJSON(String key) {
    return json.decode(this.getString(key));
  }

  void setJSON(String key, Map<String, dynamic> value) {
    this.setString(key, json.encode(value));
  }

  bool has(String key) {
    return localStorage.getItem(key) != null;
  }
}

class DataHelper {
  static Storage _storage;

  static void setup() {
    _storage = Storage();
  }

  static void setUser(Map map) {
    _storage.setJSON(Macro.KEY_storage_user, map);
  }

  static String userId() {
    return SafeValue.toStr(user()['id']);
  }

  static Map user() {
    if (_storage.has(Macro.KEY_storage_user)) {
      return SafeValue.toMap(_storage.getJSON(Macro.KEY_storage_user));
    } else {
      return {};
    }
  }

  static void setToken(Map map) {
    _storage.setJSON(Macro.KEY_storage_token, map);
  }

  static Map _token() {
    if (_storage.has(Macro.KEY_storage_token)) {
      return SafeValue.toMap(_storage.getJSON(Macro.KEY_storage_token));
    } else {
      return {};
    }
  }

  static String accessToken() {
    return SafeValue.toStr(_token()[Macro.KEY_accessToken]);
  }

  static String refreshToken() {
    return SafeValue.toStr(_token()[Macro.Key_refreshToken]);
  }

  static bool userIsLogin() {
    Map userMap = user();
    String accesstoken = accessToken();
    return (userMap != null && userMap.isNotEmpty) &&
        (accesstoken != null && accesstoken.isNotEmpty);
  }

  static void clearLoginInfo() {
    Map empty;
    setToken(empty);
    setUser(empty);
  }
}
