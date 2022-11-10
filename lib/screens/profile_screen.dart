import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yewwaf/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:yewwaf/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  //final String contact;
  final String contact;
  ProfileScreen({required this.contact});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextStyle style = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
  Future getUserDetails() async {
    String url = "https://rokeats.000webhostapp.com/getUserDetails.php";
    var data = {
      'contact': widget.contact,
    };
    //get the contact and then search the database and then respond
    var sendContact = await http.post(Uri.parse(url), body: json.encode(data));
    var responseBody = json.decode(sendContact.body);
    print(responseBody.toString());
    return responseBody;
  }

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    getUserDetails();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.orangeAccent, yellowColor, Colors.pink],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: FutureBuilder(
        future: getUserDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text("THERE WAS AN ERROR, TRY AGAIN LATER"),
              );
            } else {
              return AlertDialog(
                title: Text("THERE WAS AN ERROR, TRY AGAIN LATER"),
              );
            }
          }

          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (BuildContext context, int index) {
              return profileModel(
                  snap[index]['id'],
                  snap[index]['name'],
                  snap[index]['contact'],
                  snap[index]['city_id'],
                  snap[index]['address']);
            },
          );
        },
      ),
    );
  }

  Widget profileModel(
      String id, String name, String contact, String city, String address) {
    List<String> imgList = [
      'https://rokeats.000webhostapp.com/images/girls.jpg',
      'https://rokeats.000webhostapp.com/images/akou.jpg',
      'https://rokeats.000webhostapp.com/images/pizza.jpg',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 20.0,
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height/3,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            autoPlay: true,
          ),
          items: imgList
              .map(
                (item) => Container(
              child: Center(
                  child: Image.network(item,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width)),
            ),
          )
              .toList(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 40.0,
            child: Column(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  name,
                  style: style,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("+211 $contact", style: style),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_city,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  address,
                  style: style,
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
