import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/controllers/restaurantController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/cartModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/tools/loading.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartDetails> allCartData = [];
  double totalPrice;
  bool _isLoading = false;
  //final RestaurantController cartController = Get.find(tag: "restaurant");
  getCart() async {
    setState(() {
      _isLoading = true;
    });
    // var headers = {'Cookie': 'ci_session=olpp85vs94mn7bpe7u7avh9uci4h5q43'};
    var userId = currentUser?.id;
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_cart'));
    request.fields.addAll({'user_id': userId.toString()});

    //request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStream = await response.stream.bytesToString();
      if (responseStream.contains("unsuccessful")) {
        setState(() {
          _isLoading = false;
        });
      } else {
        CartModel cartResponse = cartModelFromJson(responseStream);
        print(cartResponse.result);
        setState(() {
          allCartData = cartResponse.result;
          allCartData.forEach((e) {
            totalPrice = double.parse(e.amount);
          });
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
  void initState() {
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: backgroundColorBoxDecoration(),
          child: _isLoading
              ? bouncingGridProgress()
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "My Cart",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    allCartData.isNotEmpty
                        ? ListView.builder(
                            itemCount: allCartData.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return cartItem(
                                  restaurantName:
                                      allCartData[index].restaurantName,
                                  category: allCartData[index].bagsName,
                                  context: context,
                                  price: allCartData[index].amount,
                                  quantityFromApi:
                                      int.parse(allCartData[index].quantity),
                                  imageUrl: allCartData[index].imageUrl);
                            })
                        : Padding(
                            padding: const EdgeInsets.only(top: 120.0),
                            child: Center(
                              child: Text(
                                "cart is Empty",
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                    // Obx(
                    //   () => cartController.isLoading.value == true
                    //       ? bouncingGridProgress()
                    //       :
                    // ),
                  ],
                ),
        ),
        bottomSheet: allCartData.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 15)],
                    color: Colors.white),
                height: 210,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, top: 20, bottom: 12),
                      child: Text(
                        "Totals",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    bottomSheetItem(text: "Sub Total", price: "$totalPrice"),
                    bottomSheetItem(text: "Shipping", price: "0"),
                    Center(
                      child: buildSignUpLoginButton(
                        hasIcon: false,
                        leftRightPadding: 10.0,
                        context: context,
                        fontSize: 13,
                        color: Colors.green,
                        btnText: "CHECKOUT",
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }

  int quantity = 1;
  Widget cartItem({
    @required BuildContext context,
    @required String restaurantName,
    @required String category,
    @required String price,
    @required String imageUrl,
    @required int quantityFromApi,
  }) {
    double itemPrice = double.parse(price) * quantity;
    return Padding(
      padding:
          const EdgeInsets.only(left: 40.0, right: 20, top: 20, bottom: 20),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: bxShadow,
                color: Colors.white),
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 120, top: 8, bottom: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(category),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "$itemPrice",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (quantity > 0) {
                              quantity = quantity - 1;
                              totalPrice = double.parse(price) * quantity;
                            }
                          });
                          print(quantity);
                        },
                        child: Image.asset(
                          minusIcon,
                          height: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("$quantity"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            quantity = quantity + 1;
                            totalPrice = double.parse(price) * quantity;
                          });
                          print(quantity);
                        },
                        child: Image.asset(
                          plusIcon,
                          height: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                deleteIcon,
                height: 20,
              ),
            ),
          ),
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                  boxShadow: bxShadow),
              height: 90,
              width: 90,
              child: imageUrl == null
                  ? Image.asset(foodImg2)
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(imageUrl),
                            fit: BoxFit.fill),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bottomSheetItem({@required String text, @required String price}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        top: 10,
        bottom: 8,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 18),
          ),
          Text(
            "--------------------",
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
          ),
          Text(
            "$price LEI",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
