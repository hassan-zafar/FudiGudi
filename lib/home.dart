import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/homePage/homeView.dart';
import 'screens/Cart.dart';
import 'screens/Search.dart';
import 'screens/wishList.dart';
import 'screens/profile/profile.dart';
import 'package:flutter_app/models/userDataModel.dart';
import 'package:get_storage/get_storage.dart';

AppUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;
  final storedData = GetStorage();
  @override
  void initState() {
    getStoredUser();
    pageController = PageController();
    super.initState();
  }

  getStoredUser() {
    String userData = storedData.read("userData");
    print("string data" + userData);
    UserData user = userDataFromJson(userData);
    setState(() {
      currentUser = user.result;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
      // duration: Duration(milliseconds: 350),
      // curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          HomeView(),
          SearchPage(),
          CartPage(),
          Favourites(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      // floatingActionButton: Icon(Icons.shopping_basket),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex, onTap: onTap, color: Color(0xff8BC63C),
        buttonBackgroundColor: Color(0xff8BC63C),
        backgroundColor: Color(0xffDEEEFE),
        animationDuration: Duration(milliseconds: 300), height: 50,
        // currentIndex: pageIndex,
        // onTap: onTap,
        // backgroundColor: Colors.white,
        // activeColor: Colors.green,
        // inactiveColor: Colors.grey,
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_basket,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),

      // AnimatedBottomNavigationBar(
      //   icons: [
      //     Icons.home,
      //     Icons.search,
      //     Icons.favorite,
      //     Icons.person,
      //   ],
      //   leftCornerRadius: 32,
      //   rightCornerRadius: 32,
      //   inactiveColor: Colors.grey,
      //   activeColor: Colors.green,
      //   activeIndex: pageIndex,
      //   gapLocation: GapLocation.center,
      //   notchSmoothness: NotchSmoothness.verySmoothEdge,
      //   onTap: onPageChanged,
      //   //other params
      // ),
    );
  }
}
