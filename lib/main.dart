// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
import 'package:flutter/material.dart';
import 'package:swiftclub/router/router.dart';
import 'package:swiftclub/kit/kit.dart';

main() {
  DataHelper.setup();
  runApp(SwiftClub());
}

class SwiftClub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'swiftclub',
      theme: ThemeData(fontFamily: "Montserrat"),
      onGenerateRoute: (setting) => buildRouters(setting),
      initialRoute: "/",
    );
  }
}
