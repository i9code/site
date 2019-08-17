import 'dart:html';
import 'dart:convert';

final localStorage = window.localStorage;

class Storage {
  int getInt(String key) {
    if (localStorage.containsKey(key)) {
      return int.tryParse(localStorage[key]);
    }
    return null;
  }

  void setInt(String key, int value) {
    localStorage[key] = '$value';
  }

  String getString(String key) {
    if (localStorage.containsKey(key)) {
      return localStorage[key];
    }
    return null;
  }

  void setString(String key, String value) {
    localStorage[key] = '$value';
  }

  bool getBool(String key) {
    if (localStorage.containsKey(key)) {
      return localStorage[key] == 'true';
    }
    // ignore: avoid_returning_null
    return null;
  }

  void setBool(String key, bool value) {
    localStorage[key] = '$value';
  }

  Map<String, dynamic> getJSON(String key) {
    return json.decode(this.getString(key));
  }

  void setJSON(String key, Map<String, dynamic> value) {
    this.setString(key, json.encode(value));
  }

  bool has(String key) {
    return localStorage[key] != null;
  }
}
