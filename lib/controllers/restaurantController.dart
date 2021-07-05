import 'package:flutter_app/models/cartModel.dart';
import 'package:flutter_app/models/wishListModel.dart';
import 'package:flutter_app/services/remoteServices.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_app/models/restaurantsModel.dart';

class RestaurantController extends GetxController {
  Rx<AllRestaurants> allRestaurants = AllRestaurants().obs;
  var isLoading = true.obs;
  Rx<GetWishList> allWishListItems = GetWishList().obs;
  Rx<CartModel> allCartItems = CartModel().obs;
  @override
  onInit() {
    fetchRestaurants();
    fetchWishList();
    fetchCart();
    super.onInit();
  }

  fetchWishList() async {
    try {
      isLoading(true);
      var wishList = await RemoteServices.fetchWishList();
      if (wishList != null) {
        allWishListItems.value = wishList;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchRestaurants() async {
    try {
      isLoading(true);
      var restaurants = await RemoteServices.fetchRestaurants();
      if (restaurants != null) {
        allRestaurants.value = restaurants;
      }
    } finally {
      isLoading(false);
    }
  }

  fetchCart() async {
    try {
      isLoading(true);
      var cart = await RemoteServices.fetchCart();
      if (cart != null) {
        allCartItems.value = cart;
      }
    } finally {
      isLoading(false);
    }
  }
}
