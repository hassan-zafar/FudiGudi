import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/commonUIFunctions.dart';
import 'package:flutter_app/constants.dart';
import 'package:fswitch/fswitch.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationOnOff = true;
  bool _popUpsOnOff = true;
  bool _orderHistory = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Settings",
            style: titleTextStyle(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your app Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
//Notifications
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            "Receive notifications on latest offers and store updates")),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: FSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              _notificationOnOff = value;
                              //this._notificationOnOff = boolValue;
                            });
                          },
                          height: 25,
                          width: 45,
                          shadowColor: Colors.grey.shade400,
                          sliderColor: _notificationOnOff
                              ? Colors.red
                              : Colors.grey.shade300,
                          shadowBlur: 3,
                          color: Colors.grey.shade100,
                          openColor: Colors.white,
                          closeChild: Text(""),
                          open: _notificationOnOff,
                          openChild: Text(""),
                          childOffset: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//Popups
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Popups",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            "Disable all Popups and adverts from third party vendors")),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: FSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              _popUpsOnOff = value;
                              //this._notificationOnOff = boolValue;
                            });
                          },
                          height: 25,
                          width: 45,
                          shadowColor: Colors.grey.shade400,
                          sliderColor:
                              _popUpsOnOff ? Colors.red : Colors.grey.shade300,
                          shadowBlur: 3,
                          color: Colors.grey.shade100,
                          openColor: Colors.white,
                          closeChild: Text(""),
                          open: _popUpsOnOff,
                          openChild: Text(""),
                          childOffset: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//Order History
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Order History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                            "Keep your order history of the app unless manually removed")),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: FSwitch(
                          onChanged: (bool value) {
                            setState(() {
                              _orderHistory = value;
                              //this._notificationOnOff = boolValue;
                            });
                          },
                          height: 25,
                          width: 45,
                          shadowColor: Colors.grey.shade400,
                          sliderColor:
                              _orderHistory ? Colors.red : Colors.grey.shade300,
                          shadowBlur: 3,
                          color: Colors.grey.shade100,
                          openColor: Colors.white,
                          closeChild: Text(""),
                          open: _orderHistory,
                          openChild: Text(""),
                          childOffset: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildSignUpLoginButton(
                context: context,
                btnText: "UPDATE SETTINGS",
                hasIcon: false,
                textColor: Colors.white,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
