import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/controllers/restaurantController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'homePage/homeView.dart';
import 'productDetails.dart';
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:flutter_app/tools/loading.dart';
import 'package:get_storage/get_storage.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  bool _isLoading = false;
  final favouritesStorage = GetStorage();
  List<WishListItemDetails> _allWishListRestaurants = [];
  //final RestaurantController wishListController = Get.find(tag: "restaurant");
  @override
  void initState() {
    super.initState();
    //getRestaurants();
    getFavourites();
  }

  // getRestaurants() async {
  //   var awli = wishListController.allWishListItems.value.result;
  //   awli.forEach((x) {
  //     allRestaurantDetails.forEach((e) {
  //       if (x.restaurantId == e.id) allWishListRestaurants.add(e);
  //     });
  //   });
  //   setState(() {});
  // }
  getFavourites() async {
    String storedFavourites = favouritesStorage.read("favourites");
    if (storedFavourites != null &&
        !storedFavourites.contains("unsuccessful")) {
      GetWishList wishListResponse = getWishListFromJson(storedFavourites);
      _allWishListRestaurants = wishListResponse.result;
    } else {
      setState(() {
        _isLoading = true;
      });
    }
    //  var headers = {'Cookie': 'ci_session=5qtslblidgdpoe5d462ijnvp1p07l1s4'};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_wish_list'));
    String userId = currentUser?.id.toString();
    request.fields.addAll({
      'user_id': userId.toString(),
    });

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String futureResponseBody = await response.stream.bytesToString();
      if (!futureResponseBody.contains("unsuccessful")) {
        favouritesStorage.write("favourites", futureResponseBody);
        GetWishList wishListResponse = getWishListFromJson(futureResponseBody);
        setState(() {
          _allWishListRestaurants = wishListResponse.result;
        });
      }
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            // leading: Image.asset(backIcon),
            title: Text(
              "Favourites",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            ),
          ),
          body: _isLoading
              ? bouncingGridProgress()
              : _allWishListRestaurants.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: commonListTile(
                              hasItem: true,
                              isWishList: true,
                              imageUrl: _allWishListRestaurants[index].image,
                              name:
                                  _allWishListRestaurants[index].restaurantName,
                              category: _allWishListRestaurants[index].bagsName,
                              itemLeft: _allWishListRestaurants[index].quantity,
                              pickupTime:
                                  "Pickup: ${_allWishListRestaurants[index].startTime}-${_allWishListRestaurants[index].endTime}",
                              bagNumber: int.parse(
                                  _allWishListRestaurants[index].quantity),
                              restaurantId: _allWishListRestaurants[index].id,
                              price:
                                  "${_allWishListRestaurants[index].amount} LEI"),
                        );
                      },
                      itemCount: _allWishListRestaurants.length,
                    )
                  : Center(
                      child: Text("Favourites List is Empty"),
                    ),
        ),
      ),
    );
  }
  //
  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
