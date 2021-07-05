import 'package:flutter_app/home.dart';
import 'package:flutter_app/models/cartModel.dart';
import 'package:flutter_app/models/restaurantsModel.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'package:flutter_app/screens/homePage/homeView.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static var client = http.Client();
  static Future<AllRestaurants> fetchRestaurants() async {
    var headers = {'Cookie': 'ci_session=3450bgp7rkdu2ioq9opngq89g3df0nme'};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_restaurant'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStr = await response.stream.bytesToString();
      print(responseStr);
      return allRestaurantsFromJson(responseStr);
    } else {
      return null;
    }
  }

  static Future<GetWishList> fetchWishList() async {
    var headers = {'Cookie': 'ci_session=5qtslblidgdpoe5d462ijnvp1p07l1s4'};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_wish_list'));
    request.headers.addAll(headers);
    request.fields.addAll({
      'user_id': currentUser.id,
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStr = await response.stream.bytesToString();
      return getWishListFromJson(responseStr);
    } else {
      return null;
    }
  }

  static Future<CartModel> fetchCart() async {
    var headers = {'Cookie': 'ci_session=olpp85vs94mn7bpe7u7avh9uci4h5q43'};
    var userId = currentUser?.id;
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_cart'));
    request.fields.addAll({'user_id': userId.toString()});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseStream = await response.stream.bytesToString();
      return cartModelFromJson(responseStream);
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }
}
