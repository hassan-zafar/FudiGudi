// To parse this JSON data, do
//
//     final allOrders = allOrdersFromJson(jsonString);

import 'dart:convert';

AllOrders allOrdersFromJson(String str) => AllOrders.fromJson(json.decode(str));

String allOrdersToJson(AllOrders data) => json.encode(data.toJson());

class AllOrders {
  AllOrders({
    this.result,
    this.message,
    this.status,
    this.totalAmount,
  });

  List<OrderHistoryDetails> result;
  String message;
  String status;
  dynamic totalAmount;

  factory AllOrders.fromJson(Map<String, dynamic> json) => AllOrders(
        result: List<OrderHistoryDetails>.from(
            json["result"].map((x) => OrderHistoryDetails.fromJson(x))),
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

class OrderHistoryDetails {
  OrderHistoryDetails({
    this.id,
    this.userId,
    this.totalAmount,
    this.status,
    this.cartId,
    this.restaurantId,
    this.orderDate,
    this.restaurantName,
    this.restaurantImage,
  });

  String id;
  String userId;
  String totalAmount;
  String status;
  String cartId;
  String restaurantId;
  DateTime orderDate;
  String restaurantName;
  String restaurantImage;

  factory OrderHistoryDetails.fromJson(Map<String, dynamic> json) =>
      OrderHistoryDetails(
        id: json["id"],
        userId: json["user_id"],
        totalAmount: json["total_amount"],
        status: json["status"],
        cartId: json["cart_id"],
        restaurantId: json["restaurant_id"],
        orderDate: DateTime.parse(json["order_date"]),
        restaurantName: json["restaurant_name"],
        restaurantImage: json["restaurant_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "total_amount": totalAmount,
        "status": status,
        "cart_id": cartId,
        "restaurant_id": restaurantId,
        "order_date":
            "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
        "restaurant_name": restaurantName,
        "restaurant_image": restaurantImage,
      };
}
