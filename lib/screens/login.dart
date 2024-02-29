import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/models/loginModel.dart';
import 'package:findpro/screens/registration.dart';
import 'package:findpro/screens/signInUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key, required this.title});

  final String title;

  @override
  State<MyLogin> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  bool hideProgress = false;


  void login(String email ,password) async {

    try{
      Response response = await post(
          Uri.parse(apiURL + 'login'),
          body: {
            'username' : emailController.text.toString(),
            'password' : passwordController.text.toString()
          }
      );

      if(response.statusCode == 200){
        hideProgress = false;
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    MyDashboard()));
        var data = jsonDecode(response.body.toString());

        SharedPreferences profilePrefs = await SharedPreferences.getInstance();
        profilePrefs.setString('loginId', data['data']['userID']);
        profilePrefs.setString('editLink', data['data']['link']);
        profilePrefs.setString('name', data['data']['name']);
        profilePrefs.setString('uploadImage', data['data']['avatar']);
        profilePrefs.setString('email', data['data']['email']);
        profilePrefs.setString('phone', data['data']['phone']);
        profilePrefs.setString('dob', data['data']['dob']);
        print('sdfdsf ${data['data']['avatar']}');

        print(data['token']);
        print("dfhshgf ${data['data']}");
        print( 'Login successfully');

      }else {
        setState(() {
          hideProgress = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "Invalid email or Password")));
        });

        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

 @override
  void initState() {
   // _passwordVisible = false;
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size(double.infinity, 100),
        //  child: Container(
        //    color: ColorConstants.themeBlue,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         IconButton(
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //             hoverColor: Colors.transparent,
        //             onPressed: () {
        //               Navigator.pop(context);
        //           // _key.currentState!.openDrawer();
        //         }, icon: Icon(Icons.arrow_back,size: 25,color: Colors.white,)),
        //       ],
        //     ),
        //   ),
        //
        // ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: ClipRRect(
                                child:
                                    Image.asset('assets/images/loginback.png')),
                          ),
                          Positioned(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Image.asset(
                                              'assets/images/btback.png',
                                              height: 35.h,
                                              width: 35.w,
                                            )),
                                        Image.asset(
                                          'assets/images/logo.png',
                                          height: 90.h,
                                          width: 140.w,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 50.h,
                                          width: 50.w,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                        bottom: 10.h,
                                        top: 30.h),
                                    child: Text(
                                      "Making Your Job & Professional Search Easy",
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 27.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: ColorConstants.backgroundColor,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.6,
                      ),
                    ],
                  ),
                  Positioned(
                    left: 20,
                    top: 200,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.only(top: 20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 30.h),
                            child: Text(
                              "Login to your account",
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: 20.h, right: 40.w, left: 40.w),
                            // padding: EdgeInsets.all(15),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter a valid email address";
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Enter a valid email address";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: 15.h, right: 40.w, left: 40.w),
                            // padding: EdgeInsets.all(15),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: passwordController,
                              obscureText: _passwordVisible,
                                onFieldSubmitted: (term){
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      hideProgress = true;
                                    });
                                    login(emailController.text.toString(), passwordController.text.toString());
                                  }
                                },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                } else if (value.length < 5) {
                                  return "Password should be atleast 8 characters";
                                } else if (value.length > 15) {
                                  return "Password should not be greater than 15 characters";
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  icon: _passwordVisible?
                                  Icon(
                                    // Based on passwordVisible state choose the icon
                                    Icons.visibility_off,
                                    color: Colors.grey,size: 20.sp,
                                  ):Icon(
                                    // Based on passwordVisible state choose the icon
                                    Icons.visibility,
                                    color: Colors.blue,size: 20.sp,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                right: 40.w, bottom: 20.h, top: 15.h),
                            child: Text(
                              "Forgot Password",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.blueGrey),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: 40.w, left: 40.w, top: 20.h),
                            width: double.infinity,
                            // alignment: Alignment.bottomLeft,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                                  backgroundColor:
                                      ColorConstants.themeBlue, // Text Color
                                ),
                                onPressed: () {

                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      hideProgress = true;
                                    });

                                    login(emailController.text.toString(), passwordController.text.toString());
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(
                                    //         content: Text(
                                    //             "Data is in processing.")));
                                  }
                                },
                                child: Text("LOG IN",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(fontSize: 18.sp))),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin:
                                      EdgeInsets.only(bottom: 15.h, top: 15.h),
                                  child: Text(
                                    "Don't have an account ",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.blueGrey),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin:
                                      EdgeInsets.only(bottom: 15.h, top: 15.h),
                                  child: InkWell(
                                    child: Text(
                                      "Sign Up",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: ColorConstants.themeBlue),
                                    ),
                                    onTap: () {
                                      // Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyRegistration(title: 'FindPro'),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              ]),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Visibility(
                              visible: hideProgress,
                              child: LinearProgressIndicator(
                                color: ColorConstants.themeBlue,
                                // value: loadingPercentage / 100.0,

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
