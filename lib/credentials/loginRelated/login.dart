import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'dart:convert';
import 'package:flutter_app/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/userDataModel.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'forgetPasswordPage.dart';
import 'package:flutter_app/tools/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  GetStorage currentUserStored = GetStorage();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _textFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Hero(
                              tag: "logo",
                              child: Image.asset(
                                logo,
                                height: 90,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val == null) {
                                return null;
                              }
                              if (val.isEmpty) {
                                return "Field is Empty";
                              } else if (!val.contains("@") ||
                                  val.trim().length < 4) {
                                return "Invalid E-mail!";
                              } else {
                                return null;
                              }
                            },
                            // onSaved: (val) => phoneNo = val,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "E-mail",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Please enter your valid E-mail",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 4,
                          child: TextFormField(
                            obscureText: _obscureText,
                            validator: (val) {
                              if (val == null) {
                                return null;
                              }
                              if (val.length < 6) {
                                return 'Password Too Short';
                              } else {
                                return null;
                              }
                            },
                            controller: _passwordController,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Password",
                              hintText: "Enter a valid password, min length 6",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordPage())),
                            child: Hero(
                              tag: "passFor",
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _handleLogin(),
                          child: buildSignUpLoginButton(
                              context: context,
                              btnText: "Log In",
                              textColor: Colors.white,
                              hasIcon: false,
                              color: Colors.green),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home())),
                          child: buildSignUpLoginButton(
                              context: context,
                              btnText: "Continue With Google",
                              assetImage: googleLogo,
                              hasIcon: true),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home())),
                          child: buildSignUpLoginButton(
                              context: context,
                              btnText: "Continue With Facebook",
                              assetImage: facebookLogo,
                              hasIcon: true,
                              textColor: Colors.white,
                              color: Colors.blue),
                        ),

                        SizedBox(
                          height: 20,
                        ),
// Move to Sign Up Page
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading ? bouncingGridProgress() : Container(),
            ],
          ),
          bottomSheet: buildSignUpLoginText(
              context: context,
              text1: "Don't have an account ",
              text2: "Sign Up",
              moveToLogIn: false),
        ),
      ),
    );
  }

  Future<UserData> _loginUser(
      {@required String email, @required String password}) async {
    final String apiUrl = "https://fudigudi.ro/Fudigudi/webservice/login";
    final response = await http.post(apiUrl, body: {
      "email": email,
      "password": password,
      //"register_id": register_id,
    });
    var result = json.decode(response.body);

    if (response.statusCode == 200 && result["status"] == "1") {
      final String responseString = response.body;
      print("data before storing in local database: " + responseString);
      currentUserStored.write("userData", "$responseString");
      currentUserStored.write("isLoggedIn", true);

      print("stored data" + currentUserStored.read("userData"));
      return userDataFromJson(responseString);
    } else {
      BotToast.showText(text: "Couldn't SignIn.Please try again");
      return null;
    }
  }

  void _handleLogin() async {
    final _form = _textFormKey.currentState;

    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      final String password = _passwordController.text;

      UserData user = await _loginUser(
        email: email,
        password: password,
      );

      if (user != null && user.status == "1") {
        setState(() {
          currentUser = user.result;
        });

        setState(() {
          _isLoading = false;
        });
        BotToast.showText(
          text: "Welcome ${user.result.fname}",
        );
        Get.offAll(Home());
      } else {
        BotToast.showText(text: "Couldn't SignIn.Please try again");
      }
    } else {
      BotToast.showText(text: "Enter Valid Data!");
    }
  }
}

// blaBla() async {
//   var data = {
//     "id": "2",
//     "register_id": "sdfdsbjfvbdsakbskbfrrrwe",
//     "date_time": "dfsdfsdf",
//     "ios_register_id": ""
//   };
//
//   var res = await CallApi().postData(data, 'login');
//   var body = json.decode(res.body);
//   print(body.toString());
//   if (body['status'] == 200) {
//     print("success");
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     localStorage.setString('token', body['token']);
//     localStorage.setString('user', json.encode(body['user']));
//   } else {
//     print("failed");
//   }
// }
