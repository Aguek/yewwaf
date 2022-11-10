import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yewwaf/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:yewwaf/screens/order_screen.dart';

class In_Transit extends StatefulWidget {
  final String contact;
  In_Transit({required this.contact});
  @override
  _In_TransitState createState() => _In_TransitState();
}

class _In_TransitState extends State<In_Transit> {
  TextStyle tabStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w900);

  @override
  Widget build(BuildContext context) {
    return MyLocation(
      contact: widget.contact,
    );
  }
}

//this is a class that will hold the location of the user, and track the location of the of rider,

class MyLocation extends StatefulWidget {
  final String contact;
  MyLocation({required this.contact});

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
//we get the user's location use the Geolocator.getCurrentPosition() method which gets the location of the user
  double userLatitude = 0.0;
  double userLongitude = 0.0;
  double riderLatitude = 0.2996;
  double riderLongitude = 32.5964;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
//this variable is going to be based on the orders from the database, if there is any order for this customer, then we
  //store it in isThereAnyOrder variable, if there isn't, then i leave it like that

  var webMessage,lat, longitude, riderName, photo,contact;
  Future seeIfThereIsOrder() async {
    String url = "https://rokeats.000webhostapp.com/seeIfClientHasOrders.php";
    var request = await http.post(Uri.parse(url),
        body: json.encode({'contact': widget.contact}));
    //saving the response as a list so that we can easily get the values
    List response = jsonDecode(request.body);
//we set the lat, and longitude values to the key values of the response
    setState(() {
      webMessage = response.toString();
      lat = response[0]['latitude'];
      longitude = response[0]['longitude'];
      riderName = response[0]['name'];
      photo = response[0]['photo'];
      contact = response[0]['contact'];
    });
    print(response.toString());
    return response;
  }

  getCurrentPosition() async {
    Position geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 1000));

    //in this setState method, i have to determine if there is an order by checking to see if isThereAnyOrder is greater than 0,
    //if yes, then i animate the googleMaps camera to the rider's location, if there isn't then the camera will be animated to the
    //customers location
    //we then call this method in the initState
    setState(() async {
      userLatitude = geoPosition.latitude;
      userLongitude = geoPosition.longitude;
      //this mapcontroller.animatecamera is to make sure that the user is taken to his location as soon as the map loads.
      await Future.delayed(Duration(seconds: 2));
      if (lat == null && longitude == null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(userLatitude, userLongitude), zoom: 20.0)));
      } else {
        // am making a delay so that the rider's coordinates can be got from the db
        await Future.delayed(Duration(seconds: 2));
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                //checking if the coordinates aint recieved, if not, then we return the
                //coordinates of konyokonyo
                target: LatLng(lat != null ? double.parse(lat) : 4.8342,
                    longitude != null ? double.parse(longitude) : 31.6085),
                zoom: 20.0),
          ),
        );
        //we show a popup with the details of the delivery guy
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Expanded(
                child: Container(
                  color: yellowColor,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top:8.0),
                          child: CircleAvatar(
                            radius: 40.0,
                              foregroundImage: NetworkImage('https://rokeats.000webhostapp.com/rider_images/$photo',),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            title: Text(riderName,style: textStyle,),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            title: Text("+211 $contact",style: textStyle,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    });
  }

//am creating a method to keep the markers of the positions of the customer and rider.

  Set<Marker> setMarkers() {
    setState(() {
      Marker userMarker = Marker(
        markerId: MarkerId('userlocation'),
        position: LatLng(userLatitude, userLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(50.0),
        infoWindow: InfoWindow(title: 'My location.'),
      );
      Marker riderMarker = Marker(
        markerId: MarkerId('riderlocation'),
        //setting the marker to the rider's coordinates from the db
        //if they are null, we set the marker to konyokonyo mkt
        position: LatLng(lat != null ? double.parse(lat) : 4.8342,
            longitude != null ? double.parse(longitude) : 31.6085),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'Delivery Guy\'s location.'),
      );

      markers.add(userMarker);
      markers.add(riderMarker);
    });

    return markers;
  }

  @override
  void initState() {
    seeIfThereIsOrder();
    getCurrentPosition();
    setMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(userLatitude, userLongitude),
      zoom: 21.5,
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        markers: setMarkers(),
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(userLatitude, userLongitude),
                        zoom: 18.0),
                  ),
                );
              },
              child: Icon(
                Icons.center_focus_strong,
                color: Colors.black,
              ),
              backgroundColor: yellowColor,
            ),
            //adding custom buttons for location, zoom in and out because ios doesn't use the default icons
            TextButton(
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.zoomIn(),
                );
              },
              child: Icon(
                Icons.add_circle_outlined,
                size: 40.0,
              ),
            ),
            //Text('$distance KM'),
            TextButton(
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.zoomOut(),
                );
              },
              child: Icon(
                Icons.remove_circle_outlined,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

/*_addPolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: yellowColor,
      width: 7,
    );
    polylines[id] = polyline;
    setState(() {
      _addPolyline(polylineCoordinates);
    });
  }

   _getPolyline()  async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(userLatitude, userLongitude),
        PointLatLng(riderLatitude, riderLongitude),
        travelMode: TravelMode.driving);
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyline(polylineCoordinates);


  }*/
}
//TODO 5: EDIT THE MODELMODALSHEET TO SHOW THE RIDER DETAILS TO THE USER
/*showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              );*/
