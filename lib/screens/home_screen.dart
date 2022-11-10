import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import 'order_screen_for_pizza.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'order_screen_for_regular_meals.dart';
import 'order_screen_for_regular_offers.dart';

//this is a class that will contain the code for the home screen
const link =
    'https://images.pexels.com/photos/1624487/pexels-photo-1624487.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
const link1 =
    'https://i1.wp.com/the-sportsnation.com/wp-content/uploads/2021/04/IMG-20210416-WA0019.jpg?fit=766%2C1024&ssl=1';
const link2 =
    'https://images.pexels.com/photos/1252841/pexels-photo-1252841.jpeg?cs=srgb&dl=pexels-burak-kebapci-1252841.jpg&fm=jpg';

class HomeScreen extends StatefulWidget {
  final String userContact;
  HomeScreen({required this.userContact});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //get the offers which are pizza or burger
  Future getOffersOfPizza() async {
    String url = "https://rokeats.000webhostapp.com/getPizzaOffers.php";
    var sendContact =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var responseBody = json.decode(sendContact.body);
    print(responseBody.toString());
    return responseBody;
  }

  //get the offers of regular meals
  Future getRegularOffers() async {
    String url = "https://rokeats.000webhostapp.com/getRegularOffers.php";
    var getOffers =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var response = json.decode(getOffers.body);
    print(response.toString());
    return response;
  }

  //get the meals of the day
  Future getRegularMeals() async {
    String url = "https://rokeats.000webhostapp.com/getRegularMeals.php";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    print(responseBody.toString());
    return responseBody;
  }

  //method to get the regular pizza meals or burgers
  Future getRegularPizzas() async {
    String url = "https://rokeats.000webhostapp.com/getRegularPizza.php";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var body = json.decode(response.body);
    print(body.toString());
    return body;
  }

  var yummyOffersText;
  var normalOffersText;
  var normalMealText;
  var regularPizzaHeading;
  Future getPizzaOfferSectionHeading() async {
    String url = "https://rokeats.000webhostapp.com/firstRowTitle.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      yummyOffersText = jsonDecode(request.body);
    });

    return yummyOffersText;
  }

  Future getNormalOfferSectionHeading() async {
    String url = "https://rokeats.000webhostapp.com/secondRowTitle.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      normalOffersText = jsonDecode(request.body);
    });
    return normalOffersText;
  }

  Future getNormalMealSectionHeading() async {
    String url = "https://rokeats.000webhostapp.com/thirdRowTitle.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      normalMealText = jsonDecode(request.body);
    });

    return normalMealText;
  }

  Future getPizzaSectionHeading() async {
    String url = "https://rokeats.000webhostapp.com/fourthRowTitle.php";
    var request =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      regularPizzaHeading = jsonDecode(request.body);
    });

    return regularPizzaHeading;
  }

  double userLatitude = 0.0;
  double userLongitude = 0.0;
  Future getPosition() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      userLatitude = geoPosition.latitude;
      userLongitude = geoPosition.longitude;
    });

    return geoPosition;
  }

  //method to calculate distance, the parameters in the parenthesis are the restaurant
  //coordinates
  double distance = 0.0;
  calculateDistance(String lat, String longitude) {
    double calculateDistance = Geolocator.distanceBetween(userLatitude,
                userLongitude, double.parse(lat), double.parse(longitude)) /
            1000 + 0.5;
    distance = double.parse(calculateDistance.floor().toString());
    return distance;
  }

  @override
  void initState() {
    super.initState();
    getPosition();
    getOffersOfPizza();
    getPizzaSectionHeading();
    getNormalMealSectionHeading();
    getNormalOfferSectionHeading();
    getPizzaOfferSectionHeading();
    getRegularOffers();
    getRegularMeals();
    getRegularPizzas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(height: 10.0),
            imageContainer(),
            SizedBox(height: 20.0),
            offers(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  //this is a widget containing the image which will be on the home page, the static image which is the first to be referenced
  //in the list view above
  Widget imageContainer() {
    List<String> imgList = [
      'https://rokeats.000webhostapp.com/images/girls.jpg',
      'https://rokeats.000webhostapp.com/images/akou.jpg',
      'https://rokeats.000webhostapp.com/images/pizza.jpg',
    ];
    return Container(
        height: MediaQuery.of(context).size.height / 3.5,
        child: CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height / 3.5,
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
        ));
    // return Container(
    //   height: 250.0,
    //   child: Image.network(link, fit: BoxFit.cover),
    // );
  }

  //this widget will hold the section that will contain the offers of the restaurants
  Widget offers() {
    return Material(
      elevation: 15.0,
      color: Colors.white,
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.local_offer,
                color: Color(0xFFFBB741),
              ),
              labelContainer(
                  yummyOffersText != null ? yummyOffersText : "Yummy Offers"),
              Icon(
                Icons.local_offer,
                color: Color(0xFFFBB741),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: foodCreator(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Color(0xFFFBB741),
                ),
                labelContainer(normalOffersText != null
                    ? normalOffersText
                    : 'King Size Offers'),
                Icon(
                  Icons.star,
                  color: Color(0xFFFBB741),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: regularOffers(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thumb_up,
                  color: Color(0xFFFBB741),
                ),
                labelContainer(
                    normalMealText != null ? normalMealText : 'Biggest Deals'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: normalMeals(),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lunch_dining,
                  color: Color(0xFFFBB741),
                ),
                labelContainer(regularPizzaHeading != null
                    ? regularPizzaHeading
                    : 'Not Done Yet?'),
                Icon(
                  Icons.local_pizza,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: normalPizzas(),
          ),
        ],
      ),
    );
  }

  //this is to create a label for the various sections
  Widget labelContainer(String sectionName) {
    return Text(
      sectionName,
      style: TextStyle(
          letterSpacing: 4.0,
          fontWeight: FontWeight.w900,
          fontSize: 20.0,
          color: Colors.black),
    );
  }

  //this is a widget to form the normal pizzas
  Widget normalPizzas() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.8,
      child: FutureBuilder(
          future: getRegularPizzas(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            late List snap = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData == false) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: Text(
                    failedToLoadMeal,
                    style: locationErrorStyle,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(failedToLoadMealActionText,
                          style: locationActionTextStyle),
                      onPressed: () {
                        setState(() {
                          normalPizzas();
                        });
                      },
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text(
                    failedToLoadMeal,
                    style: locationErrorStyle,
                  ),
                  actions: [
                    FlatButton(
                        color: yellowColor,
                        onPressed: () {
                          setState(() {
                            normalPizzas();
                          });
                        },
                        child: Text(
                          failedToLoadMealActionText,
                          style: locationActionTextStyle,
                        ))
                  ],
                );
              }
            }

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  return imageSectionForPizza(
                      snap[index]['id'],
                      'https://rokeats.000webhostapp.com/pages/images/${snap[index]['picture']}',
                      snap[index]['food_name'],
                      snap[index]['category'],
                      snap[index]['m_price'],
                      snap[index]['s_price'],
                      snap[index]['l_price'],
                      snap[index]['restaurant'],
                      snap[index]['lat'],
                      snap[index]['longitude']);
                });
          }),
    );
  }

  //this is the creator for the normal meals i.e. !pizza and !burgers
  Widget normalMeals() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.8,
      child: FutureBuilder(
          future: getRegularMeals(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            late List snap = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator());
            }
            if (snapshot.hasData == false) {
              if (Platform.isIOS) {
                return CupertinoAlertDialog(
                  title: Text(
                    failedToLoadMeal,
                    style: locationErrorStyle,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(failedToLoadMealActionText,
                          style: locationActionTextStyle),
                      onPressed: () {
                        setState(() {
                          normalMeals();
                        });
                      },
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text(
                    failedToLoadMeal,
                    style: locationErrorStyle,
                  ),
                  actions: [
                    FlatButton(
                        color: yellowColor,
                        onPressed: () {
                          setState(() {
                            normalMeals();
                          });
                        },
                        child: Text(
                          failedToLoadMealActionText,
                          style: locationActionTextStyle,
                        ))
                  ],
                );
              }
            }

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  return imageSectionForRegularMeals(
                      snap[index]['id'],
                      'https://rokeats.000webhostapp.com/pages/images/${snap[index]['picture']}',
                      snap[index]['food_name'],
                      snap[index]['category'],
                      snap[index]['restaurant'],
                      snap[index]['price'],
                      snap[index]['description'],
                      snap[index]['lat'],
                      snap[index]['longitude']);
                });
          }),
    );
  }

  //this is a method for the section for the pizza and burger offers
  Widget foodCreator() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.8,
      child: FutureBuilder(
        future: getOffersOfPizza(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData == false) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(
                  failedToLoadMeal,
                  style: locationErrorStyle,
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(failedToLoadMealActionText,
                        style: locationActionTextStyle),
                    onPressed: () {
                      setState(() {
                        foodCreator();
                      });
                    },
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: Text(
                  failedToLoadMeal,
                  style: locationErrorStyle,
                ),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          foodCreator();
                        });
                      },
                      child: Text(
                        failedToLoadMealActionText,
                        style: locationActionTextStyle,
                      ))
                ],
              );
            }
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snap.length,
              itemBuilder: (context, index) {
                return imageSectionForPizza(
                    snap[index]['id'],
                    'https://rokeats.000webhostapp.com/pages/offer_images/${snap[index]['picture']}',
                    snap[index]['food_name'],
                    snap[index]['category'],
                    snap[index]['medium_price'],
                    snap[index]['small_price'],
                    snap[index]['large_price'],
                    snap[index]['restaurant'],
                    snap[index]['lat'],
                    snap[index]['longitude']);
              });
        },
      ),
    );
  }

//this is the food creator for the regular offers
  Widget regularOffers() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.8,
      child: FutureBuilder(
        future: getRegularOffers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData == false) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(
                  failedToLoadMeal,
                  style: locationErrorStyle,
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(failedToLoadMealActionText,
                        style: locationActionTextStyle),
                    onPressed: () {
                      setState(() {
                        regularOffers();
                      });
                    },
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: Text(
                  failedToLoadMeal,
                  style: locationErrorStyle,
                ),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          regularOffers();
                        });
                      },
                      child: Text(
                        failedToLoadMealActionText,
                        style: locationActionTextStyle,
                      ))
                ],
              );
            }
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snap.length,
              itemBuilder: (context, index) {
                return imageSectionForRegularOffers(
                    snap[index]['id'],
                    'https://rokeats.000webhostapp.com/pages/offer_images/${snap[index]['picture']}',
                    snap[index]['food_name'],
                    snap[index]['category'],
                    snap[index]['new_price'],
                    snap[index]['old_price'],
                    snap[index]['description'],
                    snap[index]['restaurant'],
                    snap[index]['lat'],
                    snap[index]['longitude']);
              });
        },
      ),
    );
  }

  //this widget is the mock up for the individual foods and prices and names, we then use this widget in the foodCreator widget
  // in order to create the various foods
  Widget imageSectionForPizza(
      String id,
      String link,
      String foodName,
      String category,
      var mPrice,
      var sPrice,
      var lPrice,
      String restId,
      String lat,
      String longitude) {
    return GestureDetector(
      onTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await requestLocationDialog();
        } else {
          Future assignCoordinates() async {
            Position geoPosition = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best);
            setState(() {
              userLatitude = geoPosition.latitude;
              userLongitude = geoPosition.longitude;
            });

            return geoPosition;
          }

          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => OrderOfPizzaAndBurger(
                    mealId: '$id',
                    category: '$category',
                    link: '$link',
                    foodName: '$foodName',
                    m_price: '$mPrice',
                    s_price: '$sPrice',
                    l_price: '$lPrice',
                    restId: '$restId',
                    contact: widget.userContact,
                    restLongitude: '$longitude',
                    restLat: '$lat',
                    userLongitude: userLongitude,
                    userLatitude: userLatitude,
                  )));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2 - 30.0,
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(link),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                foodName,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Text(
                mPrice.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(child: Text("${calculateDistance(lat, longitude).toString()} KMs away.",style: TextStyle(color: Colors.green),)),
        ],
      ),
    );
  }

  //this is a mock up for the regular meals
  Widget imageSectionForRegularMeals(
      String id,
      String link,
      String foodName,
      String category,
      String restId,
      var price,
      String description,
      String lat,
      String longitude) {
    return GestureDetector(
      onTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await requestLocationDialog();
        } else {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(
              builder: (context) => OrderScreenForRegularMeals(
                    description: '$description',
                    foodName: '$foodName',
                    link: '$link',
                    restId: '$restId',
                    category: '$category',
                    mealId: '$id',
                    price: '$price',
                    contact: widget.userContact,
                    restLongitude: '$longitude',
                    restLat: '$lat',
                    userLongitude: userLongitude,
                    userLatitude: userLatitude,
                  )));
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2 - 30.0,
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(link),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                foodName,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Text(
                price.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(child: Text("${calculateDistance(lat, longitude).toString()} KMs away.",style: TextStyle(color: Colors.green),)),
        ],
      ),
    );
  }

  //this is a mock up for the regular meals
  Widget imageSectionForRegularOffers(
      String id,
      String link,
      String foodName,
      String category,
      var offerPrice,
      var oldPrice,
      String description,
      String restId,
      String restLat,
      String restLong) {
    return GestureDetector(
      onTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await requestLocationDialog();
        } else {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(
              builder: (context) => OrderScreenForRegularOffers(
                    description: '$description',
                    foodName: '$foodName',
                    link: '$link',
                    category: '$category',
                    mealId: '$id',
                    offerPrice: '$offerPrice',
                    oldPrice: '$oldPrice',
                    restId: '$restId',
                    userContact: widget.userContact,
                    restLongitude: '$restLong',
                    restLat: '$restLat',
                    userLongitude: userLongitude,
                    userLatitude: userLatitude,
                  )));
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2 - 35.0,
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(link),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Text(
                foodName,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Column(
                children: [
                  Text(
                    'SSP ${oldPrice.toString()}',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    offerPrice.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: Text("${calculateDistance(restLat, restLong).toString()} KMs away.",style: TextStyle(color: Colors.green),)),

        ],
      ),
    );
  }

  requestLocationDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(
                locationError,
                style: locationErrorStyle,
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    color: Colors.brown,
                    onPressed: () async {
                      Position geoPosition =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best);
                      setState(() {
                        userLatitude = geoPosition.latitude;
                        userLongitude = geoPosition.longitude;

                        Navigator.pop(context);
                      });
                      return geoPosition as Future<void>;
                    },
                    child: Text(
                      locationActionText,
                      style: locationActionTextStyle,
                    )),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                locationError,
                style: locationErrorStyle,
              ),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                    color: yellowColor,
                    onPressed: () async {
                      Position geoPosition =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best);
                      setState(() {
                        userLatitude = geoPosition.latitude;
                        userLongitude = geoPosition.longitude;
                        Navigator.pop(context);
                      });

                      return geoPosition as Future<void>;
                    },
                    child: Text(
                      locationActionText,
                      style: locationActionTextStyle,
                    )),
              ],
            );
          }
        });
  }
}

/*
Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: yellowColor),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search your favourite meal',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
*/
