import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yewwaf/constants.dart';
import 'package:yewwaf/screens/search_results.dart';
import 'home_screen.dart';
import 'google_maps_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'orders.dart';
import 'profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import for the new version check
import 'package:new_version/new_version.dart';

class Home extends StatelessWidget {
  //DECLARING A CONSTRUCTOR SO THAT WE CAN RECEIVE THE CONTACT FROM THE LOGIN SCREEN
  final String contact;
  Home({required this.contact});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //setting the home of the MaterialApp to the bottomMenu() class
      home: SafeArea(child: BottomMenu(contact: contact)),
    );
  }
}

class BottomMenu extends StatefulWidget {
  @override
  _BottomMenuState createState() => _BottomMenuState();
  final String contact;
  BottomMenu({required this.contact});
}

class _BottomMenuState extends State<BottomMenu> {
  TextEditingController searchResults = TextEditingController();
  //these are coordinates of the latitude and longitude of the user location
  late double latitude;
  late double longitude;

//method to get the position of the user
  getCurrentPosition() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = geoPosition.latitude;
      longitude = geoPosition.longitude;
    });
  }

  //we call the method to get the user location as soon as we initialise the app
  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    //getUserDetails();
    updateCoordinates();
    _checkVersion();
  }
  _checkVersion() async {
    final newVersion = NewVersion(
      androidId: 'com.codewithaguek.yewwaf',
      iOSId: 'com.codewithaguek.yewwaf'
    );
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'UPDATE',
        dialogText: 'Please update your app to the latest version.',
        dismissButtonText: 'Not Now',
        updateButtonText: 'Update',
        dismissAction: (){
          SystemNavigator.pop();
        }
      );
    }
  }

  int _selectedIndex = 0;
  //this method is to be used in the profilescreen for the details of the user, the user's contact is got on login in
  /*Future getUserDetails() async {
    String url = "https://rokeats.000webhostapp.com/getUserDetails.php";

    var data = {
      'contact': widget.contact,
    };
    //get the contact and then search the database and then respond
    var sendContact = await http.post(Uri.parse(url),body: json.encode(data));
    var responseBody = json.decode(sendContact.body);
    print(responseBody.toString());
  }*/
  //METHOD TO UPDATE THE COORDINATES OF THE USER
  Future updateCoordinates() async {
    //this is to get the location of the user.
    //couldn't access them from above because they were restricted. so i access them here
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    String url = "https://rokeats.000webhostapp.com/updateCoordinates.php";
    var bindData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'contact': widget.contact,
    };
    var updateCoordinate =
        await http.post(Uri.parse(url), body: json.encode(bindData));
    var responseBody = json.decode(updateCoordinate.body);
    print(responseBody.toString());

    return responseBody;
  }

//this method is meant to be used in the BottomNavigationBar on the onTap property to change the item that appears when an icon is
  //tapped. we assign the _selectedIndex the index from the method
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextStyle style = TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500);
  //method to contain the different screen headings, passed down to the app bar
  Widget screenHeading() {
    if (_selectedIndex == 2) {
      return Center(
          child: Text(
        'ORDERS',
        style: style,
      ));
    } else {
      return Center(
          child: Text(
        'PROFILE',
        style: style,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      HomeScreen(
        userContact: widget.contact,
      ),
      In_Transit(
        contact: widget.contact,
      ),
      Orders(
        contact: widget.contact,
      ),
      ProfileScreen(
        contact: widget.contact,
      ),
    ];
    return Scaffold(
            backgroundColor: homeColor,
            appBar: AppBar(
              toolbarHeight: _selectedIndex == 1 || _selectedIndex == 3? 0 : 55.0,
              backgroundColor: yellowColor,
              //am adding a ternary operation to check if the selectedIndex is less than 1, because i don't want the search bar to
              //be included in the orders, profile and settings page. The index screen is index 0, so it is less than 1.
              //then for those with index >=1, we pass a method called screenHeading, which contains the title of the screen
              title: _selectedIndex < 1
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Platform.isIOS
                          ? CupertinoSearchTextField(
                              backgroundColor: Colors.white,
                              controller: searchResults,
                              placeholder: 'Search for your favourite meals',
                              placeholderStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                              onSubmitted: (value) {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) => SearchResults(
                                              searchQuery: searchResults.text,
                                              contact: widget.contact,
                                            )));
                              },
                            )
                          : TextField(
                              controller: searchResults,
                              onSubmitted: (g) {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) => SearchResults(
                                              searchQuery: searchResults.text,
                                              contact: widget.contact,
                                            )));
                                // searchResults.clear();
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: yellowColor,
                                      width: 2.0,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.yellowAccent, width: 5.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search for your favourite meal',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: yellowColor,
                                ),
                              ),
                            ),
                    )
                  : screenHeading(),
            ),
            //CUPERTINO BOTTOM NAVIGATION WORKS FINE
            bottomNavigationBar: Platform.isIOS
                ? CupertinoTabScaffold(
                    //adding a bottom navigation for IOS phones
                    tabBar: CupertinoTabBar(
                      activeColor: yellowColor,
                      inactiveColor: Colors.black,
                      onTap: _onItemTapped,
                      currentIndex: _selectedIndex,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.house_fill),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.map_pin_ellipse),
                          label: 'Delivery',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.cart_fill),
                          label: 'Orders',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.person_fill),
                          label: 'Profile',
                        ),
                      ],
                    ),
                    tabBuilder: (BuildContext context, int index) {
                      return CupertinoTabView(
                        builder: (BuildContext context) {
                          return _widgetOptions.elementAt(_selectedIndex);
                        },
                      );
                    },
                  )
                :
                //bottom navigation for android phones
                BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home_filled,
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.two_wheeler_outlined),
                          label: 'Delivery'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart), label: 'Orders'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Profile'),
                    ],
                    selectedLabelStyle: TextStyle(
                        fontSize: 14.0,
                        color: yellowColor,
                        fontWeight: FontWeight.w700),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    currentIndex: _selectedIndex,
                    selectedItemColor: yellowColor,
                    elevation: 0.0,
                    onTap: _onItemTapped,
                    unselectedItemColor: Colors.black,
                    selectedFontSize: 14.0,
                    unselectedFontSize: 14.0,
                  ),
            //this is to get data from the list above, so that we can display something on the screen when an icon is tapped
            body: _widgetOptions.elementAt(_selectedIndex),
          );
  }
}
