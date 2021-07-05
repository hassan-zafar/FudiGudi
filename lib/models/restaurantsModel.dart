// To parse this JSON data, do
//
//     final allRestaurants = allRestaurantsFromJson(jsonString);

import 'dart:convert';

AllRestaurants allRestaurantsFromJson(String str) =>
    AllRestaurants.fromJson(json.decode(str));

String allRestaurantsToJson(AllRestaurants data) => json.encode(data.toJson());

class AllRestaurants {
  AllRestaurants({
    this.result,
    this.message,
    this.status,
  });

  List<RestaurantDetails> result;
  String message;
  String status;

  factory AllRestaurants.fromJson(Map<String, dynamic> json) => AllRestaurants(
        result: List<RestaurantDetails>.from(
            json["result"].map((x) => RestaurantDetails.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

// To parse this JSON data, do
//
//     final restaurantDetails = restaurantDetailsFromJson(jsonString);

class RestaurantDetails {
  RestaurantDetails({
    this.id,
    this.restaurantName,
    this.restaurantImage,
    this.restaurantMobileNumber,
    this.restaurantAddress,
    this.lat,
    this.lon,
    this.restaurantOpen,
    this.restaurantClose,
    this.description,
    this.rating,
    this.dateTime,
    this.percentageDiscount,
    this.startTime,
    this.endTime,
    this.quantity,
    this.amount,
    this.discountAmount,
    this.afterDiscountAmount,
    this.status,
    this.bagsName,
    this.isWishListed,
  });

  String id;
  String restaurantName;
  String restaurantImage;
  String restaurantMobileNumber;
  String restaurantAddress;
  String lat;
  String lon;
  String restaurantOpen;
  String restaurantClose;
  String description;
  String rating;
  DateTime dateTime;
  String percentageDiscount;
  String startTime;
  String endTime;
  String quantity;
  String amount;
  String discountAmount;
  String afterDiscountAmount;
  String status;
  String bagsName;
  bool isWishListed;

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) =>
      RestaurantDetails(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        restaurantImage: json["restaurant_image"],
        restaurantMobileNumber: json["restaurant_mobile_number"],
        restaurantAddress: json["restaurant_address"],
        lat: json["lat"],
        lon: json["lon"],
        restaurantOpen: json["restaurant_open"],
        restaurantClose: json["restaurant_close"],
        description: json["description"],
        rating: json["rating"],
        dateTime: DateTime.parse(json["date_time"]),
        percentageDiscount: json["percentage_discount"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        quantity: json["quantity"],
        amount: json["amount"],
        discountAmount: json["discount_amount"],
        afterDiscountAmount: json["after_discount_amount"],
        status: json["status"],
        bagsName: json["bags_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "restaurant_name": restaurantName,
        "restaurant_image": restaurantImage,
        "restaurant_mobile_number": restaurantMobileNumber,
        "restaurant_address": restaurantAddress,
        "lat": lat,
        "lon": lon,
        "restaurant_open": restaurantOpen,
        "restaurant_close": restaurantClose,
        "description": description,
        "rating": rating,
        "date_time": dateTime.toIso8601String(),
        "percentage_discount": percentageDiscount,
        "start_time": startTime,
        "end_time": endTime,
        "quantity": quantity,
        "amount": amount,
        "discount_amount": discountAmount,
        "after_discount_amount": afterDiscountAmount,
        "status": status,
        "bags_name": bagsName,
      };
}
