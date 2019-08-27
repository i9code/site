import 'package:swiftclub/models/model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';

class Topic extends ModelBase {
  int textType;
  double createdAt;
  int weight;
  int subjectId;
  int commentCount;
  bool popular;
  int loveCount;
  int userId;
  double updatedAt;
  String content;
  String title;
  int collectCount;
  int browserCount;
  int id;

  static Topic fromJson(Map json) {
    var topic = Topic();
    topic.textType = SafeValue.toInt(json['textType']);
    topic.createdAt = SafeValue.toDouble(json['createdAt']);
    topic.weight = SafeValue.toInt(json['weight']);
    topic.subjectId = SafeValue.toInt(json['subjectId']);
    topic.commentCount = SafeValue.toInt(json['commentCount']);
    topic.popular = SafeValue.toBool(json['popular']);
    topic.loveCount = SafeValue.toInt(json['loveCount']);
    topic.userId = SafeValue.toInt(json['userId']);
    topic.updatedAt = SafeValue.toDouble(json['updatedAt']);
    topic.title = SafeValue.toStr(json['title']);
    topic.collectCount = SafeValue.toInt(json['collectCount']);
    topic.browserCount = SafeValue.toInt(json['browserCount']);
    topic.id = SafeValue.toInt(json['id']);
    topic.content = SafeValue.toStr(json['content']);
    return topic;
  }
}
