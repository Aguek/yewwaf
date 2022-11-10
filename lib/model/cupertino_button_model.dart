import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants.dart';

class CupertinoButtonModel extends StatelessWidget {
  final VoidCallback onPressed;
  final Text child;
  CupertinoButtonModel({required this.onPressed, required this.child});
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      color: yellowColor,
      padding: EdgeInsets.all(10.0),
      child: child,
      borderRadius: BorderRadius.circular(12.0),
    );
  }
}
