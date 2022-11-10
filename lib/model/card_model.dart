import 'package:flutter/material.dart';
/*
this class is a model for the card that will be used to hold the sign in and login forms
*/
class CardModel extends StatelessWidget {
  final Widget child;
  final double radius;
  CardModel({required this.child, required this.radius});
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
