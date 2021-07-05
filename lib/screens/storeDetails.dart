import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoreDetails extends StatefulWidget {
  final RestaurantDetails restaurantDetails;
  StoreDetails({@required this.restaurantDetails});
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  Set<Marker> _markers = HashSet<Marker>();
   BitmapDescriptor _markerIcon;
  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), customFoodMarkerIcon);
  }

  GoogleMapController mapController;
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId("0"),
            position: LatLng(double.parse(widget.restaurantDetails.lat),
                double.parse(widget.restaurantDetails.lon)),
            infoWindow: InfoWindow(
              title: widget.restaurantDetails.restaurantName,
              snippet: widget.restaurantDetails.restaurantAddress,
            ),
            icon: _markerIcon,
          ),
        );
      });
    });
  }

  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantDetails _restaurantDetails = widget.restaurantDetails;
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 220,
                      width: double.maxFinite,
                      child: CachedNetworkImage(
                        imageUrl: _restaurantDetails.restaurantImage,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      height: 220,
                      color: Colors.white70,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              _restaurantDetails.restaurantImage,
                            ),
                            radius: 50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _restaurantDetails.restaurantName,
                            style: titleTextStyle(fontSize: 28),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Surprise bags from This Store",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 250,
                                child: CachedNetworkImage(
                                  imageUrl: _restaurantDetails.restaurantImage,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Backlounge - Pankow",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 12),
                                      child: Text(
                                        "Today Pickup: 10:30am-11:00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 250,
                                child: CachedNetworkImage(
                                  imageUrl: _restaurantDetails.restaurantImage,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Backlounge - Pankow",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 12),
                                      child: Text(
                                        "Today Pickup: 10:30am-11:00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "How To Get There",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 200,
                    child: GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(_restaurantDetails.lat),
                            double.parse(_restaurantDetails.lon)),
                        zoom: 15,
                      ),
                      buildingsEnabled: false,
                      mapToolbarEnabled: false,
                      markers: _markers,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
