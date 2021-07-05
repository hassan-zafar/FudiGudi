import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_app/models/userDataModel.dart';
import 'package:flutter_app/tools/loading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/home.dart';
import 'package:uuid/uuid.dart';

class EmailSignUp extends StatefulWidget {
  final bool isSocial;
  final bool isEdit;
  EmailSignUp({@required this.isSocial, @required this.isEdit});
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  String _countryPhoneCode;
  final _textFormKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;
  TextEditingController _locationController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  bool _obscureText2 = true;
  TextEditingController _confirmPasswordController = TextEditingController();
  String registerId = Uuid().v4();
  String socialId = Uuid().v4();
  Position position;

  bool _isLoading = false;

  final currentUserStored = GetStorage();

  getUserEditInfo() {
    _nameController.text = currentUser.fname;
    _emailController.text = currentUser.email;
    _locationController.text = currentUser.location;
    _phoneNoController.text = currentUser.contact;
    _passwordController.text = currentUser.password;
  }

  @override
  void initState() {
    super.initState();
    widget.isEdit ? getUserEditInfo() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Form(
                    key: _textFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.isEdit
                                ? "Edit Your information"
                                : "Sign Up To Continue",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
//Name
                        Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val == null) {
                                return null;
                              }
                              if (val.isEmpty) {
                                return "Shouldn't be empty";
                              } else if (val.trim().length < 4) {
                                return "Name Too short";
                              } else {
                                return null;
                              }
                            },
                            // onSaved: (val) => phoneNo = val,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              //enabledBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Name",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Should be at least 4 character long",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
//Email
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
                                  val.trim().length < 7) {
                                return "Invalid Email Address!";
                              } else {
                                return null;
                              }
                            },
                            // onSaved: (val) => phoneNo = val,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Email Address",
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText:
                                  "Please enter your valid E-mail address",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
//Phone Number
                        Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _phoneNoController,
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (val == null) {
                                return null;
                              }
                              if (val.trim().length < 7 || val.isEmpty) {
                                return "Phone number too short";
                              } else {
                                return null;
                              }
                            },
                            // onSaved: (val) => phoneNo = val,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Phone Number",
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Please enter your Phone Number",
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
//Password
                        widget.isSocial
                            ? Container()
                            : Card(
                                elevation: 4,
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  validator: (val) =>
                                      val != null && val.length < 6
                                          ? 'Password Too Short'
                                          : null,
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
                                    labelText: "Password",
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText:
                                        "Enter a valid password, min length 6",
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
//Confirm Password
                        widget.isSocial
                            ? Container()
                            : Card(
                                elevation: 4,
                                child: TextFormField(
                                  obscureText: _obscureText2,
                                  validator: (val) =>
                                      val != null && val.length < 6
                                          ? 'Password Too Short'
                                          : null,
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                      child: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Confirm Password",
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Re-Enter Password",
                                  ),
                                ),
                              ),
                        Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter Your Location",
                              labelText: "Enter Your Location",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          width: 200.0,
                          height: 100.0,
                          alignment: Alignment.center,
                          child: RaisedButton.icon(
                            label: Text(
                              "Use Current Location",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.green,
                            onPressed: getUserLocation,
                            icon: Icon(
                              Icons.my_location,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _handleSignUp,
                          child: buildSignUpLoginButton(
                            context: context,
                            btnText: "Sign Up",
                            hasIcon: false,
                            color: Colors.green,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoading ? bouncingGridProgress() : Container(),
          ],
        )),
      ),
    );
  }

  void _handleSignUp() async {
    final _form = _textFormKey.currentState;
    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });
      String signUpUrl = 'https://fudigudi.ro/Fudigudi/webservice/signup';
      String updateProfileUrl =
          "https://fudigudi.ro/Fudigudi/webservice/update_profile";
      String socialLoginUrl =
          'https://fudigudi.ro/Fudigudi/webservice/social_login';

      var data = {
        "user_id": currentUser.id ?? null,
        "fname": _nameController.text,
        "contact": _phoneNoController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "lat": "${position.latitude}" ?? currentUser.lat,
        "lon": "${position.longitude}" ?? currentUser.lon,
        "location": _locationController.text,
        "register_id": registerId,
        "social_id": socialId
      };
      var request = widget.isEdit
          ? http.MultipartRequest('POST', Uri.parse(updateProfileUrl))
          : http.MultipartRequest(
              'POST', Uri.parse(widget.isSocial ? socialLoginUrl : signUpUrl));
      request.fields.addAll(data);

      http.StreamedResponse response = await request.send();
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        String futureResponseBody = await response.stream.bytesToString();
        String tempResponseBody = futureResponseBody.toString();
        print("tempResponseBody" + "$tempResponseBody");
        //UserData user = userDataFromJson(tempResponseBody);
        var user = json.decode(tempResponseBody);
        print("user" + "${user["result"]}");
        print("data before storing in local database: " + tempResponseBody);
        currentUserStored.write("userData", "$tempResponseBody");
        currentUserStored.write("isLoggedIn", true);

        print("stored data" + currentUserStored.read("userData"));
        if (user["status"] == "1") {
          setState(() {
            currentUser = AppUser.fromJson(user["result"]);
          });
          if (currentUser == null) {
            return null;
          } else {
            var name = currentUser?.fname;
            BotToast.showText(
                text: widget.isEdit ? "Profile Updated" : "Welcome $name",
                align: Alignment.center);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
        } else {
          BotToast.showText(text: "${user["result"]}", align: Alignment.center);
        }
      } else {
        BotToast.showText(text: "Couldn't SignUp Please try again");
      }
    } else {
      BotToast.showText(text: "Enter Valid Data", align: Alignment.center);
    }
  }

  getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      position = _position;
    });
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placeMarks[0];
    String completeAddress =
        '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    _locationController.text = completeAddress;
  }
}
