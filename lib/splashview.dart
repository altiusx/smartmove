import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartmove/home_page.dart';
import 'package:smartmove/models/User.dart';
import 'package:smartmove/pages/signin/sign_in_page.dart';
import 'package:smartmove/services/AppGlobal.dart';
import 'package:smartmove/services/SharedPref.dart';
import 'package:smartmove/services/constant_strings.dart';

class SplashView extends StatefulWidget {
  static const String routeName = "/splashView";
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SharedPref sharedPref = SharedPref();

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool _isLogin = pref.getBool(isLogin);

    if (_isLogin == null) {
      _isLogin = false;
    }

    if (_isLogin) {
      openHomePage();
    } else {
      openSignInPage();
    }
  }

  void openHomePage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }

  void openSignInPage() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ));
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    startTime();
  }

  loadSharedPrefs() async {
    try {
      User user = User.fromJson(await sharedPref.read("user"));
      setState(() {
        AppGlobal.userLoad = user;
      });
    } catch (Exception) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        alignment: Alignment.bottomRight,
        child: Image(
          image: AssetImage("images/test.webp"),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
