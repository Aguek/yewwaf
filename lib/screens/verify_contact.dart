import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yewwaf/model/button_model.dart';
import 'package:yewwaf/model/card_model.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'package:yewwaf/screens/reset_password.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyContact extends StatefulWidget {
  @override
  _VerifyContactState createState() => _VerifyContactState();
}

class _VerifyContactState extends State<VerifyContact> {
  TextEditingController phone = TextEditingController();
  bool visibility = false;

  ///method to verify the user through an http request
  Future verifyUser() async {
    setState(() {
      visibility = true;
    });

    var bindData = {
      'contact': phone.text,
    };
    String url = "";
    var request = await http.post(Uri.parse(url), body: json.encode(bindData));
    var response = json.decode(request.body);
    if (request.statusCode == 200) {
      setState(() {
        visibility = false;
      });
    }
    if (response.toString() == "Contact Verified") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(
                  "Contact Verified",
                  style: successStyle,
                ),
                content: Column(
                  children: [
                    Text("Proceed to reset password."),
                    Icon(
                      Icons.done,
                      size: 20.0,
                      color: Colors.green,
                    ),
                  ],
                ),
                actions: [
                  CupertinoButtonModel(
                      //we have to navigate to the reset screen from here
                      onPressed: () {},
                      child: Text("Proceed")),
                ],
              );
            } else {
              return AlertDialog(
                title: Text("Contact Verified", style: successStyle),
                content: Column(
                  children: [
                    Text("Proceed to reset password."),
                    Icon(
                      Icons.done,
                      size: 20.0,
                      color: Colors.green,
                    ),
                  ],
                ),
                actions: [
                  ButtonModel(
                    onPressed: () {},
                    text: Text("Proceed"),
                  ),
                ],
              );
            }
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text("Invalid Contact", style: locationErrorStyle),
                content: Column(
                  children: [
                    Text("Please cross-check and try again."),
                    Icon(
                      Icons.clear,
                      size: 20.0,
                      color: Colors.red,
                    ),
                  ],
                ),
                actions: [
                  CupertinoButtonModel(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(failedToLoadMeal)),
                ],
              );
            } else {
              return AlertDialog(
                title: Text("Invalid Contact", style: locationErrorStyle),
                content: Column(
                  children: [
                    Text("Please cross-check and try again."),
                    Icon(
                      Icons.clear,
                      size: 20.0,
                      color: Colors.red,
                    ),
                  ],
                ),
                actions: [
                  ButtonModel(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: Text(failedToLoadMeal),
                  ),
                ],
              );
            }
          });
    }
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
                  'Verify Contact',
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
                  ? CupertinoActivityIndicator(
                      radius: 14,
                    )
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
                            child: IntlPhoneField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText:
                                    'Please enter your registered contact',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              controller: phone,
                              initialCountryCode: 'SS',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                              },
                            ),
                          ),
                          Platform.isIOS
                              ? CupertinoButtonModel(
                                  child: Text(
                                    "Verify Contact",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ResetPassword(phone: phone,)));
                                  },
                                )
                              : ButtonModel(
                                  text: Text(
                                    "Verify Contact",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ResetPassword(phone: phone,)));
                                  },
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
