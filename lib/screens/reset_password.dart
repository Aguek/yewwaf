import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yewwaf/model/button_model.dart';
import 'package:yewwaf/model/card_model.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'package:yewwaf/model/text_field_model.dart';
import '../constants.dart';

class ResetPassword extends StatefulWidget {
  var phone;
  ResetPassword({required this.phone});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool visibility = false;
  ///method to update the user password
  Future resetPassword() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 70.0, bottom: 70.0),
              child: Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: visibility,
              child: Platform.isIOS
                  ? CupertinoActivityIndicator(radius: 14,)
                  : CircularProgressIndicator(),
            ),
            Expanded(
              // singlechildscrollview is to make the textfields adjust to fit on the screen when the keyboard comes up
              child: SingleChildScrollView(
                //the CardModel is a class from the models directory which contains a card, and it has one arguement called column, and
                //it is of type widget, that is why it is being assigned a Column
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CardModel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child: TextFieldModel(
                                controller: password,
                                hint: 'Enter your new password'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child: TextFieldModel(
                                controller: password,
                                hint: 'Confirm your new password'),
                          ),
                          Platform.isIOS
                              ? CupertinoButtonModel(
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: resetPassword,
                          )
                              : ButtonModel(
                            text: Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: resetPassword,
                          ),
                        ],
                      ),
                      radius: 30.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
