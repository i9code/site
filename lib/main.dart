// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
//import 'dart:async';
//import 'dart:html' as prefix0;
//import 'dart:indexed_db';

import 'package:flutter_web/material.dart';
import 'pages/pages.dart';
import 'package:swiftclub/router/router.dart';
import 'package:swiftclub/kit/kit.dart';

main() {
  Static.storage = Storage();
  runApp(SwiftClub());
}

class SwiftClub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'swiftclub',
      onGenerateRoute: (settings) {
        dynamic args = settings.arguments;
        switch (settings.name) {
          case "/login":
            return SimpleRoute(
                name: "/login",
                title: "login",
                builder: (context) => LoginPage());
          case "/detail":
            if (args == null) {
              // 如果刷新了，这个参数可能不存在，返回首页
              return SimpleRoute(
                  name: '/',
                  title: 'Swiftclub',
                  builder: (context) => IndexPage());
            }
            final topicId = SafeValue.toInt(args['topicId']);
            return SimpleRoute(
                name: "detail",
                title: "detaila",
                builder: (context) => DetailPage(
                      topicId: topicId,
                    ));

          case "/":
            return SimpleRoute(
                name: '/',
                title: 'swiftclub',
                builder: (context) => IndexPage());

          default:
            return SimpleRoute(
                name: 'welcome',
                title: 'welcome',
                builder: (_) {
                  return Center(
                    child: Text('welcome'),
                  );
                });
        }
      },
      initialRoute: "/",
    );
  }
}
