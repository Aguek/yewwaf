import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:yewwaf/constants.dart';

class Orders extends StatefulWidget {
  final String contact;
  Orders({required this.contact});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future getMealOrders() async {
    String url = "https://rokeats.000webhostapp.com/getClientMealOrders.php";
    var data = {
      'contact': widget.contact,
    };
    var request = await http.post(Uri.parse(url), body: json.encode(data));
    var requestBody = json.decode(request.body);
    print(requestBody.toString());
    return requestBody;
  }

  Future getOfferOrders() async {
    String url = "https://rokeats.000webhostapp.com/getClientMealOrders.php";
    var data = {
      'contact': widget.contact,
    };
    var request = await http.post(Uri.parse(url), body: json.encode(data));
    var requestBody = json.decode(request.body);
    print(requestBody.toString());
    return requestBody;
  }

  @override
  void initState() {
    super.initState();
    getMealOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getMealOrders(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(
                  "Network problem, or you don't have any orders, try again.",
                  style: locationErrorStyle,
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      "LOAD ORDERS AGAIN.",
                      style: locationActionTextStyle,
                    ),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: Text(
                  "Network problem, or you don't have any orders, try again.",
                  style: locationErrorStyle,
                ),
                actions: [
                  FlatButton(
                    color: yellowColor,
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      "LOAD ORDERS AGAIN.",
                      style: locationActionTextStyle,
                    ),
                  ),
                ],
              );
            }
          }
          return ListView.builder(
              itemCount: snap.length,
              itemBuilder: (BuildContext context, int index) {
                return ordersModel(
                  snap[index]['id'],
                  snap[index]['status'],
                  snap[index]['picture'],
                  snap[index]['food_name'],
                  snap[index]['time_ordered'],
                  snap[index]['price'],
                );
              });
        },
      ),
    );
  }

  Widget ordersModel(String mealId, String statusId, String imageLink,
      String foodName, String timeOrdered, String price) {
    return Card(
      color: statusId != '4' ? yellowColor : Colors.green,
      elevation: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CircleAvatar(
              foregroundColor: yellowColor,
              radius: 50.0,
              foregroundImage: NetworkImage(imageLink == null
                  ? 'https://rokeats.000webhostapp.com/pages/offer_images/$imageLink'
                  : 'https://rokeats.000webhostapp.com/pages/images/$imageLink'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  foodName,
                  softWrap: true,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Price: $price',
                  style: locationActionTextStyle,
                ),
                Text(
                  "Date Ordered: $timeOrdered",
                  softWrap: true,
                ),
                if (statusId == '1')
                  Text(
                    "Order Placed",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  )
                else if (statusId == '2')
                  Text('Preparing order')
                else if (statusId == '3')
                  Text('Being Delivered')
                else
                  Text('Delivered'),
              ],
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () {
                setState(() async {
                  var data = {
                    'id': mealId,
                  };
                  var url =
                      "https://rokeats.000webhostapp.com/deleteClientOrder.php";
                  var delete =
                      await http.post(Uri.parse(url), body: json.encode(data));
                  var responseBody = json.decode(delete.body);
                  print(responseBody.toString());
                  setState(() {
                    build(context);
                  });
                  return responseBody;
                });
              },
              child: Icon(
                Icons.delete,
                size: 24.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
