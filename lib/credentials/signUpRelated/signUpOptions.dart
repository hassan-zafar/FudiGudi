import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'dart:convert';
import 'emailSignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/home.dart';
import 'package:http/http.dart' as http;

class SignUpOptions extends StatefulWidget {
  @override
  _SignUpOptionsState createState() => _SignUpOptionsState();
}

class _SignUpOptionsState extends State<SignUpOptions> {
  // TapGestureRecognizer _gestureRecognizer=TapGestureRecognizer()..onTap=(){
  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn));
  // }
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Hero(
                  tag: "logo",
                  child: Image.asset(
                    logo,
                    height: 80,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Continue with social media",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailSignUp(
                              isSocial: true,
                              isEdit: false,
                            ))),
                child: buildSignUpLoginButton(
                    context: context,
                    btnText: "Continue With Google",
                    assetImage: googleLogo,
                    hasIcon: true),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailSignUp(
                              isSocial: true,
                              isEdit: false,
                            ))),
                child: buildSignUpLoginButton(
                    context: context,
                    btnText: "Continue With Facebook",
                    assetImage: facebookLogo,
                    hasIcon: true,
                    textColor: Colors.white,
                    color: Colors.blue),
              ),
//Other Options Text only
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Other Options",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailSignUp(
                              isSocial: false,
                              isEdit: false,
                            ))),
                child: buildSignUpLoginButton(
                    context: context,
                    btnText: "Sign Up with Email",
                    assetImage: emailIcon,
                    hasIcon: true,
                    textColor: Colors.white,
                    color: Colors.green),
              ),

              SizedBox(
                height: 10,
              ),
// Move to Log In Page
            ],
          ),
          bottomSheet: buildSignUpLoginText(
              context: context,
              text1: "Already have an account? ",
              text2: "Log In",
              moveToLogIn: true),
        ),
      ),
    );
  }

  // void _handleLogin() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   var res = await CallApi().getData('get_profile?user_id=1');
  //   var body = json.decode(res.body);
  //   print(body.toString());
  //   if (body['status'] == 1) {
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     localStorage.setString('token', body['token']);
  //     localStorage.setString('user', json.encode(body['user']));
  //
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  //   }
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
