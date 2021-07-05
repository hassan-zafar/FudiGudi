// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.result,
    this.message,
    this.status,
    this.totalComment,
  });

  //List<CommentData>
  var result;
  String message;
  String status;
  int totalComment;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        result: json["status"] == "1"
            ? List<CommentData>.from(
                json["result"].map((x) => CommentData.fromJson(x)))
            : json["result"],
        message: json["message"],
        status: json["status"],
        totalComment: json["total_comment"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
        "total_comment": totalComment,
      };
}

class CommentData {
  CommentData({
    this.id,
    this.userId,
    this.restaurantId,
    this.comment,
    this.dateTime,
    this.restaurantName,
    this.restaurantImage,
    this.userName,
    this.userImage,
  });

  String id;
  String userId;
  String restaurantId;
  String comment;
  DateTime dateTime;
  String restaurantName;
  String restaurantImage;
  String userName;
  String userImage;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        userId: json["user_id"],
        restaurantId: json["restaurant_id"],
        comment: json["comment"],
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
        "comment": comment,
        "date_time": dateTime.toIso8601String(),
        "restaurant_name": restaurantName,
        "restaurant_image": restaurantImage,
        "user_name": userName,
        "user_image": userImage,
      };
}
