import 'package:flutter/material.dart';

class HeaderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderViewState();
  }
}

class _HeaderViewState extends State<HeaderView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffF05138),
      title: GestureDetector(
        onTap: () {
          Navigator.popAndPushNamed(context, "/");
        },
        child: Container(
          child: Text('SwiftClub'),
        ),
      ),
      elevation: 0,
    );
  }
}
