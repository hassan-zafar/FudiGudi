import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/controllers/restaurantController.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'package:flutter_app/services/remoteServices.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'filters.dart';
import 'listHome.dart';
import 'mapsHome.dart';
import 'notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:flutter_app/tools/loading.dart';
import 'package:flutter_app/bindings/bindings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

List<RestaurantDetails> allRestaurantDetails;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

enum HomePages { list, map, filters }

class _HomeViewState extends State<HomeView> {
  String type = HomePages.list.toString();
  bool _isLoading = false;
  // final RestaurantController restaurantController =
  //     Get.put(RestaurantController(), tag: "restaurant");
  final storedData = GetStorage();
  List<WishListItemDetails> wishListedItems;

  void initState() {
    super.initState();
    getRestaurants();
  }

  getWishList() {
    final String favourites = storedData.read("favourites");
    GetWishList allWishListedItems = getWishListFromJson(favourites);
    wishListedItems = allWishListedItems.result;
    wishListedItems.forEach((e) {
      allRestaurantDetails.forEach((x) {
        if (x.id == e.restaurantId) {
          x.isWishListed = true;
        } else {
          x.isWishListed = false;
        }
      });
    });
  }

  // getRestaurants() async {
  //   try {
  //     setState(() {_isLoading=true;});
  //     var allRestaurants = await RemoteServices.fetchRestaurants();
  //     if (allRestaurants != null) {
  //       allRestaurantDetails = allRestaurants;
  //     }
  //   } finally {
  //     setState(() {_isLoading=true;});
  //   }
  //   setState(() {
  //     allRestaurantDetails = restaurantController.allRestaurants.value.result;
  //   });
  //   print(allRestaurantDetails);
  // }

  getRestaurants() async {
    setState(() {
      _isLoading = true;
    });
    var headers = {'Cookie': 'ci_session=3450bgp7rkdu2ioq9opngq89g3df0nme'};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_restaurant'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStr = await response.stream.bytesToString();
      print(responseStr);
      AllRestaurants allRestaurantsApiResponse =
          allRestaurantsFromJson(responseStr);
      setState(() {
        allRestaurantDetails = allRestaurantsApiResponse.result;
      });
      getWishList();
      setState(() {
        _isLoading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 160, left: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                print(HomePages.list);
                                setState(() {
                                  type = HomePages.list.toString();
                                });
                              },
                              child: Text(
                                "List",
                                style: homePageTextStyle(
                                    isClicked:
                                        type == HomePages.list.toString()),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                print(HomePages.map);
                                setState(() {
                                  type = HomePages.map.toString();
                                });
                              },
                              child: Text(
                                "Map",
                                style: homePageTextStyle(
                                    isClicked:
                                        type == HomePages.map.toString()),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                print(HomePages.filters);
                                setState(() {
                                  type = HomePages.filters.toString();
                                });
                              },
                              child: Text(
                                "Filters",
                                style: homePageTextStyle(
                                    isClicked:
                                        type == HomePages.filters.toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: bxShadow,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  locationIcon,
                                  height: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: AutoSizeText(
                                    currentUser?.location ??
                                        "557 Clinton Ave, Newark, Nj 07108, United States",
                                    maxLines: 2,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    maxFontSize: 15,
                                    minFontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  dropIcon,
                                  height: 12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationsPage())),
                                      child: Image.asset(
                                        bellIcon,
                                        height: 30,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: CircleAvatar(
                                        radius: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "1",
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Container(
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
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search",
                                        contentPadding: EdgeInsets.all(4),
                                        filled: false,
                                        isDense: false,
                                        //fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: type == HomePages.list.toString()
                      ? _isLoading
                          ? bouncingGridProgress()
                          : ListHome()
                      : type == HomePages.filters.toString()
                          ? _isLoading
                              ? bouncingGridProgress()
                              : Filters()
                          : _isLoading
                              ? bouncingGridProgress()
                              : MapsHome(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
