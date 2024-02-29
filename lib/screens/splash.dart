import 'dart:async';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/home.dart';
import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/homepageModel.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ColorConstants.themeBlue,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen(
        duration: const Duration(milliseconds: 3000),
        defaultNextScreen: MyDashboard(),
        splashScreenBody: Container(
          height: double.infinity,
          width: double.infinity,
          color: ColorConstants.themeBlue,


          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/images/imgpsh_fullsize_anim.gif'),
          ),
        ),
      ),
    );
  }
}
