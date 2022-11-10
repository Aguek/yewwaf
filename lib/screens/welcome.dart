import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'login.dart';
import 'signup.dart';
import 'package:yewwaf/constants.dart';
import 'package:yewwaf/model/flat_button_model.dart';
import 'package:yewwaf/model/screen_title_model.dart';
import 'dart:io';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.orangeAccent, yellowColor, Colors.pink],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //the model for the screen title of the welcome and other screens like orders
            ScreenTitleModel(pageTitle: 'RUKKU'),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://images.pexels.com/photos/1624487/pexels-photo-1624487.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Platform.isIOS
                          ? CupertinoButtonModel(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Login()),
                                );
                              },
                              child: Text('LOGIN',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Trajan Pro',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            )
                          : FlatButtonModel(
                              textColor: Colors.black,
                              buttonColor: yellowColor,
                              splashColor: Colors.white,
                              child: Text('LOGIN',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new Login()),
                                );
                              },
                            ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Platform.isIOS
                          ? CupertinoButtonModel(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                              child: Text('SIGN UP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            )
                          : FlatButtonModel(
                              textColor: Colors.black,
                              buttonColor: yellowColor,
                              splashColor: Colors.white,
                              child: Text('SIGN UP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                            ),
                    ],
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
