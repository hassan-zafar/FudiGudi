import 'package:flutter/material.dart';

String logo = "assets/images/logo.png";
String googleLogo = "assets/images/google.png";
String facebookLogo = "assets/images/facebook.png";
String emailIcon = "assets/images/email.png";
String forgetPassPageIcon = "assets/images/MaskGroup1.png";
String plusIcon = "assets/images/plus.png";
String minusIcon = "assets/images/minus.png";
String deleteIcon = "assets/images/Icon_Delete.png";
String bagIcon = "assets/images/bag.png";
String heartIcon = "assets/images/ic_wishlist.png";
String locationIcon = "assets/images/location.png";
String dropIcon = "assets/images/drop.png";
String bellIcon = "assets/images/bell.png";
String foodImg = "assets/images/foodImg.png";
String backIcon = "assets/images/icons-back.png";
String editProfileIcon = "assets/images/editProfile.png";
String notificationIcon = "assets/images/Notifications.png";
String logoutIcon = "assets/images/logOut.png";
String wishlistIcon = "assets/images/Wishlist.png";
String orderHistoryIcon = "assets/images/orderHistory.png";
String heartCircleClickedIcon = "assets/images/heart_circ_clicked.png";
String heartCircleUnClickedIcon = "assets/images/heart_circ_grey.png";
String compassIcon = "assets/images/compass.png";
String cartIcon = "assets/images/cart.png";
String foodImg2 = "assets/images/foodImg2.png";
String backFilledIcon = "assets/images/back.png";
String back1Icon = "assets/images/back1.png";
String foodImgRound = "assets/images/foodImgRound.png";
String customMarkerIcon = "assets/images/customMarker.png";
String customFoodMarkerIcon = "assets/images/customFoodMarker.png";
String mapPinIcon = "assets/images/map_pin.png";

TextStyle titleTextStyle({double fontSize = 25, Color color = Colors.black}) {
  return TextStyle(
      fontSize: fontSize, fontWeight: FontWeight.bold, color: color);
}

BoxDecoration backgroundColorBoxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xffDEEEFE),
        Color(0xffFDFEFF),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  );
}
