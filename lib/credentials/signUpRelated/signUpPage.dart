import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        body: Column(
          children: [
//Password
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: TextFormField(
                obscureText: _obscureText,
                validator: (val) =>
                    val != null && val.length < 6 ? 'Password Too Short' : null,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  labelText: "Password",
                  hintText: "Enter a valid password, min length 6",
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
