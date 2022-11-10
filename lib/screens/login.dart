import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yewwaf/constants.dart';
import 'package:yewwaf/model/button_model.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'package:yewwaf/model/text_field_model.dart';
import 'package:yewwaf/screens/verify_contact.dart';
import 'index_screen.dart';
import 'dart:io';
import 'package:yewwaf/model/card_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phone = TextEditingController();
  final password = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;
  bool visibility = false;
  Future loginUser() async {
    setState(() {
      visibility = true;
    });
    String url = "https://rokeats.000webhostapp.com/login.php";
    //mapping the data on the server to the data from the input field
    var data = {
      'contact': phone.text,
      'password': password.text,
    };
    final response = await http.post(Uri.parse(url), body: json.encode(data));
    //decoding the message from the server
    final webMessage = jsonDecode(response.body);
    print(webMessage.toString());
    if (response.statusCode == 200) {
      setState(() {
        visibility = false;
      });
    }

    if (webMessage != "LOGIN SUCCESSFUL") {
      showDialog(
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(webMessage),
              actions: [
                // ignore: deprecated_member_use
                CupertinoDialogAction(
                  child: Text('RETRY'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(webMessage),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('RETRY'))
              ],
            );
          }
        },
        context: context,
      );
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('contact', phone.text);
      //WE PUSH THE USER TO THE HOME SCREEN AND PASS THE CONTACT ALONG
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      contact: phone.text,
                    )));
      });
    }
  }

//method to get the position of the user
  getCurrentPosition() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = geoPosition.latitude;
      longitude = geoPosition.longitude;
    });
  }


  //we call the method to get the user location as soon as we initialise the app
  @override
  void initState() {
    super.initState();
    getCurrentPosition();
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
                  'Login',
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
                            child: IntlPhoneField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Enter your contact',
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child:
                                // Platform.isIOS
                                //     ? CupertinoTextField(
                                //         controller: password,
                                //         obscureText: true,
                                //         placeholder: 'Enter your password',
                                //       )
                                //     :
                                TextFieldModel(
                                    controller: password,
                                    hint: 'Enter your password'),
                          ),
                          SizedBox(height: 25.0),
                          //the button model is from the model class
                          //it will contain code to validate the user logging in so that he can login or be denied access
                          //all of that will in the onPressed
                          Platform.isIOS
                              ? CupertinoButtonModel(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: loginUser,
                                )
                              : ButtonModel(
                                  text: Text(
                                    "LOGIN",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  onPressed: loginUser,
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 0.0,
                            ),
                            child: TextButton(
                              onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyContact()));
                              },
                              child: Text('Forgot password?'),
                            ),
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
