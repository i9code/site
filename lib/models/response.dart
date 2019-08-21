import 'model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class PData extends ModelBase {
  int total;
  int per;

  static PData fromJson(Map json) {
    PData data = PData();
    data.total = SafeValue.toInt(json['total']);
    data.per = SafeValue.toInt(json['per']);
    return data;
  }
}

class PPosition extends ModelBase {
  int current;
  int next;
  int max;

  static PPosition fromJson(Map json) {
    PPosition position = PPosition();
    position.current = SafeValue.toInt(json['current']);
    position.next = SafeValue.toInt(json['next']);
    position.max = SafeValue.toInt(json['max']);
    return position;
  }
}

class RPage extends ModelBase {
  PData data;
  PPosition position;

  static RPage fromJson(Map json) {
    RPage page = RPage();
    page.data = PData.fromJson(SafeValue.toMap(json['data']));
    page.position = PPosition.fromJson(SafeValue.toMap(json['position']));
    return page;
  }
}
