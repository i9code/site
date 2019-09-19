import 'package:flutter/material.dart';

class FooterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FooterViewState();
  }
}

class _FooterViewState extends State<FooterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffD8D8D8), width: 1),
        ),
      ),
      child: Text(
        'SwiftClub',
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 120,
    );
  }
}
