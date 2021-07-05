// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
     this.result,
     this.message,
     this.status,
  });

  AppUser result;
  String message;
  String status;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        result: AppUser.fromJson(json["result"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "message": message,
        "status": status,
      };
}

class AppUser {
  AppUser({
     this.id,
     this.fname,
     this.contact,
     this.email,
     this.password,
     this.image,
     this.socialId,
     this.lat,
     this.lon,
     this.location,
     this.registerId,
     this.dateTime,
     this.iosRegisterId,
  });

  String id;
  String fname;
  String contact;
  String email;
  String password;
  String image;
  String socialId;
  String lat;
  String lon;
  String location;
  String registerId;
  DateTime dateTime;
  String iosRegisterId;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json["id"],
        fname: json["fname"],
        contact: json["contact"],
        email: json["email"],
        password: json["password"],
        image: json["image"],
        socialId: json["social_id"],
        lat: json["lat"],
        lon: json["lon"],
        location: json["location"],
        registerId: json["register_id"],
        dateTime: DateTime.parse(json["date_time"]),
        iosRegisterId: json["ios_register_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "contact": contact,
        "email": email,
        "password": password,
        "image": image,
        "social_id": socialId,
        "lat": lat,
        "lon": lon,
        "location": location,
        "register_id": registerId,
        "date_time": dateTime.toIso8601String(),
        "ios_register_id": iosRegisterId,
      };
}
