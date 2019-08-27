import 'package:swiftclub/kit/value/safe_value.dart';

class Catalog {
  int order;
  String title;
  int id;
  String path;
  int pid;
  int level;
  List<Catalog> child;
  int topicId;

  int get pathLength => path.split(',').length;

  static Catalog fromJson(Map json) {
    Catalog catalog = Catalog();
    catalog.id = SafeValue.toInt(json['id']);
    catalog.pid = SafeValue.toInt(json['pid']);
    catalog.title = SafeValue.toStr(json['title']);
    catalog.path = SafeValue.toStr(json['path']);
    catalog.order = SafeValue.toInt(json['order']);
    catalog.level = SafeValue.toInt(json['level']);
    catalog.topicId = SafeValue.toInt(json['topicId']);
    List childs = SafeValue.toList(json['child']);
    List<Catalog> tmpChilds = [];
    for (Map chil in childs) {
      Catalog tlog = Catalog.fromJson(chil);
      tmpChilds.add(tlog);
    }
    catalog.child = tmpChilds;
    return catalog;
  }
}
