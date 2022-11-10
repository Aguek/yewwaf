
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
//i wont be using this class becuase i have failed to handle the state from it
//and it was supposed to act as a model, so i will use repeatitive code on the various
//order buttons
class MakeOrder extends StatefulWidget {
  String contact;
  String mealId;
  int quantity;
  String description;
  String restId;
  var price;

  var webMessage;
  bool visible = false;
//am making a context variable because there is no context at this level
  //then i pass it as a parameter so that i can get the various contexts of the order screens
  BuildContext context;
  MakeOrder({required this.contact, required this.mealId, required this.quantity,
    required this.description, required this.restId, required this.price,required this.visible,
  required this.context});
  late String actionText;

  String actionFunction(){

    if (webMessage == "ORDER PLACED, BRACE YOURSELF.") {
      return actionText = "OK";
    } else {
      return actionText = "RETRY";
    }
  }
  void screenNavigator() {
    if (actionText == "OK") {
      Navigator.pop(context);
    } else {
      makeOrder();
    }
  }

  Future makeOrder() async {

    String url = "https://rokeats.000webhostapp.com/make_order.php";
    var data = {
      'contact':contact,
      'mealId':mealId,
      'quantity': quantity,
      'description': description,
      'restId': restId,
      'price': price,
    };
    var sendData = await http.post(Uri.parse(url),body: json.encode(data));
    webMessage = jsonDecode(sendData.body);
    print(webMessage);

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
                FlatButton(
                    onPressed: screenNavigator,
                    child: Text(actionFunction())),
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
                    child: Text(actionFunction())),
              ],
            );
          }
        });
  }


  @override
  _MakeOrderState createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


