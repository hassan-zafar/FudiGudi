// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewsModel reviewModelFromJson(String str) =>
    ReviewsModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewsModel data) => json.encode(data.toJson());

class ReviewsModel {
  ReviewsModel({
    this.result,
    this.message,
    this.status,
    this.totalReview,
  });

  // List<ReviewData>
  var result;
  String message;
  String status;
  int totalReview;

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
        result: json["status"] == "1"
            ? List<ReviewData>.from(
                json["result"].map((x) => ReviewData.fromJson(x)))
            : json["result"],
        message: json["message"],
        status: json["status"],
        totalReview: json["total_review"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
        "total_review": totalReview,
      };
}

class ReviewData {
  ReviewData({
    this.id,
    this.userId,
    this.restaurantId,
    this.review,
    this.dateTime,
    this.restaurantName,
    this.restaurantImage,
    this.userName,
    this.userImage,
  });

  String id;
  String userId;
  String restaurantId;
  String review;
  DateTime dateTime;
  String restaurantName;
  String restaurantImage;
  String userName;
  String userImage;

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"],
        userId: json["user_id"],
        restaurantId: json["restaurant_id"],
        review: json["review"],
        dateTime: DateTime.parse(json["date_time"]),
        restaurantName: json["restaurant_name"],
        restaurantImage: json["restaurant_image"],
        userName: json["user_name"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "restaurant_id": restaurantId,
        "review": review,
        "date_time": dateTime.toIso8601String(),
        "restaurant_name": restaurantName,
        "restaurant_image": restaurantImage,
        "user_name": userName,
        "user_image": userImage,
      };
}
