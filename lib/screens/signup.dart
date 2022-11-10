import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yewwaf/constants.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'package:yewwaf/model/text_field_model.dart';
import 'package:yewwaf/model/button_model.dart';
import 'package:yewwaf/model/card_model.dart';
import 'package:yewwaf/screens/index_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl_phone_field/intl_phone_field.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final contact = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();
  final name = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  bool visible = false;
  var webMessage; //json web response
  late String actionText;
  //method to choose different words when the response from the web is different
  String actionTextFunction() {
    if (webMessage == "CONTACT ALREADY EXISTS") {
      return actionText = "USE ANOTHER NUMBER";
    } else if (webMessage == "PASSWORD MIS-MATCH") {
      return actionText = "CROSS-CHECK PASSWORDS";
    } else if (webMessage == "ENTER YOUR DETAILS") {
      return actionText = "FILL FORM";
    } else {
      return actionText = "WHOOP IN";
    }
  }

  //this is to show the screen to go to when the message from the web is not a success message
  void screenNavigator() {
    if (actionText == "USE ANOTHER NUMBER" ||
        actionText == "CROSS-CHECK PASSWORDS" ||
        actionText == "FILL FORM") {
      Navigator.pop(context);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    contact: contact.text,
                  )));
    }
  }

  Future sendData() async {
    setState(() {
      visible = true;
    });
    String user_contact = contact.text;
    String user_pass = password.text;
    String user_c_pass = confirm_password.text;
    String user_name = name.text;
    String user_city = city.text;
    String user_address = address.text;
    //url, converted to Uri
    var url = "https://rokeats.000webhostapp.com/initial_info.php";

    //storing data with the parameter name
    var data = {
      'user_contact': user_contact,
      'user_pass': user_pass,
      'user_c_pass': user_c_pass,
      'user_name': user_name,
      'user_address': user_address,
      'city_id': '1',
    };
    //webcall
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    //getting server response
    webMessage = jsonDecode(response.body);
    print(webMessage);
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(
                webMessage,
                style: TextStyle(color: Colors.green, fontSize: 20.0),
              ),
              actions: [
                // ignore: deprecated_member_use
                CupertinoDialogAction(
                  child: Text(actionTextFunction()),
                  onPressed: screenNavigator,
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                webMessage,
                style: TextStyle(color: Colors.green, fontSize: 20.0),
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: screenNavigator,
                    child: Text(actionTextFunction())),
              ],
            );
          }
        });
  }

  var selectedCity;
  //empty list of cities, it is empty because it gets everything from the db
  List listOfCities = [];
  Future getCity() async {
    final url = "https://rokeats.000webhostapp.com/city.php";
    final getData =
        await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    var getResponse = json.decode(getData.body);
    //after we get the response body, we assign it to the list in setState method
    setState(() {
      listOfCities = getResponse;
    });
  }

  @override
  void initState() {
    super.initState();
    getCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 70.0, bottom: 70.0),
            child: Center(
              child: Text(
                'Sign Up.',
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
            child: Container(
              child:  Platform.isIOS ? CupertinoActivityIndicator(radius: 14,) : CircularProgressIndicator(),
            ),
            visible: visible,
          ),
          Expanded(
            //singlechildscrollview is to make the textfields adjust to fit on the screen when the keyboard comes up
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  //the CardModel is a class from the models directory which contains a card, and it has one arguement called column, and
                  //it is of type widget, that is why it is being assigned a Column
                  child: CardModel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
                          //this TextFieldModel is a model of all the textfields which comes from the model class
                          child: IntlPhoneField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Enter your contact',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            controller: contact,
                            initialCountryCode: 'SS',
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                          ),
                        ),

                        Padding(
                          padding:
                              EdgeInsets.only(top: 30.0, left: 8.0, right: 8.0),
                          child:// Platform.isIOS
                          //     ? CupertinoTextField(
                          //         controller: password,
                          //         obscureText: true,
                          //         placeholder: 'Enter your password',
                          //       )
                          //     :
                                  TextFieldModel(
                                  controller: password,
                                  hint: 'Enter your password',
                                ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child: //Platform.isIOS
                            //     ? CupertinoTextField(
                            //         controller: confirm_password,
                            //         obscureText: true,
                            //         placeholder: 'Enter your password',
                            //       )
                                //:
                                   TextFieldModel(
                                    controller: confirm_password,
                                    hint: 'Confirm your password')),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child:
                            // Platform.isIOS
                            //     ? CupertinoTextField(
                            //         controller: name,
                            //         placeholder: 'Enter your name',
                            //       )
                            //     :
                            TextFieldModel(
                                    controller: name, hint: 'Enter your name')),
                        //  this is a dropdown for select the city, it is populated from the db
                        // Padding(
                        //   padding:  EdgeInsets.all(8.0),
                        //   child: DropdownButton(
                        //     style: TextStyle(fontSize:18.0, color: Colors.black,letterSpacing: 3.0),
                        //     dropdownColor: yellowColor,
                        //     hint: Text('Select city you live'),
                        //     isExpanded: true,
                        //     value: selectedCity,
                        //     items: listOfCities.map((items){
                        //       return DropdownMenuItem(child: Center(child: Text(items['city_name'])), value: items['id'].toString());
                        //     }).toList(),
                        //     onChanged: (newValue){
                        //       setState(() {
                        //         selectedCity = newValue.toString();
                        //       });
                        //     },
                        //   ),
                        // ),

                        Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 8.0, right: 8.0),
                            child:
                            // Platform.isIOS
                            //     ? CupertinoTextField(
                            //         controller: address,
                            //         placeholder:
                            //             'Enter your house number and street name.',
                            //       )
                            //     :
                            TextFieldModel(
                                    controller: address,
                                    hint:
                                        'Enter your house number and street name.')),
                        SizedBox(height: 25.0),
                        //the button model is from the model class
                        //IT SHOULD BE ABLE TO SUBMIT TO THE DATABASE
                        Platform.isIOS
                            ? CupertinoButtonModel(
                                onPressed: sendData,
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : ButtonModel(
                                text: Text(
                                  "REGISTER",
                                  style: TextStyle(fontSize: 25),
                                ),
                                onPressed: sendData,
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
    );
  }
}
