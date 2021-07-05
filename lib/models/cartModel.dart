//@dart=2.9
// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.result,
    this.message,
    this.status,
    this.totalAmount,
  });

  List<CartDetails> result;
  String message;
  String status;
  int totalAmount;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        result: List<CartDetails>.from(
            json["result"].map((x) => CartDetails.fromJson(x))),
        message: json["message"],
        status: json["status"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
        "total_amount": totalAmount,
      };
}

class CartDetails {
  CartDetails({
    this.id,
    this.userId,
    this.restaurantId,
    this.quantity,
    this.status,
    this.dateTime,
    this.startTime,
    this.endTime,
    this.amount,
    this.restaurantName,
    this.imageUrl,
    this.bagsName,
  });

  String id;
  String userId;
  String restaurantId;
  String quantity;
  String status;
  DateTime dateTime;
  String startTime;
  String endTime;
  String amount;
  String restaurantName;
  String imageUrl;
  String bagsName;

  factory CartDetails.fromJson(Map<String, dynamic> json) => CartDetails(
        id: json["id"],
        userId: json["user_id"],
        restaurantId: json["restaurant_id"],
        quantity: json["quantity"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        amount: json["amount"],
        restaurantName: json["restaurant_name"],
        imageUrl: json["image"],
        bagsName: json["bags_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "restaurant_id": restaurantId,
        "quantity": quantity,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "amount": amount,
        "restaurant_name": restaurantName,
        "image": imageUrl,
      };
}
