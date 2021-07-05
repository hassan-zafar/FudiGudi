import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/models/userDataModel.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/tools/loading.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Hero(
                          tag: "logo",
                          child: Image.asset(
                            logo,
                            height: 90,
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          forgetPassPageIcon,
                          height: 60,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    Form(
                      key: _textFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            validator: (String val) {
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
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => handleForgetPass(),
                      child: buildSignUpLoginButton(
                          context: context,
                          btnText: "Continue",
                          hasIcon: false,
                          textColor: Colors.white,
                          color: Colors.green),
                    ),
                  ],
                ),
                _isLoading ? bouncingGridProgress() : Container(),
              ],
            ),
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

  getPass({
    @required String email,
  }) async {
    final String apiUrl =
        "https://fudigudi.ro/Fudigudi/webservice/forgot_password";
    final response = await http.post(apiUrl, body: {
      "email": email,
    });
    var result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200 && result["status"] == "1") {
      final responseString = response.body;
      print(responseString);
      return userDataFromJson(responseString);
    } else {
      BotToast.showText(text: "Couldn't Reset.Please try again");
      return null;
    }
  }

  handleForgetPass() async {
    final FormState _form = _textFormKey.currentState;

    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      print(email);
      final String apiUrl =
          "https://fudigudi.ro/Fudigudi/webservice/forgot_password";
      final response = await http.post(apiUrl, body: {
        "email": email,
      });
      var result = json.decode(response.body);
      BotToast.showText(text: "Check Your E-mail");
      print(result);
      setState(() {
        _isLoading = false;
      });
    } else {
      BotToast.showText(text: "Enter valid Email");
    }

    // var data = await getPass(
    //   email: email,
    // );
  }
}
