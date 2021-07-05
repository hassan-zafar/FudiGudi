import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'homePage/homeView.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), customMarkerIcon);
  }

  GoogleMapController mapController;
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      allRestaurantDetails.forEach((e) {
        _markers.add(
          Marker(
            markerId: MarkerId(e.id),
            position: LatLng(double.parse(e.lat), double.parse(e.lon)),
            infoWindow: InfoWindow(
              title: e.restaurantName,
              snippet: e.restaurantAddress,
            ),
            icon: _markerIcon,
          ),
        );
      });
    });
    // setState(() {
    //   mapController = controller;
    //   setState(() {
    //     _markers.add(
    //       Marker(
    //           markerId: MarkerId("0"),
    //           position: LatLng(40.7128, -74.0060),
    //           infoWindow: InfoWindow(
    //             title: "New York",
    //             snippet: "An Interesting city",
    //           ),
    //           icon: _markerIcon),
    //     );
    //   });
    // });
  }

  getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (result) => mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(result.latitude, result.longitude),
            zoom: 15,
          ),
        ),
      ),
    );
  }

  searchAndNavigate(String searchAdr) {
    locationFromAddress(searchAdr).then(
      (result) => mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(result[0].latitude, result[0].longitude),
            zoom: 15,
          ),
        ),
      ),
    );
  }

  String searchAdr;
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon;
  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Choose a Location\nto See what's available",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: titleTextStyle(fontSize: 23),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    contentPadding: EdgeInsets.all(4),
                                    filled: false,
                                    isDense: false,
                                    //fillColor: Colors.white,
                                  ),
                                  onSubmitted: searchAndNavigate,
                                  onChanged: (val) {
                                    setState(() {
                                      searchAdr = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: getUserLocation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              compassIcon,
                              height: 20,
                            ),
                            Text(
                              " Use my current location",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        onMapCreated: onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(allRestaurantDetails[0].lat),
                              double.parse(allRestaurantDetails[0].lon)),
                          zoom: 15,
                        ),
                        buildingsEnabled: true,
                        markers: _markers,
                        indoorViewEnabled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
