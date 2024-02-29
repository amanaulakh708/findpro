import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dashboard.dart';

class signInUp extends StatefulWidget {
  const signInUp({super.key, required this.title});

  final String title;

  @override
  State<signInUp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<signInUp> {

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child:
                      Image.asset('assets/images/imgpsh_fullsize_anim.png'),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 40.w, bottom: 10.h),
                      child: Text(
                        "Welcome!",textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 40.w, bottom: 20.h),
                      child: Text(
                        "Log in with your data that you entered during your registration.",textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 18.sp, color: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.h, right: 40.w, left: 40.w),
                      width: double.infinity,
                      // alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyLogin(title: 'FindPro'),
                            ),
                          );

                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                          backgroundColor: ColorConstants.themeBlue, //
                          // padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ), child: Text("Sign In",style: TextStyle(fontSize: 20.sp)),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 15.h, right: 40.w, left: 40.w),
                      width: double.infinity,
                      // alignment: Alignment.bottomLeft,
                      child: TextButton(
                        onPressed: () async {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyRegistration(title: 'FindPro'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                          backgroundColor: ColorConstants.themeBlue, //
                          // padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ), child: Text("Sign Up",style: TextStyle(fontSize: 20.sp)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

        ));
  }

}