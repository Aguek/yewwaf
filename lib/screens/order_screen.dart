import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yewwaf/model/button_model.dart';
import '../constants.dart';
import 'package:geolocator/geolocator.dart';

class Order extends StatefulWidget {
  //passing variables of link, foodName, price for the images and then creating a constructor for them
  //this constructor will be used in the home_screen.dart for moving the various items to this screen.
  //we place these variables in the widget tree of this class.
  final String link;
  final String foodName;
  double price;
  LatLng userCoordinates = LatLng(0.0, 0.0);
  LatLng restaurantCoordinates = LatLng(0.0, 0.0);
  Order(this.link, this.foodName, this.price);

  @override
  _OrderState createState() => _OrderState();
}

int _numberOfOrders = 1;
double finalPrice = 0.0;
TextStyle textStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);

class _OrderState extends State<Order> {
  bool smallSizeIsChecked = true;
  bool mediumSizeIsChecked = false;
  bool largeSizeIsChecked = false;
  double userAndRestaurantDistance = 0.0;
  //method to get the distance between the restaurant and the user, divided by 1000 because it is in metres, add 2.4 as an error distance.
   getDistance() {
    userAndRestaurantDistance = Geolocator.distanceBetween(
                widget.userCoordinates.latitude,
                widget.userCoordinates.longitude,
                widget.restaurantCoordinates.latitude,
                widget.restaurantCoordinates.longitude) /
            1000 +
        2.4;
  }
//get the cost based on the distance
  double getCost() {
    double transportCost;
    if (userAndRestaurantDistance < 4.0) {
      return transportCost = 3000.0;
    } else if (userAndRestaurantDistance > 4.0 && getDistance() < 8.0) {
      return transportCost = 5000.0;
    } else if (userAndRestaurantDistance > 8.0 && getDistance() < 12.0) {
      return transportCost = 7000.0;
    } else if (userAndRestaurantDistance > 12 && getDistance() < 14.5) {
      return transportCost = 10000.0;
    } else {
      return transportCost = 20000.0;
    }
  }

  //method to check if the food if pizza, if it is pizza, we include the sizes and their prices, else, then we do the normal pricing.
  //we call this method in the scaffold,
  Widget theOrderScreen() {
    if (widget.foodName == 'Pizza' || widget.foodName == 'pizza') {
      return Card(
        elevation: 5.0,
        color: Colors.grey[250],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.foodName,
                  style: textStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  finalPrice.toString(),
                  style: textStyle,
                ),
              ],
            ),
            SizedBox(
              height: 3.0,
            ),
            Text(
              'Size',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('S'),
                Checkbox(
                    value: smallSizeIsChecked,
                    onChanged: (newValue) {
                      setState(() {
                        smallSizeIsChecked = newValue!;
                        widget.price = 18000.0;
                        mediumSizeIsChecked = false;
                        largeSizeIsChecked = false;
                      });
                    }),
                Text('M'),
                Checkbox(
                    value: mediumSizeIsChecked,
                    onChanged: (newValue) {
                      setState(() {
                        widget.price = 27000.0;
                        mediumSizeIsChecked = newValue!;
                        smallSizeIsChecked = false;
                        largeSizeIsChecked = false;
                      });
                    }),
                Text('L'),
                Checkbox(
                    value: largeSizeIsChecked,
                    onChanged: (newValue) {
                      setState(() {
                        largeSizeIsChecked = newValue!;
                        widget.price = 36000.0;
                        mediumSizeIsChecked = false;
                        smallSizeIsChecked = false;
                      });
                    }),
              ],
            ),
            Text('Transport cost is: ' + getCost().toString(), style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
          ],
        ),

      );
    } else {
      return Card(
        elevation: 40.0,
        color: Colors.grey[250],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.foodName,
                  style: textStyle,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  finalPrice.toString(),
                  style: textStyle,
                ),
              ],
            ),
            Text('Transport cost is: ' + getCost().toString(), style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
          ],
        ),
      );
    }
  }

  Widget foodDescription() {
    if (widget.foodName == 'Pizza' || widget.foodName == 'pizza') {
      return Text('');
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.black),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: 'Describe how you want your meal(eg. hot).',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            maxLines: 1,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //this is a variable to perform the calculations for the price depending on the quantity of the order
    finalPrice = widget.price * _numberOfOrders;
    double totalCost = finalPrice + getCost();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellowColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
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
            ),
            theOrderScreen(),
            Card(
              child: Row(
                //this is a row to contain the buttons for reducing and incrementing the values as needed
                //it can reduce the quantity or increase it.
                children: [
                  Text(
                    'Quantity',
                    style: textStyle,
                  ),
                  TextButton(
                      child: Icon(
                        Icons.remove_circle_outlined,
                        size: 35.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _numberOfOrders--;
                        });
                      }),
                  Text('$_numberOfOrders'),
                  TextButton(
                    child: Icon(
                      Icons.add_circle_outlined,
                      size: 35.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _numberOfOrders++;
                      });
                    },
                  ),
                  Text('Total: $totalCost', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
                ],
              ),
            ),
            //this is a textfield to get the views of the customer on how he wants his meal

            foodDescription(),

            //once a user presses this button, then we send a notification to restaurant that posted the food, so that they can prepare
            //it then we go and pick it up, deliver it to the owner.
            //then the order is added to the in transit section of the orders.

            ButtonModel(
                text: Text(
                  'ORDER',
                  style: textStyle,
                ),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
