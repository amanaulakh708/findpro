import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findpro/apis/jobsApi.dart';
import 'package:findpro/global/Constants.dart';
import 'package:findpro/apis/nearByUserApi.dart';
import 'package:findpro/apis/userApi.dart';
import 'package:findpro/global/getSize.dart';
import 'package:findpro/models/jobsModel.dart';
import 'package:findpro/screens/allJobs.dart';
import 'package:findpro/screens/companyProfile.dart';
import 'package:findpro/screens/jobDetails.dart';
import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/profile.dart';
import 'package:findpro/screens/result.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connectivity_message/internet_connectivity_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/homepageModel.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyHomePageState();
}

class ColorConstants {
  static const kPrimaryColor = Color(0xFF383454);
  static const backgroundColor = Color(0xFFFAF9FF);
  static const lightGrey = Color(0xFFE0EBF1);
  static const dividerGrey = Color(0xFFD9D9D9);
  static const themeBlue = Color(0xFF0099D2);
}

class _MyHomePageState extends State<MyDashboard> {
  List<HomePage> homepagelist = <HomePage>[
    HomePage(profession: "Advocate"),
    HomePage(profession: "Architects"),
    HomePage(profession: "Astrology"),
    HomePage(profession: "Automobile"),
    HomePage(profession: "catering"),
    HomePage(profession: "Consultants"),
    HomePage(profession: "Contractors"),
    HomePage(profession: "CopyRight"),
    HomePage(profession: "DanceClasses"),
    HomePage(profession: "DJ"),
    HomePage(profession: "Doctor"),
    HomePage(profession: "Drivers"),
    HomePage(profession: "Education"),
    HomePage(profession: "Electronics"),
    HomePage(profession: "Event Planners"),
    HomePage(profession: "Health - Fitness"),
    HomePage(profession: "Home Services"),
    HomePage(profession: "Household Repair"),
    HomePage(profession: "HouseKepping"),
    HomePage(profession: "Information Technology"),
    HomePage(profession: "Insurance"),
    HomePage(profession: "Investments"),
    HomePage(profession: "Legal Services"),
    HomePage(profession: "Mobile Rapairs"),
    HomePage(profession: "Motor Sevices"),
    HomePage(profession: "Mover and Packers"),
    HomePage(profession: "Patent"),
    HomePage(profession: "Pest Controls"),
    HomePage(profession: "Photographers"),
    HomePage(profession: "Professional Trainers"),
    HomePage(profession: "Sports"),
    HomePage(profession: "Taxation"),
    HomePage(profession: "Travel Agents"),
    HomePage(profession: "Visa and Immigration"),
    HomePage(profession: "Welders"),
  ];

  List<String> images = ["assets/images/logo.png", "assets/images/logo.png"];
  String id = '';

  String city = 'searching';
  String stateArea = '';
  String currentLat = '0.0';
  String currentLon = '0.0';
  var ctime;
  var presscount = 0;
  StreamSubscription? connection;
  bool _internetStatus = false;
  bool _internetStatusOnline = false;
  bool hideNew = true;
  Size? textSize;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: ColorConstants.themeBlue,
          content: Text(
            "Location permissions are denied",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ));
        // Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Allow app to acess your location?'),
          content: const Text(
              "You need to allow Findpro App to access this device's location?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Don\'t allow'),
            ),
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Allow'),
            ),
          ],
        ),
      );

      // if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      // return Future.error('Location services are disabled.');
      // }
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    print('dfsdfs $city');
    city =
        '${place.locality?.replaceAll('Sahibzada Ajit Singh Nagar', 'Mohali')}';
    stateArea = '${place.administrativeArea?.replaceAll('Punjab', 'Panjab')}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);
    prefs.setString('state', stateArea);
    setState(() {});
  }

  Future<void> getLocation() async {
    print('dsgfsdgf');
    Position position = await _getGeoLocationPosition();
    currentLat = '${position.latitude}';
    currentLon = '${position.longitude}';
    GetAddressFromLatLong(position);
    setState(() {});
  }

  @override
  void initState() {
    getLoginId();
    fetchJobs(3, 0);
    fetchNearJSONData();
    getLocation();
    fetchJSONData();
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          _internetStatus = true;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          _internetStatus = false;
          _internetStatusOnline = true;
        });
        Timer timer = Timer(Duration(seconds: 5), () {
          setState(() {
            _internetStatusOnline = false;
          });
        });
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  getLoginId() async {
    // ctime = Timer.periodic(Duration(seconds: 3), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('dfgxdgf $id');
      id = prefs.getString('loginId') ?? '';
    });

  }

  @override
  Widget build(BuildContext context){
    double distanceInMeters = Geolocator.distanceBetween(
        double.parse(currentLat), double.parse(currentLon), 30.7096, 76.7199);
    double distanceKm = distanceInMeters / 1000;
    double finalDistance = double.parse(distanceKm.toStringAsFixed(1));

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.backgroundColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ColorConstants.backgroundColor,
      //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
      //color set to transperent or set your own color
    ));
    return WillPopScope(
      onWillPop: (){
        if (Platform.isAndroid){
          showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(10),

              title: const Text(
                'Please confirm',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorConstants.themeBlue),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: const Text(
                'Do you want to exit the app?',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child:  const Text('No'),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(animated: true),
                  child: const Text('Yes'),
                  ),
              ],
            ),
          );
        } else if (Platform.isIOS) {
          exit(0);
        }
        throw Exception('Failed');
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: MyAppBar(),
          ),
          drawer: MyDrawer(),
          endDrawer: MyEndDrawer(),
          body: Stack(
            children: [
              RefreshIndicator(
                // edgeOffset: 30.0,
                // triggerMode: RefreshIndicatorTriggerMode.values.,
                onRefresh: () async {
                  initState();
                },

                child: SingleChildScrollView(
                  child: Container(
                    color: const Color(0xffFAF9FF),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MyAppBar1(),
                          Container(
                            margin:
                              const  EdgeInsets.only(top: 10, left: 10, right: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageSlideshow(
                                width: double.infinity,
                                height: 100,
                                isLoop: true,
                                autoPlayInterval: 10000,
                                initialPage: 0,
                                indicatorColor: Colors.white,
                                indicatorBackgroundColor: Colors.white70,

                                onPageChanged: (value) {
                                  print('Page changed: $value');
                                },
                                // autoPlayInterval: 5000,
                                // isLoop: true,
                                children: [
                                  Image.asset(
                                    'assets/images/banner4.png',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/banner2.png',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/ad2.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/banner3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 10),
                            child: Text(
                              "Looking For",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                              height: 100,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: ListView.builder(
                                  itemCount: homepagelist.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index){
                                    return GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          useSafeArea: true,
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            iconPadding: const EdgeInsets.only(
                                                left: 250),
                                            icon: IconButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              icon:const Icon(Icons.cancel_rounded),
                                            ),
                                            title: Image.asset(
                                              'assets/images/health.png',
                                              height: 32.h,
                                              width: 32.w,
                                            ),
                                            content: Text(
                                                   homepagelist[index].profession.toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                        //    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                        // );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right:10),
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 10.h,
                                            left: 5.w,
                                            right: 5.w
                                        ),
                                        width: 110,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.all(
                                            Radius.circular(10.r),
                                          ),
                                        ),
                                        child: Column(
                                               mainAxisAlignment:
                                               MainAxisAlignment.center,
                                               children: [
                                               Image.asset(
                                              'assets/images/health.png',
                                              height: 32.h,
                                              width: 32.w,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              homepagelist[index]
                                                  .profession
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants
                                                      .kPrimaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                          // Container(
                          //
                          //   margin: EdgeInsets.symmetric(horizontal: 10.w),
                          //   child: SingleChildScrollView(
                          //     scrollDirection: Axis.horizontal,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //       children: <Widget>[
                          //         Container(
                          //           width: 130.w,
                          //           height: 120.h,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h,
                          //               bottom: 10.h,
                          //               left: 5.w,
                          //               right: 5.w),
                          //           decoration: BoxDecoration(
                          //             color:Colors.blue[50],
                          //             //color: const Color(0xffDAF5FF),
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10.r),),),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //             MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Container(
                          //                 child: Image.asset(
                          //                   'assets/images/health.png',
                          //                   height: 32.h,
                          //                   width: 32.w,
                          //                 ),
                          //               ),
                          //               Container(
                          //                      margin: const EdgeInsets.only(
                          //                      top: 5, bottom: 5),
                          //                      child: Text("Automobile",
                          //                       textScaleFactor: 1.0,
                          //                       style: TextStyle(
                          //                       fontSize: 13.sp,
                          //                       fontWeight: FontWeight.bold,
                          //                       color: ColorConstants
                          //                           .kPrimaryColor),),),
                          //               Flexible(
                          //                 child: Text(
                          //                   "The automotive industry in India is one of the main pillars of the economy.",
                          //                   textScaleFactor: 1.0,
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                       fontSize: 11.sp,
                          //                       color:
                          //                       ColorConstants.kPrimaryColor),
                          //                 ),
                          //               ),],
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           width: 10.w,
                          //         ),
                          //         Container(
                          //           width: 130.w,
                          //           height: 120.h,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h,
                          //               bottom: 10.h,
                          //               left: 5.w,
                          //               right: 5.w),
                          //           decoration: BoxDecoration(
                          //             color:Colors.blue[50],
                          //            // color: Color(0xffDAF5FF),
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(10.r),),),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //             MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Container(
                          //                 child: Image.asset(
                          //                   'assets/images/health.png',
                          //                   height: 32.h,
                          //                   width: 32.w,
                          //                 ),
                          //               ),
                          //               Container(
                          //
                          //                 margin: const EdgeInsets.only(
                          //                     top: 5, bottom: 5),
                          //                 child: Text("Dance Classes",
                          //                   textScaleFactor: 1.0,
                          //                   style: TextStyle(
                          //                       fontSize: 13.sp,
                          //                       fontWeight: FontWeight.bold,
                          //                       color: ColorConstants
                          //                           .kPrimaryColor),),),
                          //               Text(
                          //                 "The movement of the body in a rhythmic way.",
                          //                 textScaleFactor: 1.0,
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 11.sp,
                          //                     color:
                          //                     ColorConstants.kPrimaryColor),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           width: 10.w,
                          //         ),
                          //         Container(
                          //           width: 130.w,
                          //           height: 120.h,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h,
                          //               bottom: 10.h,
                          //               left: 5.w,
                          //               right: 5.w),
                          //           decoration: BoxDecoration(
                          //             color:Colors.blue[50],
                          //              // color: Color(0xffDAF5FF),
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(10.r),),),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //             MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Container(
                          //                 child: Image.asset(
                          //                   'assets/images/health.png',
                          //                   height: 32.h,
                          //                   width: 32.w,
                          //                 ),
                          //               ),
                          //               Container(
                          //
                          //                   margin: const EdgeInsets.only(
                          //                       top: 5, bottom: 5),
                          //                   child: Text("Doctor",
                          //                       textScaleFactor: 1.0,
                          //                       style: TextStyle(
                          //                           fontSize: 13.sp,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: ColorConstants
                          //                               .kPrimaryColor),),),
                          //               Flexible(
                          //                 child: Text(
                          //                   "Doctors assess and manage your medical treatment.",
                          //                   textScaleFactor: 1.0,
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                       fontSize: 11.sp,
                          //                       color:
                          //                       ColorConstants.kPrimaryColor),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           width: 10.w,
                          //         ),
                          //         Container(
                          //           height: 120.h,
                          //           width: 130.w,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h,
                          //               bottom: 10.h,
                          //               left: 5.w,
                          //               right: 5.w),
                          //           decoration: BoxDecoration(
                          //             color:Colors.blue[50],
                          //               //color: Color(0xffDAF5FF),
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(10.r))),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Container(
                          //                 child: Image.asset(
                          //                   'assets/images/health.png',
                          //                   height: 32.h,
                          //                   width: 32.w,
                          //                 ),
                          //               ),
                          //               Container(
                          //                   margin: const EdgeInsets.only(
                          //                       top: 5, bottom: 5),
                          //                   child: Text("Health",
                          //                       textScaleFactor: 1.0,
                          //                       style: TextStyle(
                          //                           fontSize: 13.sp,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: ColorConstants
                          //                               .kPrimaryColor))),
                          //               Text(
                          //                 "Department of Health and Human service",
                          //                 textScaleFactor: 1.0,
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 11.sp,
                          //                     color:
                          //                         ColorConstants.kPrimaryColor),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           width: 10.w,
                          //         ),
                          //         Container(
                          //           height: 120.h,
                          //           width: 130.w,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h,
                          //               bottom: 10.h,
                          //               left: 5.w,
                          //               right: 5.w),
                          //           decoration: BoxDecoration(
                          //               color:Colors.blue[50],
                          //            //   color: Color(0xffDAF5FF),
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(10.r))),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Container(
                          //                 child: Image.asset(
                          //                   'assets/images/Appliances.png',
                          //                   height: 32.h,
                          //                   width: 32.w,
                          //                 ),
                          //               ),
                          //               Container(
                          //                   margin: EdgeInsets.only(
                          //                       top: 5, bottom: 5),
                          //                   child: Text("Appliances",
                          //                       textScaleFactor: 1.0,
                          //                       style: TextStyle(
                          //                           fontSize: 13.sp,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: ColorConstants
                          //                               .kPrimaryColor))),
                          //               Text(
                          //                 "Servicing, installation, repair & uninstallation",
                          //                 textScaleFactor: 1.0,
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 11.sp,
                          //                     color:
                          //                         ColorConstants.kPrimaryColor),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           width: 10.w,
                          //         ),
                          //         Container(
                          //           width: 130.w,
                          //           height: 120.h,
                          //           padding: EdgeInsets.only(
                          //               top: 10.h, bottom: 10.h),
                          //           decoration:  BoxDecoration(
                          //             color:Colors.blue[50],
                          //              // color: Color(0xffDAF5FF),
                          //               borderRadius: const BorderRadius.all(
                          //                   Radius.circular(10))),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Image.asset(
                          //                 'assets/images/Event-&-Wedding.png',
                          //                 height: 32.h,
                          //                 width: 32.w,
                          //               ),
                          //               Container(
                          //                   margin: const EdgeInsets.only(
                          //                       top: 5, bottom: 5),
                          //                   child: Text("Event & Wedding",
                          //                       textScaleFactor: 1.0,
                          //                       overflow: TextOverflow.ellipsis,
                          //                       maxLines: 1,
                          //                       style: TextStyle(
                          //                           fontSize: 13.sp,
                          //                           fontWeight: FontWeight.bold,
                          //                           color: ColorConstants
                          //                               .kPrimaryColor))),
                          //               Text(
                          //                 "Photographer, Wedding planner & Decortaion",
                          //                 textScaleFactor: 1.0,
                          //                 textAlign: TextAlign.center,
                          //                 style: TextStyle(
                          //                     fontSize: 11.sp,
                          //                     color:
                          //                         ColorConstants.kPrimaryColor),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                    'assets/images/hireBanner.png')),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Latest jobs",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllJobs(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                    Icons.arrow_circle_right_outlined),
                              ),
                            ],
                          ),
                          FutureBuilder<List<Jobs>>(
                            future: fetchJobs(3, 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState.toString() ==
                                  'ConnectionState.waiting') {
                                return Shimmer.fromColors(
                                  baseColor: ColorConstants.lightGrey,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.sp),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'New',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: ColorConstants
                                                          .themeBlue),
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Icon(Icons.more_horiz_rounded)
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                Text(
                                                  ' - ',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee_rounded,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Text('',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                                Text(' - ',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                                Text('',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Text('',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                                Text(',',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                                Text('',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text('',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                            )),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 3.w, right: 3.w),
                                              padding: EdgeInsets.only(
                                                  left: 5.w,
                                                  right: 5.w,
                                                  top: 2.h,
                                                  bottom: 2.h),
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1)),
                                              child: Text(
                                                '',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Divider(
                                          color: ColorConstants.dividerGrey,
                                          height: 0,
                                          thickness: 1,
                                          // indent: 10.0,
                                          // endIndent: 10.0,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5.w, right: 5.w),
                                                    height: 30.h,
                                                    width: 30.w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(

                                                        width: 130.w,
                                                        child: Text(
                                                          '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.sp),
                                                        ),
                                                      ),
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 3,
                                                        minRating: 0,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 12,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'openings: ',
                                                  style: TextStyle(
                                                      fontSize: 13.sp),
                                                ),
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 13.sp),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    Text('',
                                                        style: TextStyle(
                                                            fontSize: 13.sp)),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if ((snapshot.data != null &&
                                  snapshot.data!.length > 0)) {
                                var len = snapshot.data!.length > 3
                                    ? 3
                                    : snapshot.data!.length;

                                return Column(
                                  children: [
                                    for (int i = 0; i < len; i++)
                                      Container(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      jobDetails(
                                                        snapshot.data![i].id,
                                                        snapshot.data![i].title,
                                                        snapshot.data![i]
                                                            .company_profile_pic,
                                                        snapshot.data![i]
                                                            .company_name,
                                                        snapshot.data![i]
                                                            .min_experience,
                                                        snapshot.data![i]
                                                            .max_experience,
                                                        snapshot
                                                            .data![i].minimum,
                                                        snapshot
                                                            .data![i].maximum,
                                                        snapshot.data![i].city,
                                                        snapshot.data![i].state,
                                                        snapshot.data![i]
                                                            .created_hours,
                                                        snapshot
                                                            .data![i].content,
                                                        snapshot.data![i]
                                                            .hiring_timeline,
                                                        snapshot
                                                            .data![i].deadline,
                                                        snapshot
                                                            .data![i].job_type,
                                                        snapshot.data![i]
                                                            .job_schedule,
                                                        snapshot.data![i]
                                                            .quick_hiring_time,
                                                        snapshot.data![i]
                                                            .suplement_pay,
                                                        snapshot.data![i]
                                                            .qualification,
                                                        snapshot
                                                            .data![i].skill_id,
                                                        snapshot
                                                            .data![i].applied,
                                                        snapshot.data![i]
                                                            .company_id,
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.h),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data![i].title,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.sp),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Visibility(
                                                            visible: hideNew,
                                                            child: (snapshot
                                                                        .data![
                                                                            i]
                                                                        .created_hours
                                                                        .toString()
                                                                        .contains(
                                                                            'days') ||
                                                                    snapshot
                                                                        .data![
                                                                            i]
                                                                        .created_hours
                                                                        .toString()
                                                                        .contains(
                                                                            '-'))
                                                                ? Container()
                                                                : const Text(
                                                                    'New',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: ColorConstants
                                                                            .themeBlue),
                                                                  )),
                                                        SizedBox(
                                                          width: 3.w,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .shopping_bag_outlined,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Text(
                                                            snapshot.data![i]
                                                                .min_experience,
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' - ',
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot.data![i]
                                                                .max_experience,
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .currency_rupee_rounded,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 3.w,
                                                          ),
                                                          Text(
                                                              snapshot.data![i]
                                                                  .minimum,
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                          Text(' - ',
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                          Text(
                                                              snapshot.data![i]
                                                                  .maximum,
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 15.w,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 3.w,
                                                          ),
                                                          Text(
                                                              snapshot.data![i]
                                                                  .city,
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                          Text(',',
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                          Text(
                                                              snapshot.data![i]
                                                                  .state,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(snapshot.data![i].content,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                    )),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  children: [
                                                    for (int s = 0;
                                                        s <
                                                            snapshot
                                                                .data![i]
                                                                .skill_id
                                                                .length;
                                                        s++)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3.w,
                                                            right: 3.w),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.w,
                                                                right: 5.w,
                                                                top: 2.h,
                                                                bottom: 2.h),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1)),
                                                        child: Text(
                                                          snapshot.data![i]
                                                              .skill_id[s],
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                const Divider(
                                                  color: ColorConstants
                                                      .dividerGrey,
                                                  height: 0,
                                                  thickness: 1,
                                                  // indent: 10.0,
                                                  // endIndent: 10.0,
                                                ),
                                                SizedBox(
                                                  height: 10.h,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  companyProfile(
                                                                      snapshot
                                                                          .data![
                                                                              i]
                                                                          .company_id)),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          (snapshot.data![i]
                                                                      .company_profile_pic !=
                                                                  "")
                                                              ? Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left: 5
                                                                              .w,
                                                                          right:
                                                                              5.w),
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: NetworkImage(snapshot
                                                                              .data![i]
                                                                              .company_profile_pic))),
                                                                )
                                                              : Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left: 5
                                                                              .w,
                                                                          right:
                                                                              5.w),
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              AssetImage('assets/images/findpro.png'))),
                                                                ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                // width: 130.w,
                                                                child: Text(
                                                                  snapshot
                                                                      .data![i]
                                                                      .company_name,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  softWrap:
                                                                      false,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.sp),
                                                                ),
                                                              ),
                                                              RatingBar.builder(
                                                                ignoreGestures:
                                                                    true,
                                                                initialRating:
                                                                    3,
                                                                minRating: 0,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                itemSize: 12,
                                                                itemPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            0.0),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) {
                                                                  print(rating);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'openings: ',
                                                          style: TextStyle(
                                                              fontSize: 13.sp),
                                                        ),
                                                        Text(
                                                          snapshot.data![i]
                                                              .position_available,
                                                          style: TextStyle(
                                                              fontSize: 13.sp),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.access_time,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                              width: 3.w,
                                                            ),
                                                            Text(
                                                              snapshot.data![i]
                                                                  .created_hours,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                return SizedBox(
                                  height: 200.h,
                                  child: const Center(
                                      child: Text('No jobs available')),
                                );
                              }
                            },
                          ),

                          // Container(
                          //   margin: EdgeInsets.only(
                          //       left: 10.w, right: 10.w, top: 10.h),
                          //   width: double.infinity,
                          //   child: ClipRRect(
                          //       borderRadius: BorderRadius.circular(10),
                          //       child: Image.asset('assets/images/ad3.jpeg')),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10),
                                child: Text(
                                  "Professionals Near By You",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                    const MyResult(title: 'FindPro', api: 'api1')));
                                  },

                                  icon:
                                      Icon(Icons.arrow_circle_right_outlined)),
                            ],
                          ),
                          FutureBuilder<List<Users>>(
                            future: fetchNearJSONData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState.toString() ==
                                  'ConnectionState.waiting') {
                                return Shimmer.fromColors(
                                  baseColor: ColorConstants.lightGrey,
                                  highlightColor: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Container(
                                                      height: 100.h,
                                                      width: 100.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 15.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 210.w,
                                                          height: 20.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10.h,
                                                    bottom: 10.h,
                                                    right: 5.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        child: GestureDetector(
                                                            onTap: () async {},
                                                            child: Icon(
                                                                Icons.phone))),
                                                    SizedBox(
                                                      height: 40.0.h,
                                                    ),
                                                    Container(
                                                      height: 10.h,
                                                      width: 30.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Container(
                                                      height: 100.h,
                                                      width: 100.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 15.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 210.w,
                                                          height: 20.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10.h,
                                                    bottom: 10.h,
                                                    right: 5.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        child: GestureDetector(
                                                            onTap: () {},
                                                            child: Icon(
                                                                Icons.phone))),
                                                    SizedBox(
                                                      height: 40.0.h,
                                                    ),
                                                    Container(
                                                      height: 10.h,
                                                      width: 30.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Container(
                                                      height: 100.h,
                                                      width: 100.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 15.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 210.w,
                                                          height: 20.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 3.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Container(
                                                          height: 20.h,
                                                          width: 150.w,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.r)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10.h,
                                                    bottom: 10.h,
                                                    right: 5.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        child: GestureDetector(
                                                            onTap: () {},
                                                            child: Icon(
                                                                Icons.phone))),
                                                    SizedBox(
                                                      height: 40.0.h,
                                                    ),
                                                    Container(
                                                      height: 10.h,
                                                      width: 30.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (snapshot.data != null &&
                                  snapshot.data!.length > 0) {
                                var profileLen = snapshot.data!.length > 3
                                    ? 3
                                    : snapshot.data!.length;
                                return Column(
                                  // children: snapshot.data!
                                  //     .map((user) => Column(
                                  children: [
                                    for (int i = 0; i < profileLen; i++)
                                      GestureDetector(
                                        onTap: () async {
                                          print(
                                              'sfsdfsdf ${snapshot.data?.length}');
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                            'link',
                                            snapshot.data![i].link,
                                          );
                                          prefs.setString(
                                            'id',
                                            snapshot.data![i].id,
                                          );
                                          prefs.setString(
                                            'category',
                                            snapshot.data![i].category,
                                          );

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProfile()));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5.h,
                                              bottom: 5.h,
                                              left: 10.w,
                                              right: 10.w),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      child: FadeInImage(
                                                        height: 100.h,
                                                        width: 100.w,
                                                        fadeOutCurve:
                                                            Curves.linear,
                                                        placeholderFit:
                                                            BoxFit.fitWidth,
                                                        placeholder:
                                                            const AssetImage(
                                                          'assets/images/logo.png',
                                                        ),
                                                        image: NetworkImage(
                                                          snapshot.data![i]
                                                              .profileImage,
                                                        ),
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                              'assets/images/logo.png',
                                                              height: 100.h,
                                                              width: 100.w,
                                                              fit: BoxFit
                                                                  .fitWidth);
                                                        },
                                                        fit: BoxFit.cover,
                                                      ),
                                                      //
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 15.w),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          Container(
                                                            // width:
                                                            //     195.w,
                                                            child: Text(
                                                              softWrap: false,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              snapshot.data![i]
                                                                  .name,
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                fontSize: 19.sp,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3.h,
                                                          ),
                                                          Container(
                                                            child: RatingBar
                                                                .builder(
                                                              ignoreGestures:
                                                                  true,
                                                              initialRating: (snapshot
                                                                          .data![
                                                                              i]
                                                                          .average_rating
                                                                          .toString() ==
                                                                      '')
                                                                  ? 0.0
                                                                  : double.parse(
                                                                      snapshot
                                                                          .data![
                                                                              i]
                                                                          .average_rating),
                                                              minRating: 0,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemSize: 13,
                                                              glowColor:
                                                                  Colors.amber,
                                                              itemPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          1.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                print(rating);
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3.w,
                                                                    right: 3.w,
                                                                    top: 2.h,
                                                                    bottom:
                                                                        1.h),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(4
                                                                            .r),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1)),
                                                            child: Text(
                                                              snapshot.data![i]
                                                                  .category,
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: <Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    size: 15),
                                                                Text(
                                                                  snapshot
                                                                      .data![i]
                                                                      .city,
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.sp),
                                                                )
                                                              ])
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10.h,
                                                      bottom: 10.h,
                                                      right: 0.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                          child:
                                                              GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    final call =
                                                                        Uri.parse('tel:+91 ' +
                                                                            '9876543210');
                                                                    if (await canLaunchUrl(
                                                                        call)) {
                                                                      launchUrl(
                                                                          call);
                                                                    } else {
                                                                      throw 'Could not launch $call';
                                                                    }
                                                                  },
                                                                  child: Icon(Icons
                                                                      .phone))),
                                                      SizedBox(
                                                        height: 40.0.h,
                                                      ),
                                                      Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                size: 10.sp),
                                                            Text(
                                                              // '',
                                                              "$finalDistance KM",
                                                              textScaleFactor:
                                                                  1.0,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp),
                                                            )
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                return Container(
                                  height: 200.h,
                                  child: Center(
                                      child: Text('No profiles available')),
                                );
                              }
                            },
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/ad1.jpeg')),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 10, top: 15, bottom: 15),
                                child: Text(
                                  "New Professionals",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyResult(
                                                title: 'FindPro',
                                                api: 'api2',
                                              )),
                                    );
                                  },
                                  icon:
                                      Icon(Icons.arrow_circle_right_outlined)),
                            ],
                          ),
                          NotificationListener<OverscrollIndicatorNotification>(
                            onNotification:
                                (OverscrollIndicatorNotification overscroll) {
                              overscroll.disallowIndicator();
                              return true;
                            },
                            child: FutureBuilder<List<Users>>(
                              future: fetchJSONData(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Shimmer.fromColors(
                                    baseColor: ColorConstants.lightGrey,
                                    highlightColor: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: Container(
                                                    height: 100.h,
                                                    width: 100.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.r)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 90.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: Container(
                                                    height: 100.h,
                                                    width: 100.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.r)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 90.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: Container(
                                                    height: 100.h,
                                                    width: 100.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.r)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 100.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 90.w,
                                                  height: 20.h,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r)),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Container(
                                  height: 220.h,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    scrollDirection: Axis.horizontal,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(children: [
                                        // snapshot.data!
                                        //     .map((user) =>
                                        Visibility(
                                          visible:
                                              (id != snapshot.data![index].id)
                                                  ? true
                                                  : false,
                                          child: GestureDetector(
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString(
                                                'link',
                                                snapshot.data![index].link,
                                              );
                                              prefs.setString(
                                                'category',
                                                snapshot.data![index].category,
                                              );
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyProfile()));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.only(
                                                  bottom: 6.h,
                                                  top: 6.h,
                                                  left: 8.w,
                                                  right: 8.w),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(14))),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11.r),
                                                      child: FadeInImage(
                                                        height: 110.h,
                                                        width: 110.w,
                                                        fadeOutCurve:
                                                            Curves.linear,
                                                        placeholderFit:
                                                            BoxFit.fitWidth,
                                                        placeholder:
                                                            const AssetImage(
                                                          'assets/images/logo.png',
                                                        ),
                                                        image: NetworkImage(
                                                          snapshot.data![index]
                                                              .profileImage,
                                                        ),
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                              'assets/images/logo.png',
                                                              height: 100.h,
                                                              width: 100.w,
                                                              fit: BoxFit
                                                                  .fitWidth);
                                                        },
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    Container(
                                                      width: 100.w,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        snapshot
                                                            .data![index].name,
                                                        // user.name,

                                                        textScaleFactor: 1.0,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 15.sp,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Container(
                                                      child: RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: (snapshot
                                                                    .data![
                                                                        index]
                                                                    .average_rating
                                                                    .toString() ==
                                                                'null')
                                                            ? 0.0
                                                            : double.parse(snapshot
                                                                .data![index]
                                                                .average_rating),
                                                        minRating: 0,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 12,
                                                        glowColor: Colors.amber,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    1.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                              Icons
                                                                  .location_on_rounded,
                                                              size: 10),
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .city,
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          )
                                                        ]),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InternetMessage(
                  onlineText: 'Back online',
                  offlineText: 'No internet connection',
                  bottomOfflineMsg: _internetStatus,
                  bottomOnlineMsg: _internetStatusOnline,
                  onlineTextColor: Colors.white,
                  offlineTextColor: Colors.white,
                  onlineColor: ColorConstants.themeBlue,
                  offlineColor: Color(0xFFEB5459),
                  padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
