import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/credentials/signUpRelated/emailSignUp.dart';
import 'package:flutter_app/credentials/signUpRelated/signUpOptions.dart';
import 'package:flutter_app/dashBoard.dart';
import 'package:flutter_app/screens/profile/settings.dart';
import 'package:flutter_app/screens/profile/orderHistory.dart';
import 'package:flutter_app/screens/wishList.dart';
import 'package:flutter_app/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storedData = GetStorage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: currentUser?.image == null ||
                            currentUser?.image == "" ||
                            currentUser?.image ==
                                "https://fudigudi.ro/Fudigudi/uploads/images/"
                        ? Image.asset(
                            logo,
                            fit: BoxFit.fill,
                          )
                        : CachedNetworkImage(
                            imageUrl: currentUser?.image.toString()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentUser?.fname ?? "User Name",
                    style: titleTextStyle(),
                  ),
                ),
                Text(
                  currentUser?.location ?? "San Francisco, CA",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(EmailSignUp(
                        isSocial: false,isEdit:true,
                      ));
                    },
                    child: profileListTile(
                        title: "Edit Profile",
                        hasArrow: true,
                        leadingIcon: editProfileIcon)),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Favourites())),
                  child: profileListTile(
                      title: "Wishlist",
                      hasArrow: true,
                      leadingIcon: wishlistIcon),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderHistory())),
                  child: profileListTile(
                      title: "Order History",
                      hasArrow: true,
                      leadingIcon: orderHistoryIcon),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage())),
                  child: profileListTile(
                      title: "Settings",
                      hasArrow: true,
                      leadingIcon: notificationIcon),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      storedData.remove("userData");
                      storedData.write("isLoggedIn", false);
                      Get.offAll(SignUpOptions());
                    },
                    child: profileListTile(
                        title: "Log out",
                        hasArrow: false,
                        leadingIcon: logoutIcon)),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileListTile(
      {@required String title,
      @required String leadingIcon,
      @required bool hasArrow}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              leadingIcon,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            hasArrow
                ? Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightGreen,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
