import 'package:flutter/material.dart';


class FlatButtonModel extends StatelessWidget {
  final Color textColor, splashColor, buttonColor;
  final Text child;
  final VoidCallback onPressed;
  FlatButtonModel({required this.textColor, required this.splashColor, required this.buttonColor, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      textColor: textColor,
      padding: EdgeInsets.all(10.0),
      color: buttonColor,
      splashColor: splashColor,
      child: child,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
