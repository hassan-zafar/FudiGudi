// To parse this JSON data, do
//
//     final getWishList = getWishListFromJson(jsonString);

import 'dart:convert';

GetWishList getWishListFromJson(String str) =>
    GetWishList.fromJson(json.decode(str));

String getWishListToJson(GetWishList data) => json.encode(data.toJson());

class GetWishList {
  GetWishList({
    this.result,
    this.message,
    this.status,
  });

  List<WishListItemDetails> result;
  String message;
  String status;

  factory GetWishList.fromJson(Map<String, dynamic> json) => GetWishList(
        result: json["status"] == "1"
            ? List<WishListItemDetails>.from(
                json["result"].map((x) => WishListItemDetails.fromJson(x)))
            : null,
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class WishListItemDetails {
  WishListItemDetails(
      {this.id,
      this.userId,
      this.restaurantId,
      this.dateTime,
      this.quantity,
      this.amount,
      this.date,
      this.restaurantName,
      this.image,
      this.bagsName,
      this.startTime,
      this.endTime});

  String id;
  String userId;
  String restaurantId;
  DateTime dateTime;
  String quantity;
  String amount;
  String date;
  String restaurantName;
  String image;
  String bagsName;
  String startTime;
  String endTime;

  factory WishListItemDetails.fromJson(Map<String, dynamic> json) =>
      WishListItemDetails(
        id: json["id"],
        userId: json["user_id"],
        restaurantId: json["restaurant_id"],
        dateTime: DateTime.parse(json["date_time"]),
        quantity: json["quantity"],
        amount: json["amount"],
        date: json["date"],
        restaurantName: json["restaurant_name"],
        image: json["image"],
        bagsName: json["bags_name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "restaurant_id": restaurantId,
        "date_time": dateTime.toIso8601String(),
        "quantity": quantity,
        "amount": amount,
        "date": date,
        "restaurant_name": restaurantName,
        "image": image,
        "bags_name": bagsName,
        "start_time": startTime,
        "end_time": endTime,
      };
}
