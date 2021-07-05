import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/orderHistoryModel.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/tools/loading.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<OrderHistoryDetails> orderHistoryAll = [];
  List<OrderHistoryDetails> activeOrders = [];
  List<OrderHistoryDetails> pastOrders = [];
  bool _isLoading = false;
  bool isActive = true;
  //bool isPast = false;
  final storedOrderHistory = GetStorage();

  getOrders() async {
    String storedOrders = storedOrderHistory.read("allOrders");

    if (storedOrders != null)
      separateActivePastOrders(storedOrders);
    else {
      setState(() {
        _isLoading = true;
      });
    }
    //var headers = {'Cookie': 'ci_session=48814qhtp0hu2tujsfobq11d7dutndq8'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://fudigudi.ro/Fudigudi/webservice/get_my_order?user_id=${currentUser.id}'));

    //request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print(res);
      if (res.contains("successful")) {
        setState(() {
          storedOrderHistory.remove("allOrders");
          storedOrderHistory.write("allOrders", res);
          separateActivePastOrders(res);
          _isLoading = false;
        });
      }
    } else {
      print(response.reasonPhrase);
    }

    //separateActivePastOrders(storedOrderHistory.read("allOrders"));
  }

  separateActivePastOrders(String storedOrders) {
    AllOrders allOrders = allOrdersFromJson(storedOrders);
    orderHistoryAll = allOrders.result;
    activeOrders = [];
    pastOrders = [];
    orderHistoryAll.forEach((e) {
      if (e.status == "pending") {
        activeOrders.add(e);
      } else {
        pastOrders.add(e);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOrders();
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
            //automaticallyImplyLeading: false,
            centerTitle: true,
            // leading: Image.asset(
            //   backIcon,
            //   height: 5,
            // ),
            title: Text(
              "Order History",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isActive = true;
                        });
                      },
                      child: Text(
                        "Active Order",
                        style: TextStyle(
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.w100,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isActive = false;
                        });
                      },
                      child: Text(
                        "Past Order",
                        style: TextStyle(
                          fontWeight:
                              isActive ? FontWeight.w100 : FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? bouncingGridProgress()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return isActive
                            ? commonListTile(
                                imageUrl: activeOrders[index].restaurantImage,
                                hasItem: true,
                                name: activeOrders[index].restaurantName,
                                isWishList: false,
                                category: activeOrders[index].id,
                                itemLeft: activeOrders[index].cartId,
                                pickupTime: "${activeOrders[index].orderDate}",
                                restaurantId: activeOrders[index].restaurantId,
                                price: activeOrders[index].totalAmount)
                            : commonListTile(
                                imageUrl: pastOrders[index].restaurantImage,
                                hasItem: true,
                                name: pastOrders[index].restaurantName,
                                isWishList: false,
                                category: pastOrders[index].id,
                                itemLeft: pastOrders[index].cartId,
                                pickupTime: "${pastOrders[index].orderDate}",
                                restaurantId: pastOrders[index].restaurantId,
                                price: pastOrders[index].totalAmount);
                      },
                      itemCount:
                          isActive ? activeOrders.length : pastOrders.length),
            ],
          ),
        ),
      ),
    );
  }
}
