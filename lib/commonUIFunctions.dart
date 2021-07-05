import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import "package:flutter_app/credentials/loginRelated/login.dart";
import "package:flutter_app/credentials/signUpRelated/signUpOptions.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

TextStyle homePageTextStyle({
  bool isClicked = false,
}) {
  return TextStyle(
      fontSize: isClicked ? 25 : 18,
      fontWeight: isClicked ? FontWeight.bold : FontWeight.w200);
}

Widget filterTextWidget(String filterText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Try: $filterText",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    ),
  );
}

Container smallPositionedColored(
    {var color = Colors.green, @required String text}) {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 6.0, bottom: 6, right: 12, left: 12),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));
}

commonListTile(
    {@required bool hasItem,
    @required name,
    @required bool isWishList,
    String imageUrl,
    @required String category,
    @required String itemLeft,
    @required String pickupTime,
    @required String restaurantId,
    @required String price,
    int bagNumber,
    String comment}) {
  if (bagNumber == 0) {
    hasItem = false;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          height: comment != null ? 145 : 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: bxShadow,
              color: Colors.white),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    imageUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(imageUrl,
                                        errorListener: () => Icon(Icons.error)),
                                    fit: BoxFit.cover)),
                          )
                        : Image.asset(
                            foodImg,
                            fit: BoxFit.fill,
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
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff019244),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("$category"),
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
                        children: [
                          Text(
                            "Bags",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
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
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              price,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      comment != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Positioned(
          right: 2,
          child: InkWell(
            onTap: () async {
              // if (mounted) {
              //   setState(() {
              //     _isLoading = true;
              //   });
              // }
              var headers = {
                'Cookie': 'ci_session=pn579uhpq0tvqk0lmc4irv1btsgjlkhg'
              };
              var request = http.MultipartRequest(
                  'POST',
                  Uri.parse(
                      'https://fudigudi.ro/Fudigudi/webservice/add_wishlist'));
              String userId = currentUser?.id.toString();
              request.fields.addAll({
                'user_id': userId.toString(),
                'restaurant_id': restaurantId,
              });
              request.headers.addAll(headers);

              http.StreamedResponse response = await request.send();

              if (response.statusCode == 200) {
                print(await response.stream.bytesToString());
                BotToast.showText(text: "Added To WishList");
              } else {
                print(response.reasonPhrase);
              }

              // if (mounted) {
              //   setState(() {
              //     _isLoading = false;
              //   });
              // }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                isWishList ? heartCircleClickedIcon : heartCircleUnClickedIcon,
                height: 30,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

List<BoxShadow> bxShadow = [
  BoxShadow(
      color: Colors.grey.shade600,
      spreadRadius: 0.3,
      blurRadius: 8,
      offset: Offset(4, 4)),
  BoxShadow(
      color: Colors.white,
      spreadRadius: 0.5,
      blurRadius: 5,
      offset: Offset(-4, -4)),
];
buildSignUpLoginButton(
    {@required BuildContext context,
    @required String btnText,
    String assetImage,
    bool hasIcon = false,
    double fontSize = 20,
    Color color = Colors.white,
    double leftRightPadding = 20.0,
    textColor = Colors.black}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color,
      ),
      child: hasIcon
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  child: Image.asset(
                    assetImage,
                    height: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    btnText,
                    style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  btnText,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    ),
  );
}

// buildSearchBar(){
//   return                ListView(
//   children: <Widget>[
//   Container(
//   decoration: BoxDecoration(
//   color: primary,
//   borderRadius: BorderRadius.only(
//   bottomRight: Radius.circular(20),
//   bottomLeft: Radius.circular(20))),
//   child: Padding(
//   padding: const EdgeInsets.only(
//   top: 8, left: 8, right: 8, bottom: 10),
//   child: Container(
//   decoration: BoxDecoration(
//   color: white,
//   borderRadius: BorderRadius.circular(20),
//   ),
//   child: ListTile(
//   leading: Icon(
//   Icons.search,
//   color: red,
//   ),
//   title: TextField(
//   textInputAction: TextInputAction.search,
//   onSubmitted: (pattern)async{
//   app.changeLoading();
//   if(app.search == SearchBy.PRODUCTS){
//   await productProvider.search(productName: pattern);
//   changeScreen(context, ProductSearchScreen());
//   }else{
//   await restaurantProvider.search(name: pattern);
//   changeScreen(context, RestaurantsSearchScreen());
//   }
//   app.changeLoading();
//   },
//   decoration: InputDecoration(
//   hintText: "Find food and restaurant",
//   border: InputBorder.none,
//   ),
//   ),
//   ),
//   ),
//   ),
//   ),
// ]);
//   }
buildSignUpLoginText(
    {@required BuildContext context,
    @required String text1,
    @required String text2,
    @required bool moveToLogIn}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        moveToLogIn ? LoginPage() : SignUpOptions())),
            child: Text(
              text2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      )
      // RichText(
      //   text: TextSpan(
      //       text: "Already have an account? ",
      //       style: TextStyle(fontSize: 15.0, color: Colors.black),
      //       children: [
      //         TextSpan(
      //           text: 'Log In',
      //           style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 18.0,
      //               fontStyle: FontStyle.italic),recognizer: _gestureRecognizer
      //         ),
      //       ]),
      // ),
      );
}
