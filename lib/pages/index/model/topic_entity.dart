import 'package:swiftclub/models/model_base.dart';
import 'package:swiftclub/kit/value/safe_value.dart';
import 'package:swiftclub/pages/index/model/topic.dart';
import 'package:swiftclub/pages/index/model/user.dart';

class TopicEntity extends ModelBase {
  Topic topic;
  User user;

  static TopicEntity fromJson(Map json) {
    TopicEntity entity = TopicEntity();
    entity.topic = Topic.fromJson(SafeValue.toMap(json['topic']));
    entity.user = User.fromJson(SafeValue.toMap(json['user']));
    return entity;
  }
}
