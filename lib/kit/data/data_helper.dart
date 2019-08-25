import 'dart:html';
import 'dart:convert';
import 'package:swiftclub/kit/macro/macro.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

final _localStorage = window.localStorage;

class Storage {
  int getInt(String key) {
    if (_localStorage.containsKey(key)) {
      return int.tryParse(_localStorage[key]);
    }
    return null;
  }

  void setInt(String key, int value) {
    _localStorage[key] = '$value';
  }

  String getString(String key) {
    if (_localStorage.containsKey(key)) {
      return _localStorage[key];
    }
    return '';
  }

  void setString(String key, String value) {
    _localStorage[key] = '$value';
  }

  bool getBool(String key) {
    if (_localStorage.containsKey(key)) {
      return _localStorage[key] == 'true';
    }
    return false;
  }

  void setBool(String key, bool value) {
    _localStorage[key] = '$value';
  }

  Map<String, dynamic> getJSON(String key) {
    return json.decode(this.getString(key));
  }

  void setJSON(String key, Map<String, dynamic> value) {
    this.setString(key, json.encode(value));
  }

  bool has(String key) {
    return _localStorage[key] != null;
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
    return SafeValue.toMap(_storage.getJSON(Macro.KEY_storage_user));
  }

  static void setToken(Map map) {
    _storage.setJSON(Macro.KEY_storage_token, map);
  }

  static Map _token() {
    return SafeValue.toMap(_storage.getJSON(Macro.KEY_storage_token));
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
