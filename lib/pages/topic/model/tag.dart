import 'package:swiftclub/models/model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class Tag extends ModelBase {
  int id;
  String name;
  String remarks;
  int state;

  static Tag fromJson(Map json) {
    Tag tag = Tag();
    tag.id = SafeValue.toInt(json['id']);
    tag.name = SafeValue.toStr(json['name']);
    tag.remarks = SafeValue.toStr(json['remarks']);
    tag.state = SafeValue.toInt(json['state']);
    return tag;
  }
}
