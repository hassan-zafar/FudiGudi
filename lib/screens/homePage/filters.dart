import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/commonUIFunctions.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              filterTextWidget("Hide sold-out"),
              filterTextWidget("Meals"),
            ],
          ),
          filterTextWidget("Break & Pastries"),
          filterTextWidget("Pastas"),
          buildSignUpLoginButton(
              context: context,
              btnText: "Apply Filter",
              hasIcon: false,
              color: Colors.green,
              textColor: Colors.white),
        ],
      ),
    );
  }
}
