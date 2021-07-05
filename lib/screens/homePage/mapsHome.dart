import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:collection';
import 'package:flutter_app/constants.dart';
import 'homeView.dart';

class MapsHome extends StatefulWidget {
  @override
  _MapsHomeState createState() => _MapsHomeState();
}

class _MapsHomeState extends State<MapsHome>
    with AutomaticKeepAliveClientMixin<MapsHome> {
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor _markerIcon;
  void _setMarkerIcon() async {
    _markerIcon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(), mapPinIcon);
  }

  GoogleMapController mapController;
  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      allRestaurantDetails.forEach((e) {
        if (e.lon != "" || e.lat != "") {
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
        }
      });
    });
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

  void initState() {
    super.initState();
    _setMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height - 274,
          child: GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(allRestaurantDetails[0].lat),
                  double.parse(allRestaurantDetails[0].lon)),
              zoom: 15,
            ),
            buildingsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
