// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'package:flutter_app/home.dart';
import 'package:http/http.dart' as http;
// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    this.result,
    this.message,
    this.status,
  });

  //List<NotificationData>
  var result;
  String message;
  String status;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        result: json["status"] == "1"
            ? List<NotificationData>.from(
                json["result"].map((x) => NotificationData.fromJson(x)))
            : json["result"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class NotificationData {
  NotificationData({
    this.id,
    this.userId,
    this.message,
    this.dateTime,
    this.title,
    this.userName,
    this.userImage,
  });

  String id;
  String userId;
  String message;
  DateTime dateTime;
  String title;
  String userName;
  String userImage;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        userId: json["user_id"],
        message: json["message"],
        dateTime: DateTime.parse(json["date_time"]),
        title: json["title"],
        userName: json["user_name"],
        userImage: json["user_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "message": message,
        "date_time": dateTime.toIso8601String(),
        "title": title,
        "user_name": userName,
        "user_image": userImage,
      };
}

Future<List<NotificationData>> getNotifications() async {
  var headers = {'Cookie': 'ci_session=khaalu4944p55mm08dhi62re7j4hclpi'};
  var request = http.MultipartRequest('POST',
      Uri.parse('https://fudigudi.ro/Fudigudi/webservice/get_notification'));
  request.fields.addAll({'user_id': currentUser.id});

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String res = await response.stream.bytesToString();
    try {
      NotificationsModel notificationsModel = notificationsModelFromJson(res);
      if (notificationsModel.status == "1") {
        return notificationsModel.result;
      } else {
        return null;
      }
    } on Exception catch (e) {
      return null;
    }
  } else {
    print(response.reasonPhrase);
    return null;
  }
}
