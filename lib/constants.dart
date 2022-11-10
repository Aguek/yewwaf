
import 'dart:ui';

import 'package:flutter/material.dart';

const yellowColor = Color(0xFFebc034);
const homeColor = Color(0xFFe3e3e3);
const String googleAPIKey = "AIzaSyCyRe6TVLnW2_59Ofpcn8ZmsAAcBWDdvHo";
TextStyle offerDecorationPrice = TextStyle(decoration: TextDecoration.lineThrough,
  fontSize: 16.0,);
const locationError = "PLEASE TURN ON YOUR LOCATION";
const failedToLoadMeal = "NETWORK PROBLEM, PLEASE TRY AGAIN.";
const failedToLoadMealActionText = "RETRY";
TextStyle locationErrorStyle = TextStyle(color: Colors.red, fontSize: 18.0);
const locationActionText = "TURN LOCATION ON.";
TextStyle locationActionTextStyle = TextStyle(color: Colors.black);
TextStyle successStyle = TextStyle(color: Colors.green,fontSize: 18.0);