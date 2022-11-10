import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CalculateDistance {
  double userLatitude;
  double userLongitude;
  double restLatitude;
  double restLongitude;
  // double distance = Geolocator.distanceBetween(userLatitude, userLongitude, endLatitude, endLongitude);
  var transportCost;
  var distance;
  CalculateDistance(
      {required this.userLatitude,
      required this.userLongitude,
      required this.restLatitude,
      required this.restLongitude});
  //CalculateDistance.prices();
  var lessThan2km;
  var lessThan4km;
  var lessThan6km;
  var lessThan8km;
  var lessThan10km;
  var lessThan12km;
  var lessThan14km;
  var lessThan16km;
  var beyond16km;
  getDistance() {
     distance = Geolocator.distanceBetween(
        userLatitude, userLongitude, restLatitude, restLongitude) /
        1000 +
        0.5;
     return distance;
  }
  getTransportCost(){

    double distance = Geolocator.distanceBetween(
                userLatitude, userLongitude, restLatitude, restLongitude) /
            1000 +
        0.5;

    if (distance <= 2.0) {
      return transportCost = lessThan2km != null ? lessThan2km : 600;
    } else if (distance > 2.0 && distance <= 4.0) {
      return transportCost = lessThan4km != null ? lessThan4km : 800;
    } else if (distance > 4.0 && distance <= 6.0) {
      return transportCost = lessThan6km != null ? lessThan6km : 1000;
    } else if (distance > 6.0 && distance <= 8.0) {

      return transportCost = lessThan8km != null ? lessThan8km : 1250;
    } else if (distance > 8.0 && distance <= 10.0) {
      return transportCost = lessThan10km != null ? lessThan10km : 1400;
    } else if (distance > 10.0 && distance <= 12.0) {
      return transportCost = lessThan12km != null ? lessThan12km : 1600;
    } else if (distance > 12.0 && distance <= 14.0) {
      return transportCost = lessThan14km != null ? lessThan14km : 1800;
    } else if (distance > 14.0 && distance <= 16.0) {
      return transportCost = lessThan16km != null ? lessThan16km : 2000;
    } else {
      return transportCost = lessThan16km != null ? lessThan16km : 2900;
    }
  }
}
class TransportPrices extends StatefulWidget{
  var lessThan2km;
  var lessThan4km;
  var lessThan6km;
  var lessThan8km;
  var lessThan10km;
  var lessThan12km;
  var lessThan14km;
  var lessThan16km;
  var beyond16km;
  TransportPrices({required this.lessThan2km,required this.lessThan4km,required this.lessThan6km,
    required this.lessThan8km,required this.lessThan10km,required this.lessThan12km,
    required this.lessThan14km,required  this.lessThan16km,required  this.beyond16km});
  @override
  _TransportPricesState createState() => _TransportPricesState();
}

class _TransportPricesState extends State<TransportPrices> {

  //var webMessage;
  Future model(String link, var price) async {
    String url = link;
    var request =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    //await Future.delayed(Duration(seconds: 5));
    setState(() {
      price = jsonDecode(request.body);
    });

    return double.parse(price);
  }

  Future get2kmCost() async {
    model("https://rokeats.000webhostapp.com/lessThan2km.php", widget.lessThan2km);
    return widget.lessThan2km;
  }

  Future get4kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan4km.php";
    model(url, widget.lessThan4km);
    return widget.lessThan4km;
  }

  Future get6kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan6km.php";
    model(url, widget.lessThan6km);
    return widget.lessThan6km;
  }

  Future get8kmCost() async {
    var request =
    await http.get(Uri.parse("https://rokeats.000webhostapp.com/lessThan8km.php"), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      widget.lessThan8km = response;
    });
  //  await Future.delayed(Duration(seconds: 2));
    return widget.lessThan8km;
  }

  Future get10kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan10km.php";
    model(url, widget.lessThan10km);
    return widget.lessThan10km;
  }

  Future get12kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan12km.php";
    model(url, widget.lessThan12km);
    return widget.lessThan12km;
  }

  Future get14kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan14km.php";
    model(url, widget.lessThan14km);
    return widget.lessThan14km;
  }

  Future get16kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan16km.php";
    var request = await http.get(Uri.parse(url),headers:{"Application":"accept/json"});
    var response = jsonDecode(request.body);
    print("*********************LESS THAN 16KM PRICE IS: ${response.toString()}");
    setState(() {
      widget.lessThan16km = double.parse(response);
    });
    return widget.lessThan16km;
  }

  Future moreThan16kmCost() async {
    String url = "https://rokeats.000webhostapp.com/moreThan16km.php";
    var request = await http.get(Uri.parse(url),headers: {"Accept":"accept/json"});
    var response = jsonDecode(request.body);
    setState(() {
      widget.beyond16km = double.parse(widget.beyond16km);
    });
    print("*********************BEYOND 16KM PRICE IS: ${response}");

    return widget.beyond16km;
  }
  @override
  void initState(){
    get8kmCost();
    get6kmCost();
    get2kmCost();
    get16kmCost();
    get14kmCost();
    get12kmCost();
    get10kmCost();
    get4kmCost();
    moreThan16kmCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


