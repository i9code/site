import 'package:flutter_web/material.dart';
import 'package:swiftclub/pages/pages.dart';
import 'package:swiftclub/kit/kit.dart';
import 'simple_route.dart';

Route<dynamic> buildRouters(RouteSettings settings) {
  dynamic args = settings.arguments;
  switch (settings.name) {
    case "/login":
      return SimpleRoute(
          name: "/login", title: "login", builder: (context) => LoginPage());

    case "/detail":
      if (args == null) {
        // 如果刷新了，这个参数可能不存在，返回首页
        return defaultRoute();
      }
      final topicId = SafeValue.toInt(args['topicId']);
      return SimpleRoute(
          name: "detail",
          title: "detaila",
          builder: (context) => DetailPage(
                topicId: topicId,
              ));

    case "/":
      return defaultRoute();

    default:
      return defaultRoute();
  }
}

SimpleRoute defaultRoute() {
  return SimpleRoute(
      name: '/', title: 'swiftclub', builder: (context) => IndexPage());
}
