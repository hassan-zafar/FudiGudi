import 'dart:convert';

loginUserFromJson(String str) => json.decode(str);

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  LoginUser({
    this.email,
     this.password,
     // ignore: non_constant_identifier_names
     this.register_id,
  });

  String email;
  String password;
  // ignore: non_constant_identifier_names
  String register_id;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        email: json["email"],
        password: json["password"],
        register_id: json["register_id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "register_id": register_id,
      };
}
