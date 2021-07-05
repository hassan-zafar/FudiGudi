// @dart=2.9
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_app/bindings/bindings.dart';
import 'package:flutter_app/constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_app/credentials/signUpRelated/signUpOptions.dart';
import 'package:flutter_app/screens/homePage/homeView.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final currentUserStored = GetStorage();
    currentUserStored.writeIfNull("isLoggedIn", false);
    bool isLoggedIn = currentUserStored.read("isLoggedIn");
    //currentUser=currentUserStored.read("userData");
    return GetMaterialApp(
      title: 'Fudigudi',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xff8BC63C),
        accentColor: Color(0xffDEEEFE),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(color: Colors.transparent),
      ),  locale: const Locale('ro'), // change to locale you want. not all locales are supported
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],supportedLocales: [  const Locale('en', 'US'), 
    const Locale('ro', 'RO'), ],
      home: AnimatedSplashScreen(
      splash: Hero(
tag: "logo",      
            child: Image.asset(
              logo,
              height: 80,
            )),
        animationDuration: Duration(seconds: 1),
        centered: true,
        nextScreen: isLoggedIn ? Home() : SignUpOptions(),
        duration: 1,
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
