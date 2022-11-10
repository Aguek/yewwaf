
import 'package:flutter/material.dart';
import 'package:yewwaf/constants.dart';
//this is a class through which all the login and signup buttons will formed
class ButtonModel extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;

  const ButtonModel({Key? key, required this.text, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.yellow),),
        onPressed: onPressed,
        padding: EdgeInsets.all(10.0),
        color: yellowColor,
        textColor: Colors.black,
        splashColor: Colors.white,
        child: text,
      ),
    );
  }
}