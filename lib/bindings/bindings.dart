import 'package:flutter_app/controllers/restaurantController.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    final RestaurantController restaurantController =
      Get.put(RestaurantController());
  }
}