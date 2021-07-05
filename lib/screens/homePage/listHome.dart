import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/controllers/restaurantController.dart';
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'package:flutter_app/screens/productDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/tools/loading.dart';
import 'homeView.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bot_toast/bot_toast.dart';

class ListHome extends StatefulWidget {
  @override
  _ListHomeState createState() => _ListHomeState();
}

class _ListHomeState extends State<ListHome>
    with AutomaticKeepAliveClientMixin<ListHome> {
  // final RestaurantController restaurantController = Get.find(tag: "restaurant");
  bool _isLoading = false;
  List<bool> isWishList = [];



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        List<bool> hasItem = [];
        hasItem.length = allRestaurantDetails.length;

        if (allRestaurantDetails[index].quantity == null ||
            allRestaurantDetails[index].quantity == "0") {
          hasItem[index] = false;
        }
        if (allRestaurantDetails[index].lat != "" ||
            allRestaurantDetails[index].lon != "") {
          double distance = Geolocator.distanceBetween(
              double.parse(currentUser.lat),
              double.parse(currentUser.lon),
              double.parse(allRestaurantDetails[index].lat),
              double.parse(allRestaurantDetails[index].lon));
          distance = distance / 1000;
        }
        isWishList.length = allRestaurantDetails.length;
        //print(wishListedItems[index].restaurantId);
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                        restaurantDetails: allRestaurantDetails[index],
                      ))),
          child: homeListTile(
            hasItem: true,
            isWishListed:allRestaurantDetails[index].isWishListed,
          index: index,
            imageUrl: allRestaurantDetails[index].restaurantImage,
            name: allRestaurantDetails[index].restaurantName,
            category: allRestaurantDetails[index].bagsName,
            itemLeft: allRestaurantDetails[index].quantity,
            pickupTime:
                "Pickup: ${allRestaurantDetails[index].startTime}-${allRestaurantDetails[index].endTime}",
            bagNumber: allRestaurantDetails[index].quantity,
            quantity: allRestaurantDetails[index].quantity,
            restaurantId: allRestaurantDetails[index].id,
            discountedPrice:
                "${allRestaurantDetails[index].afterDiscountAmount} LEI",
            originalPrice: "${allRestaurantDetails[index].amount} LEI",
            lat: allRestaurantDetails[index].lat,
            lon: allRestaurantDetails[index].lon,
          ),
        );
      },
      itemCount: allRestaurantDetails.length,
    );
  }

  homeListTile(
      {@required bool hasItem,
      @required name,
       @required bool isWishListed,
      String imageUrl,int index,
      @required String category,
      @required String itemLeft,
      @required String pickupTime,
      @required String restaurantId,
      @required String originalPrice,
      @required String discountedPrice,
      @required String lat,
      @required String lon,
      @required String quantity,
      String bagNumber,
      String comment}) {
    // bool hasItem = false;
    if (quantity == null || quantity == "0") {
      hasItem = false;
    }
    double distance;
    if (lat != "" || lon != "") {
      distance = Geolocator.distanceBetween(double.parse(currentUser.lat),
          double.parse(currentUser.lon), double.parse(lat), double.parse(lon));
      distance = distance / 1000;
    }
     isWishList[index] = false;
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: comment != null ? 145 : 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: bxShadow,
                color: hasItem ? Colors.white : Colors.grey.shade400),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      imageUrl != null
                          ? Hero(
                              tag: "$name-$imageUrl",
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // color: Colors.grey,
                                    // backgroundBlendMode: BlendMode.saturation,
                                    image: DecorationImage(
                                        colorFilter: hasItem
                                            ? null
                                            : ColorFilter.mode(Colors.grey,
                                                BlendMode.saturation),
                                        image: CachedNetworkImageProvider(
                                            imageUrl),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          : Image.asset(
                              foodImg,
                              fit: BoxFit.fill,
                              colorBlendMode: BlendMode.saturation,
                            ),
                      hasItem
                          ? Container()
                          : Positioned(
                              left: 25,
                              bottom: 50,
                              child: Image.asset(
                                logo,
                                height: 40,
                              ),
                            ),
                      Positioned(
                        bottom: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: hasItem ? Color(0xff8BC63C) : Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: hasItem
                                ? Text("$itemLeft Left")
                                : Text("Sold Out"),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: hasItem ? Color(0xff8BC63C) : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, bottom: 4.0, left: 8, right: 8),
                            child: Text(
                              distance != null
                                  ? "${distance.toInt()} Km"
                                  : "Not Mentioned",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.only(left: 15, top: 12, bottom: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 30,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    bagIcon,
                                    width: 28,
                                  ),
                                  bagNumber != null
                                      ? Positioned(
                                          right: 0,
                                          top: 1,
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xff019244),
                                            radius: 6,
                                            child: Text("$bagNumber",
                                                style: TextStyle(fontSize: 8)),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            StatefulBuilder(builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  // if (mounted) {
                                  //   setState(() {
                                  //     _isLoading = true;
                                  //   });
                                  // }
                                  var headers = {
                                    'Cookie':
                                        'ci_session=pn579uhpq0tvqk0lmc4irv1btsgjlkhg'
                                  };
                                  var request = http.MultipartRequest(
                                      'POST',
                                      Uri.parse(
                                          'https://fudigudi.ro/Fudigudi/webservice/add_wishlist'));
                                  String userId = currentUser?.id.toString();
                                  request.fields.addAll({
                                    'user_id': userId.toString(),
                                    'restaurant_id': restaurantId,
                                    "quantity": "$bagNumber",
                                    "amount": discountedPrice,
                                  });
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response =
                                      await request.send();

                                  if (response.statusCode == 200) {
                                    var res =
                                        await response.stream.bytesToString();
                                    if (res.contains("1")) {
                                      BotToast.showText(
                                          text: "Added To Favourites");

                                      state(() {
                                        isWishList[index] = true;
                                      });
                                    } else {
                                      BotToast.showText(
                                          text: "Removed From Favourites");

                                      state(() {
                                        isWishList[index] = false;
                                      });
                                    }
                                  } else {
                                    print(response.reasonPhrase);
                                  }
                                  // if (mounted) {
                                  //   setState(() {
                                  //     _isLoading = false;
                                  //   });
                                  // }
                                },
                                child: isWishList[index]
                                    ? Image.asset(
                                        heartCircleClickedIcon,
                                        height: 30,
                                      )
                                    : Image.asset(
                                        heartCircleUnClickedIcon,
                                        height: 30,
                                      ),
                              );
                            }),
                          ],
                        ),
                        Hero(
                          tag: "$name",
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color(0xff019244),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "$category",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w200),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          pickupTime,
                          style: TextStyle(
                            fontSize: 12,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$originalPrice",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      hasItem ? Color(0xff8BC63C) : Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "$discountedPrice",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        comment != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(comment),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.message,
                                    size: 25,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// class HomeListTile extends StatefulWidget {
//   final bool hasItem;
//   final String name;
//   final String imageUrl;
//   final String category;
//   final String itemLeft;
//   final String pickupTime;
//   final String restaurantId;
//   final String price;
//   final String lat;final String bagNumber;
//   final String lon;final String comment;
//   HomeListTile({        this.hasItem,
//     this.name,
//     //@required bool isWishListed,
//     this.imageUrl,
//     this.category,
//     this.itemLeft,
//     this.pickupTime,
//     this.restaurantId,
//     this.price,
//      this.lat,
//      this.lon,
//     this.bagNumber,
//     this.comment});
//   @override
//   _HomeListTileState createState() => _HomeListTileState();
// }
//
// class _HomeListTileState extends State<HomeListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           Container(
//             height: widget.comment != null ? 145 : 130,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: bxShadow,
//                 color: Colors.white),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       widget.imageUrl != null
//                           ? Hero(
//                         tag: "${widget.name}-${widget.imageUrl}",
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                   image: CachedNetworkImageProvider(
//                                       widget.imageUrl),
//                                   fit: BoxFit.cover)),
//                         ),
//                       )
//                           : Image.asset(
//                         foodImg,
//                         fit: BoxFit.fill,
//                       ),
//                       widget.hasItem
//                           ? Container()
//                           : Positioned(
//                         left: 25,
//                         bottom: 50,
//                         child: Image.asset(
//                           logo,
//                           height: 40,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 10,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: hasItem ? Color(0xff8BC63C) : Colors.grey,
//                               borderRadius: BorderRadius.circular(8)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: hasItem
//                                 ? Text("$itemLeft Left")
//                                 : Text("Sold Out"),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           top: 5,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.amber,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 4.0, bottom: 4.0, left: 8, right: 8),
//                               child: Text(
//                                 "${distance.toInt()} Km",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 7,
//                   child: Container(
//                     //width: MediaQuery.of(context).size.width,
//                     padding:
//                     EdgeInsets.only(left: 15, top: 12, bottom: 8, right: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 30,
//                               child: Stack(
//                                 children: [
//                                   Image.asset(
//                                     bagIcon,
//                                     width: 28,
//                                   ),
//                                   bagNumber != null
//                                       ? Positioned(
//                                     right: 0,
//                                     top: 1,
//                                     child: CircleAvatar(
//                                       backgroundColor: Color(0xff019244),
//                                       radius: 6,
//                                       child: Text("$bagNumber",
//                                           style: TextStyle(fontSize: 8)),
//                                     ),
//                                   )
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 // if (mounted) {
//                                 //   setState(() {
//                                 //     _isLoading = true;
//                                 //   });
//                                 // }
//                                 var headers = {
//                                   'Cookie':
//                                   'ci_session=pn579uhpq0tvqk0lmc4irv1btsgjlkhg'
//                                 };
//                                 var request = http.MultipartRequest(
//                                     'POST',
//                                     Uri.parse(
//                                         'https://fudigudi.ro/Fudigudi/webservice/add_wishlist'));
//                                 String userId = currentUser?.id.toString();
//                                 request.fields.addAll({
//                                   'user_id': userId.toString(),
//                                   'restaurant_id': restaurantId,
//                                   "quantity": "$bagNumber",
//                                   "amount": price,
//                                 });
//                                 request.headers.addAll(headers);
//
//                                 http.StreamedResponse response =
//                                 await request.send();
//
//                                 if (response.statusCode == 200) {
//                                   var res =
//                                   await response.stream.bytesToString();
//                                   if (res.contains("1")) {
//                                     BotToast.showText(
//                                         text: "Added To Wish List");
//
//                                     setState(() {
//                                       isWishList = true;
//                                     });
//                                   } else {
//                                     BotToast.showText(
//                                         text: "Removed From Wish List");
//
//                                     setState(() {
//                                       isWishList = false;
//                                     });
//                                   }
//                                 } else {
//                                   print(response.reasonPhrase);
//                                 }
//                                 // if (mounted) {
//                                 //   setState(() {
//                                 //     _isLoading = false;
//                                 //   });
//                                 // }
//                               },
//                               child: Image.asset(
//                                 isWishList
//                                     ? heartCircleClickedIcon
//                                     : heartCircleUnClickedIcon,
//                                 height: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Hero(
//                           tag: "$name",
//                           child: Text(
//                             name,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               color: Color(0xff019244),
//                               borderRadius: BorderRadius.circular(8)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Text(
//                               "$category",
//                               style: TextStyle(
//                                   fontSize: 10, fontWeight: FontWeight.w200),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           "Pickup: ${allRestaurantDetails[index].startTime}-${allRestaurantDetails[index].endTime}",
//                           style: TextStyle(
//                             fontSize: 12,
//                             //fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "60 LEI",
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.lineThrough,
//                                   decorationColor: Colors.black),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                   color:
//                                   hasItem ? Color(0xff8BC63C) : Colors.grey,
//                                   borderRadius: BorderRadius.circular(8)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   "${allRestaurantDetails[index].amount} LEI",
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         comment != null
//                             ? Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(comment),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Icon(
//                               Icons.message,
//                               size: 25,
//                             ),
//                           ],
//                         )
//                             : Container(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
