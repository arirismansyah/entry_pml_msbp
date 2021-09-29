import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Welcome/components/background.dart';
import 'package:flutter_auth/components/version_divider.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  startSplash() async {
    var duration = const Duration(seconds: 3);
    sharedPreferences = await SharedPreferences.getInstance();
    return Timer(duration, () {
      if (sharedPreferences.getString("nama_petugas") == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Selamat Datang di Aplikasi Entry PML MSBP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "BPS Provinsi Sumatera Selatan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/icons/msbp.png",
              height: size.height * 0.50,
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.5,
              child: Image.asset(
                "assets/icons/logobps.png",
                width: size.width * 0.20,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            VersionDivider()
          ],
        ),
      ),
    );
  }
}
