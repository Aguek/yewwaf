import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yewwaf/screens/index_screen.dart';
import 'package:yewwaf/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var contact = preferences.getString('contact');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: contact == null ? WelcomeScreen() : BottomMenu(contact: contact),
    ),
  );
}
