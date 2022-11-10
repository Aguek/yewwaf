import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yewwaf/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'order_screen_for_pizza.dart';
import 'order_screen_for_regular_meals.dart';
import 'order_screen_for_regular_offers.dart';
import 'dart:convert';

class SearchResults extends StatefulWidget {
  String searchQuery;
  String contact;
  SearchResults({required this.searchQuery, required this.contact});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  var mealsResponseBody;
  var offersRequestBody;
  //method for api call to the results from meals table
  Future getSearchResultsFromMeals() async {
    String url = "https://rokeats.000webhostapp.com/getMealSearchResults.php";
    var data = {
      'searchResults': widget.searchQuery,
    };
    var request = await http.post(Uri.parse(url), body: json.encode(data));
    mealsResponseBody = jsonDecode(request.body);
    print(mealsResponseBody.toString());
    return mealsResponseBody;
  }

  //method for the api call to the results from offers table
  Future getSearchResultsFromOffers() async {
    String url = "https://rokeats.000webhostapp.com/getOfferSearchResults.php";
    var data = {
      'searchResults': widget.searchQuery,
    };
    var request = await http.post(Uri.parse(url), body: json.encode(data));
    offersRequestBody = jsonDecode(request.body);
    print(offersRequestBody.toString());
    return offersRequestBody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Container(
        child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              offersResults(),
              mealsResults()
            ],
          ),
        ),
      ),
    );
  }

  Widget allResults() {
    return Material(
      elevation: 15.0,
      color: Colors.white,
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          offersResults(),
          SizedBox(height: 0.4,),
          mealsResults(),
        ],
      ),
    );
  }

//creator of the results from the offers table
  Widget offersResults() {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      child: FutureBuilder(
        future: getSearchResultsFromOffers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData == false) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(failedToLoadMeal,style: locationErrorStyle,),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          offersResults();
                        });
                      },
                      child: Text(failedToLoadMealActionText,style: locationActionTextStyle,))
                ],
              );
            } else {
              return AlertDialog(
                title: Text(failedToLoadMeal,style: locationErrorStyle,),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          offersResults();
                        });

                      },
                      child: Text(failedToLoadMealActionText,style: locationActionTextStyle,))
                ],
              );
            }
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snap.length,
              itemBuilder: (context, index) {
                return searchResultsFromOffers(
                    snap[index]['id'],
                    'https://rokeats.000webhostapp.com/pages/offer_images/${snap[index]['picture']}',
                    snap[index]['food_name'],
                    snap[index]['category'],
                    snap[index]['description'],
                    snap[index]['m_price'],
                    snap[index]['s_price'],
                    snap[index]['l_price'],
                    snap[index]['new_price'],
                    snap[index]['old_price'],
                    snap[index]['restaurant'],
                    snap[index]['lat'],
                    snap[index]['longitude']);
              });
        },
      ),
    );
  }
  //creator of the results from the meals table
  Widget mealsResults() {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      child: FutureBuilder(
        future: getSearchResultsFromMeals(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late List snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData == false) {
            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text(failedToLoadMeal,style: locationErrorStyle,),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          mealsResults();
                        });
                      },
                      child: Text(failedToLoadMealActionText,style: locationActionTextStyle,))
                ],
              );
            } else {
              return AlertDialog(
                title: Text(failedToLoadMeal,style: locationErrorStyle,),
                actions: [
                  FlatButton(
                      color: yellowColor,
                      onPressed: () {
                        setState(() {
                          mealsResults();
                        });

                      },
                      child: Text(failedToLoadMealActionText,style: locationActionTextStyle,))
                ],
              );
            }
          }
          return ListView.builder(
              itemCount: snap.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return searchResultsFromMeals(
                    snap[index]['id'],
                    'https://rokeats.000webhostapp.com/pages/images/${snap[index]['picture']}',
                    snap[index]['food_name'],
                    snap[index]['category'],
                    snap[index]['description'],
                    snap[index]['m_price'],
                    snap[index]['s_price'],
                    snap[index]['l_price'],
                    snap[index]['price'],
                    snap[index]['restaurant'],
                    snap[index]['lat'],
                    snap[index]['longitude']);
              });
        },
      ),
    );
  }

  //model for search results from the offers table
  Widget searchResultsFromOffers(
      String id,
      String link,
      String foodName,
      String category,
      String desc,
      var mPrice,
      var sPrice,
      var lPrice,
      var newPrice,
      var oldPrice,
      String restId,
      String lat,
      String longitude) {
    return GestureDetector(
      onTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await requestLocationDialog();
        } else {
          if (category != '4') {
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
                      contact: widget.contact,
                      restLongitude: '$longitude',
                      restLat: '$lat',
                      userLongitude: userLongitude,
                      userLatitude: userLatitude,
                    )));
          } else {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(
                builder: (context) => OrderScreenForRegularOffers(
                      description: '$desc',
                      foodName: '$foodName',
                      link: '$link',
                      restId: '$restId',
                      category: '$category',
                      mealId: '$id',
                      offerPrice: '$newPrice',
                      userContact: widget.contact,
                      restLongitude: '$longitude',
                      restLat: '$lat',
                      userLongitude: userLongitude,
                      userLatitude: userLatitude,
                      oldPrice: oldPrice,
                    )));
          }
        }
      },
      child: Card(
        color: yellowColor,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(link),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    foodName,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/2),
                  Text(
                    category != '4' ? mPrice.toString() : newPrice.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  //model for search results from the meals table
  Widget searchResultsFromMeals(
      String id,
      String link,
      String foodName,
      String category,
      String desc,
      var mPrice,
      var sPrice,
      var lPrice,
      var price,
      String restId,
      String lat,
      String longitude) {
    return GestureDetector(
      onTap: () async {
        if (await Geolocator.isLocationServiceEnabled() == false) {
          await requestLocationDialog();
        } else {
          if (category != '4') {
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
                      contact: widget.contact,
                      restLongitude: '$longitude',
                      restLat: '$lat',
                      userLongitude: userLongitude,
                      userLatitude: userLatitude,
                    )));
          } else {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(
                builder: (context) => OrderScreenForRegularMeals(
                      description: '$desc',
                      foodName: '$foodName',
                      link: '$link',
                      restId: '$restId',
                      category: '$category',
                      mealId: '$id',
                      price: '$price',
                      contact: widget.contact,
                      restLongitude: '$longitude',
                      restLat: '$lat',
                      userLongitude: userLongitude,
                      userLatitude: userLatitude,
                    )));
          }
        }
      },
      child: Card(
        color: yellowColor,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width / 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(link),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    foodName,
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/2),
                  Text(
                    category != '4' ? mPrice.toString() : price.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  //method to request for permission
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
