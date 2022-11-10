import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yewwaf/model/button_model.dart';
import 'package:yewwaf/model/calculate_transport_cost.dart';
import 'package:yewwaf/model/cupertino_button_model.dart';
import 'package:yewwaf/model/make_order_code.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class OrderScreenForRegularMeals extends StatefulWidget {
  final String link;
  final String foodName;
  var price;
  String category;
  String restId;
  String mealId;
  String description;

  final String restLat;
  final String restLongitude;
  //this is meant to keep the contact of the user so that we can identify the users when
  //placing the orders
  final String contact;
  LatLng userCoordinates = LatLng(0.0, 0.0);
  LatLng restaurantCoordinates = LatLng(0.0, 0.0);
  double userLatitude;
  double userLongitude;
  OrderScreenForRegularMeals(
      {required this.link,
      required this.foodName,
      required this.price,
      required this.category,
      required this.restId,
      required this.userLatitude,
      required this.userLongitude,
      required this.mealId,
      required this.description,
      required this.contact,
      required this.restLat,
      required this.restLongitude});

  @override
  _OrderScreenForRegularMealsState createState() =>
      _OrderScreenForRegularMealsState();
}

int _quantity = 1;
var finalPrice;
TextStyle textStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);

class _OrderScreenForRegularMealsState
    extends State<OrderScreenForRegularMeals> {
//method to get the position of the user
  getCurrentPosition() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      widget.userLatitude = geoPosition.latitude;
      widget.userLongitude = geoPosition.longitude;
    });
    return geoPosition;
  }

  TextEditingController desc = TextEditingController();
  double userAndRestaurantDistance = 0.0;

  bool visible = false;
  var webMessage;
  late String actionText;
  String actionFunction() {
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
      placeOrder();
    }
  }

  Future placeOrder() async {
    setState(() {
      visible = true;
    });
    String url = "https://rokeats.000webhostapp.com/make_order.php";
    var data = {
      'contact': widget.contact,
      'mealId': widget.mealId,
      'quantity': _quantity,
      'description': desc.text,
      'restId': widget.restId,
      'price': finalPrice,
    };
    var sendData = await http.post(Uri.parse(url), body: json.encode(data));
    webMessage = jsonDecode(sendData.body);
    print(webMessage);
    if (sendData.statusCode == 200) {
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
                CupertinoDialogAction(
                  child: Text(actionFunction()),
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
                    onPressed: screenNavigator, child: Text(actionFunction())),
              ],
            );
          }
        });
  }

  var transportCost;
  var lessThan2km;
  var lessThan4km;
  var lessThan6km;
  var lessThan8km;
  var lessThan10km;
  var lessThan12km;
  var lessThan14km;
  var lessThan16km;
  var beyond16km;

  Future get2kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan2km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan2km = response;
    });
    return lessThan2km;
  }

  Future get4kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan4km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan4km = response;
    });
    return lessThan4km;
  }

  Future get6kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan6km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan6km = response;
    });
    return lessThan6km;
  }

  Future get10kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan10km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan10km = response;
    });
    return lessThan10km;
  }

  Future get12kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan12km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan12km = response;
    });
    return lessThan12km;
  }

  Future get14kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan14km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan14km = response;
    });
    return lessThan14km;
  }

  Future get16kmCost() async {
    String url = "https://rokeats.000webhostapp.com/lessThan16km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan16km = response;
    });
    return lessThan16km;
  }

  Future moreThan16kmCost() async {
    String url = "https://rokeats.000webhostapp.com/moreThan16km.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "accept/json"});
    var response = jsonDecode(request.body);
    setState(() {
      beyond16km = double.parse(beyond16km);
    });
    print("*********************BEYOND 16KM PRICE IS: ${response}");

    return beyond16km;
  }

  Future get8kmCost() async {
    var request = await http.get(
        Uri.parse("https://rokeats.000webhostapp.com/lessThan8km.php"),
        headers: {"Accept": "application/json"});
    var response = jsonDecode(request.body);
    setState(() {
      lessThan8km = response;
    });

    return lessThan8km;
  }

  getTransportCost() {
    double distance = Geolocator.distanceBetween(
                widget.userLatitude,
                widget.userLongitude,
                double.parse(widget.restLat),
                double.parse(widget.restLongitude)) /
            1000 +
        0.5;

    if (distance <= 2.0) {
      return transportCost = lessThan2km != null ? lessThan2km : 600;
    } else if (distance > 2.0 && distance <= 4.0) {
      return transportCost = lessThan4km != null ? lessThan4km : 800;
    } else if (distance > 4.0 && distance <= 6.0) {
      return transportCost = lessThan6km != null ? lessThan6km : 1000;
    } else if (distance > 6.0 && distance <= 8.0) {
      return transportCost = lessThan8km != null ? lessThan8km : 1200;
    } else if (distance > 8.0 && distance <= 10.0) {
      return transportCost = lessThan10km != null ? lessThan10km : 1400;
    } else if (distance > 10.0 && distance <= 12.0) {
      return transportCost = lessThan12km != null ? lessThan12km : 1600;
    } else if (distance > 12.0 && distance <= 14.0) {
      return transportCost = lessThan14km != null ? lessThan14km : 1800;
    } else if (distance > 14.0 && distance <= 16.0) {
      return transportCost = lessThan16km != null ? lessThan16km : 2000;
    } else {
      return transportCost = 0;
    }
  }

  showErr() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("You are too far, choose a nearer restaurant"),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'OK',
                    style: locationActionTextStyle,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text("You are too far, choose a nearer restaurant"),
              actions: [
                FlatButton(
                    color: yellowColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'OK',
                      style: locationActionTextStyle,
                    ))
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    get8kmCost();
    get4kmCost();
    get10kmCost();
    get2kmCost();
    get6kmCost();
    get12kmCost();
    get14kmCost();
    get16kmCost();
    moreThan16kmCost();
    getTransportCost();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    var parsedPrice = int.parse(widget.price);
    //this is a variable to perform the calculations for the price depending on the quantity of the order
    finalPrice = (parsedPrice * _quantity);
    var totalCost = finalPrice + getTransportCost();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellowColor,
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(50.0)),
                    image: DecorationImage(
                      //widget.foodName is a way to access a variable that is up the widget tree, that means a variable that is inaccessible
                      image: NetworkImage(widget.link),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Card(
                  elevation: 40.0,
                  color: Colors.grey[250],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.foodName,
                              style: textStyle,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              finalPrice.toString(),
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Delivery cost: SSP ' + getTransportCost().toString(),
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                //adding the description of the meal
                Card(
                  child: Column(
                    children: [
                      Text(
                        "Description",
                        style: textStyle,
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    //this is a row to contain the buttons for reducing and incrementing the values as needed
                    //it can reduce the quantity or increase it.
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Quantity',
                          style: textStyle,
                        ),
                      ),
                      TextButton(
                          child: Icon(
                            Icons.remove_circle_outlined,
                            color: Colors.red,
                            size: 35.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _quantity--;
                              if (_quantity < 1) {
                                _quantity = 1;
                              }
                            });
                          }),
                      Text('$_quantity'),
                      TextButton(
                        child: Icon(
                          Icons.add_circle_outlined,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total: SSP $totalCost',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )
                    ],
                  ),
                ),
                //this is a textfield to get the views of the customer on how he wants his meal

                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                    child: Platform.isIOS
                        ? CupertinoTextField(
                            placeholder: "Describe how you want your meal.",
                            placeholderStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2.5.toInt(),
                            controller: desc,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          )
                        : TextField(
                            controller: desc,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 3.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 5.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText:
                                  'Describe how you want your meal(eg. warm).',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            maxLines: 2.5.toInt(),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      child:  Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
                      visible: visible,
                    ),
                  ],
                ),

                //once a user presses this button, then we send a notification to restaurant that posted the food, so that they can prepare
                //it then we go and pick it up, deliver it to the owner.
                //then the order is added to the in transit section of the orders.
                //Platform dependent  buttons
                Platform.isIOS
                    ? CupertinoButtonModel(
                        onPressed: transportCost == 0 ? showErr : placeOrder,
                        child: Text(
                          'ORDER',
                          style: textStyle,
                        ),
                      )
                    : ButtonModel(
                        text: Text(
                          'ORDER',
                          style: textStyle,
                        ),
                        onPressed: transportCost == 0 ? showErr : placeOrder,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
