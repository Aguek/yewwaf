import 'package:flutter/material.dart';
class ScreenTitleModel extends StatelessWidget {
  final String pageTitle;
  ScreenTitleModel({required this.pageTitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
      child: Center(
        child: Text(
          pageTitle,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
            fontSize: 35.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}