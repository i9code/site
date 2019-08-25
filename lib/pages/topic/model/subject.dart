import 'package:swiftclub/models/model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class Subject extends ModelBase {
  int id;
  String name;
  String remarks;
  String icon;
  int topicNum;
  int focusNum;
  double createdAt;

  static Subject fromJson(Map json) {
    Subject subject = Subject();
    subject.id = SafeValue.toInt(json['id']);
    subject.name = SafeValue.toStr(json['name']);
    subject.remarks = SafeValue.toStr(json['remarks']);
    subject.icon = SafeValue.toStr(json['icon']);
    subject.topicNum = SafeValue.toInt(json['topicNum']);
    subject.focusNum = SafeValue.toInt(json['focusNum']);
    subject.createdAt = SafeValue.toDouble(json['createdAt']);
    return subject;
  }
}
