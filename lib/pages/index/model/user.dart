import 'package:swiftclub/models/model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class User extends ModelBase {
  double updatedAt;
  String info;
  String name;
  int state;
  double createdAt;
  int role;
  String avator;
  String email;
  int id;

  static User fromJson(Map json) {
    var user = User();
    user.updatedAt = SafeValue.toDouble(json['updatedAt']);
    user.info = SafeValue.toStr(json['info']);
    user.name = SafeValue.toStr(json['name']);
    user.state = SafeValue.toInt(json['state']);
    user.createdAt = SafeValue.toDouble(json['createdAt']);
    user.role = SafeValue.toInt(json['role']);
    user.avator = SafeValue.toStr(json['avator']);
    user.email = SafeValue.toStr(json['email']);
    user.id = SafeValue.toInt(json['id']);
    return user;
  }
}
