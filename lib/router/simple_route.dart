import 'package:flutter/material.dart';

class SimpleRoute extends PageRoute {
  final String title;
  final WidgetBuilder builder;

  SimpleRoute({
    @required String name,
    @required this.title,
    @required this.builder,
  }) : super(
            settings: RouteSettings(
          name: name,
        ));

  @override
  Color get barrierColor => Colors.white;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Title(
      title: this.title,
      color: Theme.of(context).primaryColor,
      child: builder(context),
    );
  }
}
