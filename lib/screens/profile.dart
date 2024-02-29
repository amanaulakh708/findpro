import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;


import 'package:findpro/apis/profileApi.dart';
import 'package:findpro/apis/similerProApi.dart';

import 'package:findpro/models/profileModel.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/result.dart';
import 'package:findpro/screens/testslide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slideupscreen/blurred_popup.dart';
import 'package:slideupscreen/slide_up_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global/Constants.dart';
import 'dashboard.dart';

class MyProfile extends StatefulWidget{
  const MyProfile({super.key, });
  @override
  State<MyProfile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfile> with TickerProviderStateMixin {
  PageController pageController = PageController();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final feedbackFormKey = GlobalKey<FormState>();
  final fieldText = TextEditingController();
  bool isSearchEmpty = false;
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _timeContainer = false;
  bool _contact = false;
  late AnimationController controller;
  late Animation<Offset> offset;
  final _controller = ScrollController();
  bool atend = false;
  late double rate = 0.0;
  bool feedbackLoading = false;
  String id = '';
  String name = '';
  String email = '';
  String number = '';
  TextEditingController feedbackName = TextEditingController();
  TextEditingController feedbackEmail = TextEditingController();
  TextEditingController feedbackText = TextEditingController();
  TextEditingController feedbackNumber = TextEditingController();
  Size? expTextSize;


  void clearText() {
    fieldText.clear();
    setState(() {
      isSearchEmpty = false;
    });
  }

  void swipeBottom() {
    if (_controller.hasClients) {
      final position = _controller.position.maxScrollExtent;
      _controller.animateTo(
        position,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  getSPLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('sujegfdhfjdh $email');
    });
    // });
  }

  getLoginId() async {
    // _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('dfgxdgf $id');
      id = prefs.getString('loginId') ?? '';
      number = prefs.getString('phone') ?? '';
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      print('dfgxdgf $id');
      print('dfgxdgf $number');
    });
    // });
  }

  @override
  void initState() {
    super.initState();
    print('sgsdgsg $name');
    print('sgsdgsg $number');
    // getSPLogin();
    getLoginId();
    fetchProfileJSONData();
    fetchSimilarJSONData();


    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(0.0, 0.0))
        .animate(controller);

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    feedbackName.text = name.toString();
  }

  void feedback(String name, feedback, phone, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('listerId');
    String? senderId = prefs.getString('id');

    try {
      Response response = await post(
          Uri.parse('${apiURL}star_rating'),
         // Uri.parse(apiURL + 'star_rating'),
          body: {
            'lister_id': id,
            'sender_id': senderId,
            'name': feedbackName.text.toString(),
            'email': feedbackEmail.text.toString(),
            'phone': feedbackNumber.text.toString(),
            'feedback': feedbackText.text.toString(),
            'rating': rate.toString()
          }
      );
      print('sdf ${response.body}');

      if (response.statusCode == 200){
        feedbackLoading = false;
        if (!mounted) return;
        Navigator.of(context).pop();
         var data = await jsonDecode(response.body.toString());

        if (!mounted) return;

        feedbackName.clear();
        feedbackText.clear();
        feedbackNumber.clear();
        feedbackEmail.clear();
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Feedback submitted",
                  style: TextStyle(color: Colors.white),)));
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Failed")));
        });

        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    var key1 = GlobalKey();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        key: _key,
        appBar: PreferredSize(
          preferredSize:const Size(double.infinity, 100),
          child:Container(
              padding: EdgeInsets.only(bottom: 5.h,),
              margin: EdgeInsets.only(top: 5.h,),
              child: MyAppBar2(),
          ),
        ),
          endDrawer: MyEndDrawer(),
          body: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children:[
              FutureBuilder<List<profile>>(
                future: fetchProfileJSONData(),
                builder: (context, snapshot){
                  if (!snapshot.hasData){
                      return Shimmer.fromColors(
                      baseColor: ColorConstants.lightGrey,
                      highlightColor: Colors.white,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10.h,
                        ),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 10.w, left: 10.w),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.r)),
                                      child: Image.asset(
                                          'assets/images/curveimg.png',
                                          height: 95.h,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Row(
                                    children:[
                                      Expanded(
                                        flex: 4,
                                        child: Stack(
                                          children: [
                                            Column(
                                                children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10.w),
                                                height: 95.0.h,
                                                width: double.infinity,
                                                color:
                                                Colors.transparent,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10.w),
                                                height: 50.0.h,
                                                width: double.infinity,
                                              ),
                                            ]),
                                            Positioned(
                                              top: 18,
                                              left: 20,
                                              child: Container(
                                                  margin:
                                                  EdgeInsets.only(
                                                      left: 5.w,
                                                      right: 5.w),
                                                  width: 115.0.w,
                                                  height: 115.0.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape
                                                        .circle,
                                                    border: Border.all(
                                                        color: Colors
                                                            .white,
                                                        width: 4.w),
                                                  ),

                                                  child: Align(
                                                    alignment: Alignment
                                                        .center,
                                                    child:
                                                    Container(
                                                      height: 110.h,
                                                      width: 110.w,
                                                      decoration: const BoxDecoration(
                                                        color: ColorConstants
                                                            .backgroundColor,
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child: Image.network(
                                                       'user.profileImage',
                                                        fit: BoxFit.fitWidth,
                                                        errorBuilder: (context,
                                                            error,
                                                            stackTrace){
                                                          return Image.asset(
                                                              'assets/images/logo.png',
                                                              height: 100.h,
                                                              width: 100.w,
                                                              fit: BoxFit
                                                                  .fitWidth);
                                                        },),
                                                    ),

                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                    EdgeInsets.only(
                                                        right:
                                                        10.w),
                                                    height: 95.0.h,
                                                    width:
                                                    double.infinity,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Colors
                                                          .transparent,
                                                      borderRadius:
                                                      BorderRadius
                                                          .only(
                                                        topRight: Radius
                                                            .circular(
                                                            15.0),
                                                        bottomRight: Radius
                                                            .circular(
                                                            15.0),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      margin: EdgeInsets
                                                          .only(
                                                          bottom:
                                                          10.h),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            width: 210.w,
                                                            child: Text(
                                                              'user.name',
                                                              softWrap: true,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              textScaleFactor:
                                                              1.0,
                                                              style:
                                                              TextStyle(
                                                                fontFamily:
                                                                'DMSans-Bold',
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                fontSize:
                                                                22.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                              5.h),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left:
                                                                3.w,
                                                                right:
                                                                3.w,
                                                                top:
                                                                2.h,
                                                                bottom:
                                                                1.h),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    4),
                                                                border: Border
                                                                    .all(
                                                                    color:
                                                                    Colors
                                                                        .white,
                                                                    width: 1)),
                                                            child: Text(
                                                              'user.category',
                                                              textScaleFactor:
                                                              1.0,
                                                              style:
                                                              TextStyle(
                                                                fontSize:
                                                                10.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                alignment:
                                                Alignment.center,
                                                height: 50.0.h,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                      Alignment
                                                          .center,
                                                      child: RatingBar
                                                          .builder(
                                                        initialRating: 3,
                                                        minRating: 1,
                                                        direction: Axis
                                                            .horizontal,
                                                        allowHalfRating:
                                                        true,
                                                        itemCount: 5,
                                                        itemSize: 22,
                                                        itemPadding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            0.0),
                                                        itemBuilder:
                                                            (context,
                                                            _) =>
                                                        const Icon(
                                                          Icons
                                                              .star_rounded,
                                                          color: ColorConstants
                                                              .themeBlue,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {},
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    bottom: 10.h),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 23.sp,
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        InkWell(
                                          child: Text(
                                            "About",
                                            textScaleFactor: 1.0,
                                            style:
                                            TextStyle(fontSize: 20.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Container(
                                      height: 60.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              5.r)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 40.h,
                                    ),

                                    Container(
                                      height: 410.h,
                                      // padding: EdgeInsets.only(top: 15.h),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft:
                                          Radius.circular(10.0),
                                          bottomRight:
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      // physics: NeverScrollableScrollPhysics(),
                      children:
                      snapshot.data!
                          .map((user) =>
                          Container(
                            // color: ColorConstants.backgroundColor,
                            margin: EdgeInsets.only(
                              top: 10.h,
                            ),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 10.w, left: 10.w),
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r)),
                                          child: Image.asset(
                                              'assets/images/curveimg.png',
                                              height: 95.h,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Stack(
                                              children: [
                                                Column(children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.w),
                                                    height: 95.0.h,
                                                    width: double.infinity,
                                                    color:
                                                    Colors.transparent,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.w),
                                                    height: 50.0.h,
                                                    width: double.infinity,
                                                  ),
                                                ]),
                                                Positioned(
                                                  top: 18,
                                                  left: 20,
                                                  child: Container(
                                                      margin: EdgeInsets
                                                          .only(
                                                          left: 5.w,
                                                          right: 5.w),
                                                      width: 110.0.w,
                                                      height: 110.0.h,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 3,
                                                            color: Colors
                                                                .white),
                                                        color: Colors.white,
                                                        shape: BoxShape
                                                            .circle,
                                                      ),
                                                      child:
                                                      (user.profileImage
                                                          .isNotEmpty) ?
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: ColorConstants
                                                                .backgroundColor,
                                                            shape: BoxShape
                                                                .circle,
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    user
                                                                        .profileImage)
                                                            )
                                                        ),
                                                      ) :
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                          color: ColorConstants
                                                              .backgroundColor,
                                                          shape: BoxShape
                                                              .circle,
                                                        ),

                                                        child: Image.asset(
                                                            'assets/images/logo.png',
                                                            height: 100.h,
                                                            width: 100.w,
                                                            fit: BoxFit
                                                                .fitWidth),
                                                      ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(
                                                            right:
                                                            10.w),
                                                        height: 95.0.h,
                                                        width:
                                                        double.infinity,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topRight: Radius
                                                                .circular(
                                                                15.0),
                                                            bottomRight: Radius
                                                                .circular(
                                                                15.0),
                                                          ),
                                                        ),
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                              bottom:
                                                              10.h),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              SingleChildScrollView(
                                                                scrollDirection: Axis
                                                                    .horizontal,
                                                                child: Text(
                                                                  user
                                                                      .name,
                                                                  // overflow: TextOverflow
                                                                  //     .ellipsis,
                                                                  softWrap: true,
                                                                  textScaleFactor:
                                                                  1.0,
                                                                  style:
                                                                  TextStyle(
                                                                    fontFamily:
                                                                    'DMSans-Bold',
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    fontSize:
                                                                    22.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                  5.h),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    3.w,
                                                                    right:
                                                                    3.w,
                                                                    top:
                                                                    2.h,
                                                                    bottom:
                                                                    1.h),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        4),
                                                                    border: Border
                                                                        .all(
                                                                        color:
                                                                        Colors
                                                                            .white,
                                                                        width: 1)),
                                                                child: Text(
                                                                  user
                                                                      .category,
                                                                  textScaleFactor:
                                                                  1.0,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    10.sp,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment:
                                                    Alignment.topCenter,
                                                    height: 50.0.h,
                                                    width: double.infinity,
                                                    child: Container(
                                                      margin: EdgeInsets
                                                          .only(top: 5.h),
                                                      child: Row(
                                                        children: [
                                                          RatingBar
                                                              .builder(
                                                            initialRating:
                                                            (user
                                                                .average_rating
                                                                .toString() ==
                                                                'null')
                                                                ? 0.0
                                                                : double
                                                                .parse(
                                                                user
                                                                    .average_rating),
                                                            minRating: 0,
                                                            ignoreGestures: true,
                                                            direction: Axis
                                                                .horizontal,
                                                            allowHalfRating:
                                                            true,
                                                            itemCount: 5,
                                                            itemSize: 22,
                                                            itemPadding:const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                0.0),
                                                            itemBuilder:
                                                                (context,
                                                                _) =>
                                                                const Icon(
                                                                  Icons
                                                                      .star_rounded,
                                                                  color: ColorConstants
                                                                      .themeBlue,
                                                                ),
                                                            onRatingUpdate:
                                                                (
                                                                rating) {},
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  1.h,
                                                                  bottom:
                                                                  1.h,
                                                                  left:
                                                                  4.w,
                                                                  right: 5
                                                                      .w),
                                                              decoration:
                                                              BoxDecoration(
                                                                color: ColorConstants
                                                                    .themeBlue,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    2.r),
                                                              ),
                                                              child:Row(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .star_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 15,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    1.w,
                                                                  ),
                                                                  Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          top:
                                                                          1),
                                                                      child:
                                                                      Text(
                                                                        (user
                                                                            .average_rating
                                                                            .toString() ==
                                                                            'null')
                                                                            ? '0'
                                                                            : double
                                                                            .parse(
                                                                            user
                                                                                .average_rating)
                                                                            .toStringAsFixed(
                                                                            1),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                      ))
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                        bottom: 10.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              size: 23.sp,
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              "About",
                                              textScaleFactor: 1.0,
                                              style:
                                              TextStyle(fontSize: 20.sp),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),

                                        (user.description.contains('null') ||
                                            user.description.isEmpty) ?
                                        Container() :
                                        Container(
                                          margin: EdgeInsets.only(left: 5.w),
                                          child: ReadMoreText(
                                            user.description,
                                            trimLines: 5,
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                            colorClickableText:
                                            ColorConstants.themeBlue,
                                            trimMode: TrimMode.Length,
                                            trimCollapsedText: ' Show more',
                                            trimExpandedText: ' Show less',
                                            lessStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                ColorConstants.themeBlue),
                                            moreStyle:const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.themeBlue,
                                              decoration:
                                              TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: DefaultTabController(
                                      length: 3,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40.h,
                                            child: TabBar(
                                              isScrollable: true,
                                              unselectedLabelColor:
                                              Colors.black,
                                              indicatorSize:
                                              TabBarIndicatorSize.tab,
                                              indicator: BoxDecoration(
                                                  borderRadius: _selectedIndex ==
                                                      0
                                                      ? const BorderRadius
                                                      .only(
                                                      topLeft:
                                                      Radius.circular(
                                                          10.0))
                                                      : _selectedIndex == 1
                                                      ? const BorderRadius
                                                      .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          0.0),
                                                      topRight: Radius
                                                          .circular(
                                                          0.0))
                                                      : const BorderRadius
                                                      .only(
                                                      topRight: Radius
                                                          .circular(
                                                          10.0)),
                                                 color: ColorConstants
                                                     .themeBlue
                                              ),
                                              controller: _tabController,
                                              tabs: [
                                                Tab(
                                                  child: Container(
                                        //   padding:const EdgeInsets.only(right: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .settings_outlined,
                                                          size: 18.sp,
                                                        ),
                                                       // SizedBox(width:5.w,),
                                                        Text("Service",
                                                              style: TextStyle(
                                                              fontSize:
                                                              15.sp, fontWeight: FontWeight.w500),
                                                          textScaleFactor:
                                                          1.0,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 18.sp,
                                                      ),
                                                        /// SizedBox(width: 5.w,),

                                                         Text(
                                                          "Experience",
                                                          style: TextStyle(

                                                              fontSize:
                                                              15.sp,fontWeight: FontWeight.w500),
                                                          textScaleFactor:
                                                          1.0,

                                                                                                                   )
                                                    ],
                                                  ),
                                                ),
                                                Tab(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .work_outline_rounded,
                                                        size: 23.sp,
                                                      ),
                                                      SizedBox(width:5.w),
                                                      Text(
                                                        "Education",
                                                        style: TextStyle(
                                                            fontSize:
                                                            15.sp,fontWeight: FontWeight.w500),
                                                        textScaleFactor:
                                                        1.0,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          Container(
                                              height: 250.h,
                                              // padding: EdgeInsets.only(top: 15.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius
                                                    .only(
                                                  bottomLeft:
                                                  Radius.circular(10.0),
                                                  bottomRight:
                                                  Radius.circular(10.0),
                                                ),
                                              ),

                                              child: TabBarView(
                                                  controller: _tabController,
                                                  children: <Widget>[


                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                top: 10.h,
                                                                bottom: 10.h,
                                                                right: 10.h),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                (
                                                                    user
                                                                        .minimumCharges
                                                                        .isEmpty)
                                                                    ?
                                                                Container()
                                                                    :
                                                                Text(
                                                                  'Minimum charges: Rs ' +
                                                                      user
                                                                          .minimumCharges,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                      fontSize: 12
                                                                          .sp),
                                                                ),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                (user
                                                                    .minimumCharges
                                                                    .isEmpty ||
                                                                    user
                                                                        .totalExperience
                                                                        .isEmpty)
                                                                    ?
                                                                Container()
                                                                    :
                                                                Text('|'),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                Text(
                                                                  user
                                                                      .totalExperience,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                      fontSize: 12
                                                                          .sp),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          (user.ourServices
                                                              .isNotEmpty) ?
                                                          Container(
                                                            padding: EdgeInsets
                                                                .only(
                                                                left: 10.w,
                                                                right: 10.w),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                for (int i = 0; i <
                                                                    user
                                                                        .ourServices
                                                                        .length; i++)
                                                                  Container(
                                                                    alignment: Alignment
                                                                        .topLeft,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Container(
                                                                            padding: EdgeInsets
                                                                                .all(
                                                                                8),
                                                                            child: Text(
                                                                              '• ' +
                                                                                  user
                                                                                      .ourServices[i]['service'],
                                                                              style: TextStyle(
                                                                                  fontSize: 18
                                                                                      .sp),
                                                                              textScaleFactor: 1.0,)),


                                                                        (user
                                                                            .ourServices
                                                                            .length !=
                                                                            i +
                                                                                1)
                                                                            ?
                                                                        Divider(

                                                                          color: ColorConstants
                                                                              .dividerGrey,
                                                                          height: 0,
                                                                          thickness: 1,
                                                                          indent: 10.0,
                                                                          endIndent: 10.0,
                                                                        )
                                                                            : Container()
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],),
                                                          )
                                                              : Center(
                                                              child: Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                      top: 90
                                                                          .h,
                                                                      bottom: 90
                                                                          .h),
                                                                  child: Center(
                                                                    child: Text(
                                                                        "No Services"),))),
                                                        ],
                                                      ),
                                                    ),


                                                    (user.experience
                                                        .isNotEmpty) ?
                                                    Container(
                                                        padding:
                                                        EdgeInsets.all(10),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              for (int i = 0; i <
                                                                  user
                                                                      .experience
                                                                      .length; i++)
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .zero,
                                                                  child: IntrinsicHeight(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Expanded(
                                                                          child: IntrinsicHeight(
                                                                            child: Row(
                                                                              children:[
                                                                                Container(
                                                                                  margin: EdgeInsets
                                                                                      .only(
                                                                                      left: 5
                                                                                          .w,
                                                                                      right: 10
                                                                                          .w),
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons
                                                                                            .circle_rounded,
                                                                                        color: ColorConstants
                                                                                            .themeBlue,
                                                                                        size: 15
                                                                                            .sp,),
                                                                                      (user
                                                                                          .experience
                                                                                          .length !=
                                                                                          i +
                                                                                              1)
                                                                                          ?
                                                                                      const VerticalDivider(
                                                                                        color: Colors
                                                                                            .grey,
                                                                                        indent: 15,
                                                                                        thickness: 2,
                                                                                      ): Container(),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 9,
                                                                                  child: Column(
                                                                                    crossAxisAlignment:
                                                                                    CrossAxisAlignment
                                                                                        .start,
                                                                                    children: [
                                                                                      Text(
                                                                                        user
                                                                                            .experience[i]['experience_title']
                                                                                            .toString(),
                                                                                        style: const TextStyle(
                                                                                            fontWeight: FontWeight
                                                                                                .bold),),
                                                                                      Text(
                                                                                          user
                                                                                              .experience[i]['where'
                                                                                              .toString()]),
                                                                                      Text(
                                                                                          user
                                                                                              .experience[i]['details']
                                                                                              .toString(),
                                                                                          textAlign: TextAlign
                                                                                              .justify),
                                                                                      Text(
                                                                                          user
                                                                                              .experience[i]['location']
                                                                                              .toString()),
                                                                                      Text(
                                                                                          user
                                                                                              .experience[i]['start_date']
                                                                                              .toString()),
                                                                                      Text(
                                                                                          user
                                                                                              .experience[i]['end_date']
                                                                                              .toString()),
                                                                                      SizedBox(
                                                                                        height: 15
                                                                                            .h,)
                                                                                    ],
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
                                                            ],
                                                          ),
                                                        ))
                                                        : Center(child: Text(
                                                        "No Experience"),),


                                                    (user.education
                                                        .isNotEmpty) ?
                                                    Container(
                                                        padding:
                                                        EdgeInsets.all(10),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              for (int i = 0; i <
                                                                  user
                                                                      .education
                                                                      .length; i++)
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                      child: Row(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Container(
                                                                            height: 50
                                                                                .h,
                                                                            width: 50
                                                                                .w,
                                                                            margin: EdgeInsets
                                                                                .only(
                                                                                left:
                                                                                10
                                                                                    .w,
                                                                                right:
                                                                                20
                                                                                    .w),
                                                                            // padding: EdgeInsets.only(left:5.w, right:5.w),
                                                                            decoration: new BoxDecoration(
                                                                              color: Colors
                                                                                  .red,
                                                                              shape: BoxShape
                                                                                  .circle,
                                                                            ),

                                                                            child:
                                                                            Image
                                                                                .asset(
                                                                              'assets/images/educationLogo.jpeg',
                                                                              // width: 100.w,
                                                                              // height: 100.h,
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                            ),


                                                                          ),
                                                                          Expanded(
                                                                            flex: 5,
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                Text(
                                                                                  user
                                                                                      .education[i]['title']
                                                                                      .toString(),
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight
                                                                                          .bold),),
                                                                                Text(
                                                                                    user
                                                                                        .education[i]['educationFrom']
                                                                                        .toString()),
                                                                                Text(
                                                                                    user
                                                                                        .education[i]['completedIn']
                                                                                        .toString()),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    (user
                                                                        .education
                                                                        .length !=
                                                                        i +
                                                                            1)
                                                                        ?
                                                                    const Divider(
                                                                      color: ColorConstants
                                                                          .dividerGrey,
                                                                      height: 0,
                                                                      thickness: 1,
                                                                      indent: 10.0,
                                                                      endIndent: 10.0,
                                                                    )
                                                                        : Container()
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ))
                                                        : const Center(
                                                      child: Text(
                                                          "No Education"),),
                                                  ])
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0.r),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.only(left: 5.w),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.wallet_giftcard_rounded,
                                                size: 23.sp,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "Awards/Achievement",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 20.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        (user.awardAchivement.isNotEmpty) ?
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 20.w,),
                                          child: NotificationListener<
                                              OverscrollIndicatorNotification>(
                                            onNotification: (
                                                OverscrollIndicatorNotification
                                                overscroll) {
                                              overscroll.disallowIndicator();
                                              return true;
                                            },
                                            child: Container(

                                              height: 150.h,
                                              // margin: EdgeInsetsDirectional
                                              //     .symmetric(
                                              //     horizontal: 5.h),
                                              child: ListView(
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  children: <Widget>[
                                                    for (int i = 0; i <
                                                        user.awardAchivement
                                                            .length; i++)

                                                      GestureDetector(
                                                        onTap: () async {
                                                          await showDialog<
                                                              void>(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              // user must tap button!
                                                              builder: (
                                                                  BuildContext context) {
                                                                return AlertDialog(
                                                                  contentPadding: const EdgeInsets
                                                                      .all(5),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        8.0),
                                                                  ),
                                                                  content: SingleChildScrollView(
                                                                    child: Column(
                                                                      children: [
                                                                        Container(

                                                                          child: Column(
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator
                                                                                      .of(
                                                                                      context)
                                                                                      .pop();
                                                                                },
                                                                                child: Align(
                                                                                  alignment: Alignment
                                                                                      .topRight,
                                                                                  child: Transform
                                                                                      .rotate(
                                                                                    angle: 45 *
                                                                                        math
                                                                                            .pi /
                                                                                        180,
                                                                                    child: const Icon(
                                                                                        Icons
                                                                                            .add_circle_rounded),),),
                                                                              ),
                                                                              (user
                                                                                  .awardAchivement[i]['image'] ==
                                                                                  '')
                                                                                  ?
                                                                              Image
                                                                                  .asset(
                                                                                'assets/images/logo.png',)
                                                                                  :
                                                                              Image
                                                                                  .network(
                                                                                  user
                                                                                      .awardAchivement[i]['image'],
                                                                                  fit: BoxFit
                                                                                      .fitWidth),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 120.w,

                                                          margin: EdgeInsets
                                                              .only(
                                                              left: 5.w,
                                                              right: 5.w),
                                                          padding: EdgeInsets
                                                              .only(
                                                              top: 5.h,
                                                              bottom: 10.h,
                                                              left: 5.w,
                                                              right: 5.w),
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.1
                                                                      .w),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                      10.r))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: <
                                                                Widget>[
                                                              ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10.r),
                                                                child:
                                                                FadeInImage(
                                                                  height: 100
                                                                      .h,
                                                                  width: 100
                                                                      .w,
                                                                  fadeOutCurve: Curves
                                                                      .linear,
                                                                  placeholderFit: BoxFit
                                                                      .fitWidth,
                                                                  placeholder: const AssetImage(
                                                                    'assets/images/logo.png',),
                                                                  image: NetworkImage(
                                                                      user
                                                                          .awardAchivement[i]['image']),
                                                                  imageErrorBuilder: (
                                                                      context,
                                                                      error,
                                                                      stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                        'assets/images/logo.png',
                                                                        height: 100
                                                                            .h,
                                                                        width: 100
                                                                            .w,
                                                                        fit: BoxFit
                                                                            .fitWidth);
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),

                                                              Flexible(
                                                                child: Text(
                                                                  user.awardAchivement[i]['title'],
                                                                  overflow: TextOverflow.ellipsis,
                                                                  textScaleFactor: 1.0,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 13.sp,
                                                                      color: Colors.black
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                user
                                                                    .awardAchivement[i]['year'],
                                                                textScaleFactor: 1.0,
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    fontSize: 13
                                                                        .sp,
                                                                    color: Colors
                                                                        .black
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                  ]),
                                            ),
                                          ),
                                        ) :
                                        SizedBox(
                                          height: 100.h,
                                          child: const Center(
                                              child: Text('No Awards')),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: Column(
                                      children: [
                                        Container(
                                   
                                          margin: EdgeInsets.only(left: 5.w),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.collections_rounded,
                                                size: 23.sp,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "Gallery",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 20.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        (user.gallery.isNotEmpty) ?
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 10.w),
                                          child: NotificationListener<OverscrollIndicatorNotification>(
                                            onNotification: (OverscrollIndicatorNotification
                                                overscroll) {
                                              overscroll.disallowIndicator();
                                              return true;
                                            },
                                            child: Container(
                                              height: 100.h,
                                              margin: EdgeInsetsDirectional
                                                  .symmetric(
                                                  horizontal: 10.h),
                                              child: ListView(
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  children: <Widget>[
                                                    for (int i = 0; i <
                                                        user.gallery
                                                            .length; i++)
                                                      InkWell(
                                                        onTap: (){
                                                         print('vjhvjh ${user.gallery[i]['image']}');
                                                          Navigator.of(context)
                                                              .push(
                                                              MaterialPageRoute(
                                                                builder: (_) => GalleryWidget(
                                                                        galleryImages: [
                                                                          for(int g = 0; g <
                                                                              user
                                                                                  .gallery
                                                                                  .length; g++)
                                                                            user
                                                                                .gallery[g]['image'],

                                                                        ]),
                                                              ));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                              right: 10.w),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.r),
                                                            child:
                                                            FadeInImage(
                                                              height: 100.h,
                                                              width: 100.w,
                                                              fadeOutCurve: Curves
                                                                  .linear,
                                                              placeholderFit: BoxFit
                                                                  .fitWidth,
                                                              placeholder: const AssetImage(
                                                                'assets/images/logo.png',),
                                                              image: NetworkImage(
                                                                  user
                                                                      .gallery[i]['image']),
                                                              imageErrorBuilder: (
                                                                  context,
                                                                  error,
                                                                  stackTrace) {
                                                                return Image
                                                                    .asset(
                                                                    'assets/images/noimage.jpeg',
                                                                    height: 100
                                                                        .h,
                                                                    width: 100
                                                                        .w,
                                                                    fit: BoxFit
                                                                        .fitWidth);
                                                              },
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ]),
                                            ),
                                          ),
                                        ) :
                                        Container(
                                          height: 100.h,
                                          child: const Center(
                                              child: Text('No Images')),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5.w, right: 5.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_rounded,
                                                    size: 23.sp,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    "Review",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 20.sp),
                                                  )
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  SharedPreferences profilePrefs = await SharedPreferences.getInstance();
                                                  profilePrefs.setString('listerId', user.id);
                                                  feedbackDialog(context);
                                                },

                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 4.w,
                                                      right: 4.w,
                                                      top: 4.h,
                                                      bottom: 3.h),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          4.r),
                                                      border: Border.all(
                                                          color:
                                                          ColorConstants
                                                              .themeBlue,
                                                          width: 1)),
                                                  child: Text(
                                                    'Leave Feedback',
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: ColorConstants
                                                          .themeBlue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),

                                        (user.feedback.isNotEmpty) ?
                                        Container(
                                          // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child: ImageSlideshow(
                                              width: double.infinity,
                                              height: 100,
                                              initialPage: 0,
                                              indicatorColor:
                                              ColorConstants.themeBlue,
                                              indicatorBackgroundColor:
                                              Color(0xffC9E9FC),
                                              onPageChanged: (value) {
                                                print('Page changed: $value');
                                              },
                                              // autoPlayInterval: 5000,
                                              // isLoop: true,
                                              children: [


                                                // for (int i=1; i<user.feedback.length; i+=2)
                                                for (int a = 0; a <
                                                    user.feedback.length;
                                                a += 2)

                                                  Container(
                                                      margin:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.w),
                                                      child: IntrinsicHeight(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    (user
                                                                        .feedback[a]['image']
                                                                        .isNotEmpty)
                                                                        ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left: 5
                                                                              .w,
                                                                          right: 5
                                                                              .w),
                                                                      height: 40
                                                                          .h,
                                                                      width: 40
                                                                          .w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: new DecorationImage(
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                              image:
                                                                              NetworkImage(
                                                                                  user
                                                                                      .feedback[a]['image']))),
                                                                    )
                                                                        : Container(
                                                                      height: 40
                                                                          .h,
                                                                      width: 40
                                                                          .w,
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left: 5
                                                                              .w,
                                                                          right: 5
                                                                              .w),

                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: ColorConstants
                                                                              .backgroundColor),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/logo.png',
                                                                        // width: 50.w,
                                                                        fit: BoxFit
                                                                            .fitWidth,
                                                                      ),
                                                                    ),


                                                                    Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [

                                                                        Text(
                                                                          user
                                                                              .feedback[a]['name'],
                                                                          textScaleFactor:
                                                                          1.0,
                                                                          style:
                                                                          TextStyle(
                                                                              fontSize: 16
                                                                                  .sp),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                          RatingBar
                                                                              .builder(
                                                                            ignoreGestures: true,
                                                                            initialRating: (user
                                                                                .feedback[a]['rating']
                                                                                .toString() ==
                                                                                'null')
                                                                                ? 0.0
                                                                                : double
                                                                                .parse(
                                                                                user
                                                                                    .feedback[a]['rating']),
                                                                            minRating:
                                                                            0,
                                                                            direction:
                                                                            Axis
                                                                                .horizontal,
                                                                            allowHalfRating:
                                                                            true,
                                                                            itemCount:
                                                                            5,
                                                                            itemSize:
                                                                            12,
                                                                            itemPadding:
                                                                            EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 0.0),
                                                                            itemBuilder: (
                                                                                context,
                                                                                _) =>
                                                                                Icon(
                                                                                  Icons
                                                                                      .star,
                                                                                  color: Colors
                                                                                      .amber,
                                                                                ),
                                                                            onRatingUpdate:
                                                                                (
                                                                                rating) {
                                                                              print(
                                                                                  rating);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 120
                                                                              .w,
                                                                          child: Text(
                                                                              user
                                                                                  .feedback[a]['feedback'],
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow
                                                                                  .ellipsis,
                                                                              textScaleFactor:
                                                                              1.0,
                                                                              style:
                                                                              TextStyle(
                                                                                  fontSize: 13
                                                                                      .sp)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              color:
                                                              Colors.grey,
                                                              //color of divider
                                                              width: 20,
                                                              //width space of divider
                                                              thickness: 0.5,
                                                              //thickness of divier line
                                                              indent: 5,
                                                              //Spacing at the top of divider.
                                                              endIndent:
                                                              25, //Spacing at the bottom of divider.
                                                            ),

                                                            // (user.feedback.length!= a+1)?a:a+1
                                                            (user.feedback
                                                                .length !=
                                                                a + 1) ?
                                                            Expanded(
                                                              child: Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    (user
                                                                        .feedback[user
                                                                        .feedback
                                                                        .length !=
                                                                        a + 1
                                                                        ? a +
                                                                        1
                                                                        : a]['image']
                                                                        .isNotEmpty)
                                                                        ?
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left: 5
                                                                              .w,
                                                                          right: 5
                                                                              .w),
                                                                      height: 40
                                                                          .h,
                                                                      width: 40
                                                                          .w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: new DecorationImage(
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                              image:
                                                                              NetworkImage(
                                                                                  user
                                                                                      .feedback[user
                                                                                      .feedback
                                                                                      .length !=
                                                                                      a +
                                                                                          1
                                                                                      ? a +
                                                                                      1
                                                                                      : a]['image']))),
                                                                    )
                                                                        :
                                                                    Container(
                                                                      height: 40
                                                                          .h,
                                                                      width: 40
                                                                          .w,
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left: 5
                                                                              .w,
                                                                          right: 5
                                                                              .w),

                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: ColorConstants
                                                                              .backgroundColor),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/logo.png',
                                                                        // width: 50.w,
                                                                        fit: BoxFit
                                                                            .fitWidth,
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Text(
                                                                          user
                                                                              .feedback[user
                                                                              .feedback
                                                                              .length !=
                                                                              a +
                                                                                  1
                                                                              ? a +
                                                                              1
                                                                              : a]['name'],
                                                                          maxLines: 2,
                                                                          textScaleFactor:
                                                                          1.0,
                                                                          style:
                                                                          TextStyle(
                                                                              fontSize: 16
                                                                                  .sp),
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                          RatingBar
                                                                              .builder(
                                                                            ignoreGestures: true,
                                                                            initialRating:
                                                                            (user
                                                                                .feedback[user
                                                                                .feedback
                                                                                .length !=
                                                                                a +
                                                                                    1
                                                                                ? a +
                                                                                1
                                                                                : a]['rating']
                                                                                .toString() ==
                                                                                'null')
                                                                                ? 0.0
                                                                                : double
                                                                                .parse(
                                                                                user
                                                                                    .feedback[user
                                                                                    .feedback
                                                                                    .length !=
                                                                                    a +
                                                                                        1
                                                                                    ? a +
                                                                                    1
                                                                                    : a]['rating']),
                                                                            minRating:
                                                                            0,
                                                                            direction:
                                                                            Axis
                                                                                .horizontal,
                                                                            allowHalfRating:
                                                                            true,
                                                                            itemCount:
                                                                            5,
                                                                            itemSize:
                                                                            12,
                                                                            itemPadding:
                                                                            EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 0.0),
                                                                            itemBuilder: (
                                                                                context,
                                                                                _) =>
                                                                                Icon(
                                                                                  Icons
                                                                                      .star,
                                                                                  color: Colors
                                                                                      .amber,
                                                                                ),
                                                                            onRatingUpdate:
                                                                                (
                                                                                rating) {
                                                                              print(
                                                                                  rating);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 120
                                                                              .w,
                                                                          child: Text(
                                                                              user
                                                                                  .feedback[user
                                                                                  .feedback
                                                                                  .length !=
                                                                                  a +
                                                                                      1
                                                                                  ? a +
                                                                                  1
                                                                                  : a]['feedback'],
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow
                                                                                  .ellipsis,
                                                                              textScaleFactor:
                                                                              1.0,
                                                                              style:
                                                                              TextStyle(
                                                                                  fontSize: 13
                                                                                      .sp)),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ) :
                                                            SizedBox(
                                                              width: 170.w,)
                                                          ],
                                                        ),
                                                      )),
                                              ],
                                            ),
                                          ),
                                        ) :
                                        Container(
                                          height: 100.h,
                                          child: Center(child: Text(
                                              'Be the first to share what you think!')),)
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                          left: 10, top: 15, bottom: 15,),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person_rounded,
                                              size: 23.sp,
                                            ),
                                            SizedBox(width: 5.w,),
                                            Text(
                                              "Similar Profiles",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyResult(
                                                        title: 'FindPro',
                                                        api: 'api3',)),
                                            );
                                          },
                                          icon: Icon(Icons
                                              .arrow_circle_right_outlined)),
                                    ],
                                  ),
                                  NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (
                                        OverscrollIndicatorNotification overscroll) {
                                      overscroll.disallowIndicator();
                                      return true;
                                    },
                                    child: FutureBuilder<List<Users>>(
                                      future: fetchSimilarJSONData(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Shimmer.fromColors(
                                            baseColor: ColorConstants
                                                .lightGrey,
                                            highlightColor: Colors.white,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [

                                                Container(
                                                  margin: EdgeInsets.all(10),

                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceAround,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10.r),
                                                          child:
                                                          Container(
                                                            height: 100.h,
                                                            width: 100.w,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey,
                                                                borderRadius: BorderRadius
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
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),

                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 100.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 90.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
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
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceAround,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10.r),
                                                          child:
                                                          Container(
                                                            height: 100.h,
                                                            width: 100.w,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey,
                                                                borderRadius: BorderRadius
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
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),

                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 100.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 90.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
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
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceAround,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10.r),
                                                          child:
                                                          Container(
                                                            height: 100.h,
                                                            width: 100.w,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey,
                                                                borderRadius: BorderRadius
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
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),

                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 100.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  10.r)),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Container(
                                                          width: 90.w,
                                                          height: 20.h,
                                                          alignment: Alignment
                                                              .center,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey,
                                                              borderRadius: BorderRadius
                                                                  .circular(
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
                                          height: 275.h,
                                          child: (snapshot.data!.length <= 1)
                                              ?
                                          Container(
                                            child: Center(child: Text(
                                                'Profile not found')),)
                                              :
                                          ListView(
                                            scrollDirection: Axis.horizontal,
                                            // physics: NeverScrollableScrollPhysics(),
                                            children: snapshot.data!
                                                .map((users) =>
                                                Column(
                                                  children: [
                                                    Visibility(
                                                      visible: (users.id !=
                                                          user.id &&
                                                          users.id != id)
                                                          ? true
                                                          : false,
                                                      child:
                                                      GestureDetector(
                                                        onTap: () async {
                                                          print(
                                                              'hgjhgjh ${users
                                                                  .id}');
                                                          print(
                                                              'hgjhgjh ${id}');
                                                          SharedPreferences prefs = await SharedPreferences
                                                              .getInstance();
                                                          prefs.setString(
                                                              'link',
                                                              users.link);
                                                          prefs.setString(
                                                              'category',
                                                              users.category);
                                                          Navigator.of(
                                                              context).push(
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      MyProfile()));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .all(5.0),

                                                          width: 151,
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .white,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      topRight: Radius
                                                                          .circular(
                                                                          10),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                          10)),
                                                                  child: FadeInImage(
                                                                    height: 150
                                                                        .h,
                                                                    fadeOutCurve: Curves
                                                                        .linear,
                                                                    placeholderFit: BoxFit
                                                                        .fitWidth,
                                                                    placeholder: const AssetImage(
                                                                      'assets/images/logo.png',),
                                                                    image: NetworkImage(
                                                                        users
                                                                            .profileImage),
                                                                    imageErrorBuilder: (
                                                                        context,
                                                                        error,
                                                                        stackTrace) {
                                                                      return Image
                                                                          .asset(
                                                                          'assets/images/logo.png',
                                                                          height: 150
                                                                              .h,
                                                                          fit: BoxFit
                                                                              .fitWidth);
                                                                    },
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left: 5.w,
                                                                    bottom: 5
                                                                        .h),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      width: 151
                                                                          .w,
                                                                      child: Text(
                                                                        users
                                                                            .name,
                                                                        textScaleFactor:
                                                                        1.0,
                                                                        maxLines: 1,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style: TextStyle(
                                                                          fontSize: 20
                                                                              .sp,
                                                                          color:
                                                                          Colors
                                                                              .black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: RatingBar
                                                                          .builder(
                                                                        initialRating:
                                                                        (users
                                                                            .average_rating
                                                                            .toString() ==
                                                                            '')
                                                                            ? 0.0
                                                                            : double
                                                                            .parse(
                                                                            users
                                                                                .average_rating),
                                                                        minRating: 0,
                                                                        direction: Axis
                                                                            .horizontal,
                                                                        allowHalfRating:
                                                                        true,
                                                                        itemCount: 5,
                                                                        itemSize: 12,
                                                                        itemPadding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                            0.0),
                                                                        itemBuilder:
                                                                            (
                                                                            context,
                                                                            _) =>
                                                                        const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: Colors
                                                                              .amber,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (
                                                                            rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5
                                                                          .h,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                          left: 3
                                                                              .w,
                                                                          right: 3
                                                                              .w,
                                                                          top: 2
                                                                              .h,
                                                                          bottom:
                                                                          1
                                                                              .h),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              4),
                                                                          border: Border
                                                                              .all(
                                                                              color: Colors
                                                                                  .grey,
                                                                              width: 1)),
                                                                      child: Text(
                                                                        users
                                                                            .category,
                                                                        textScaleFactor:
                                                                        1.0,
                                                                        style: TextStyle(
                                                                          fontSize: 10
                                                                              .sp,
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5
                                                                          .h,
                                                                    ),
                                                                    Row(children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                          Icons
                                                                              .location_on_rounded,
                                                                          size: 15),
                                                                      Container(
                                                                        width: 130
                                                                            .w,
                                                                        child: Text(
                                                                          users
                                                                              .city,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          textScaleFactor:
                                                                          1.0,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              10
                                                                                  .sp),
                                                                        ),
                                                                      )
                                                                    ]),
                                                                    // SizedBox(
                                                                    //   height: 5.h,
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                                .toList(),
                                          ),
                                        );
                                      },
                                    ),

                                  ),

                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.all(10.0),
                                    height: 50.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                            bottom: 3.h,
                                            left: 10.w,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.circle_rounded,
                                                size: 10.sp,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "Open Now",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        (_timeContainer == false) ?
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              Timer(const Duration(
                                                  seconds: 1), () { // <-- Delay here
                                                setState(() {
                                                  if (_controller
                                                      .hasClients) {
                                                    final position = _controller
                                                        .position
                                                        .maxScrollExtent;
                                                    _controller.animateTo(
                                                      position,
                                                      duration: const Duration
                                                        (
                                                          milliseconds: 400
                                                      ),
                                                      curve: Curves.linear,
                                                    );
                                                  }
                                                });
                                              });

                                              swipeBottom();
                                              controller.reverse();
                                              _timeContainer = true;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin: const EdgeInsets.only(
                                              right: 5,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text('Check Opening Hour',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 13.sp),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      border: Border.all(
                                                          color: Colors.grey)
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),


                                              ],
                                            ),
                                          ),
                                        ) :
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              controller.forward();
                                              _timeContainer =
                                              false;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Check Opening Hour',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 13.sp),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      border: Border.all(
                                                          color: Colors.grey)
                                                  ),

                                                  child:
                                                  const Icon(Icons
                                                      .keyboard_arrow_up_rounded,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    width: _timeContainer ? 400.w : 400.w,
                                    height: _timeContainer ? 180.h : 0.h,
                                    margin:
                                    const EdgeInsets.fromLTRB(
                                        10.0, 0, 10, 10),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    duration: const Duration(
                                        milliseconds: 800),
                                    curve: Curves.linear,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print('sdfsdf ${user
                                                  .openingHours[0]['enhours']}');
                                            },
                                            child: Text(
                                              'Working hours',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight
                                                      .bold),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          (user.openingHours.isNotEmpty) ?
                                          Column(
                                              children: [

                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text('Monday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[0]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[0]['open'][0]
                                                        .toString() !=
                                                        'null') ?
                                                    Expanded(flex: 6,
                                                      child: (user
                                                          .openingHours[0]['enhours']
                                                          .toString() !=
                                                          "hourly") ?
                                                      Text(user
                                                          .openingHours[0]['enhours']
                                                          .toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp,
                                                              color: (user
                                                                  .openingHours[0]['enhours']
                                                                  .toString() ==
                                                                  "Closed full day")
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black)) :
                                                      Text(
                                                        // (user.openingHours[0]['open'].toString() == null)?
                                                          user
                                                              .openingHours[0]['open'][0]
                                                              .toString() +
                                                              ' to ' +
                                                              user
                                                                  .openingHours[0]['close'][0]
                                                                  .toString(),
                                                          // :'',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),
                                                    ) : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text('Tuesday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[1]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[1]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                        child: Text(
                                                          (user
                                                              .openingHours[1]['enhours']
                                                              .toString() !=
                                                              "hourly") ?
                                                          user
                                                              .openingHours[1]['enhours']
                                                              .toString() :
                                                          user
                                                              .openingHours[1]['open'][0]
                                                              .toString() +
                                                              ' to ' + user
                                                              .openingHours[1]['close'][0]
                                                              .toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp,
                                                              color: (user
                                                                  .openingHours[1]['enhours']
                                                                  .toString() ==
                                                                  "Closed full day")
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black),))
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text(
                                                          'Wednesday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[2]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[2]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                        child: Text(
                                                          (user
                                                              .openingHours[2]['enhours']
                                                              .toString() !=
                                                              "hourly") ?
                                                          user
                                                              .openingHours[2]['enhours']
                                                              .toString() :
                                                          user
                                                              .openingHours[2]['open'][0]
                                                              .toString() +
                                                              ' to ' + user
                                                              .openingHours[2]['close'][0]
                                                              .toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp,
                                                              color: (user
                                                                  .openingHours[2]['enhours']
                                                                  .toString() ==
                                                                  "Closed full day")
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black),))
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text(
                                                          'Thursday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[3]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[3]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                      child: Text(
                                                        (user
                                                            .openingHours[3]['enhours']
                                                            .toString() !=
                                                            "hourly") ?
                                                        user
                                                            .openingHours[3]['enhours']
                                                            .toString() :
                                                        user
                                                            .openingHours[3]['open'][0]
                                                            .toString() +
                                                            ' to ' + user
                                                            .openingHours[3]['close'][0]
                                                            .toString(),
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontSize: 13
                                                                .sp,
                                                            color: (user
                                                                .openingHours[3]['enhours']
                                                                .toString() ==
                                                                "Closed full day")
                                                                ? Colors.red
                                                                : Colors
                                                                .black),),)
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text('Friday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[4]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[4]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                        child: Text(
                                                          (user
                                                              .openingHours[4]['enhours']
                                                              .toString() !=
                                                              "hourly") ?
                                                          user
                                                              .openingHours[4]['enhours']
                                                              .toString() :
                                                          user
                                                              .openingHours[4]['open'][0]
                                                              .toString() +
                                                              ' to ' + user
                                                              .openingHours[4]['close'][0]
                                                              .toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp,
                                                              color: (user
                                                                  .openingHours[4]['enhours']
                                                                  .toString() ==
                                                                  "Closed full day")
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black),))
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text(
                                                          'Saturday',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp)),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[5]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[5]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                        child: Text(
                                                          (user
                                                              .openingHours[5]['enhours']
                                                              .toString() !=
                                                              "hourly") ?
                                                          user
                                                              .openingHours[5]['enhours']
                                                              .toString() :
                                                          user
                                                              .openingHours[5]['open'][0]
                                                              .toString() +
                                                              ' to ' + user
                                                              .openingHours[5]['close'][0]
                                                              .toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 13
                                                                  .sp,
                                                              color: (user
                                                                  .openingHours[5]['enhours']
                                                                  .toString() ==
                                                                  "Closed full day")
                                                                  ? Colors.red
                                                                  : Colors
                                                                  .black),))
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                                Row(crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                  children: [
                                                    Expanded(flex: 3,
                                                      child: Text('Sunday',
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontSize: 13
                                                                .sp),),),
                                                    Expanded(flex: 1,
                                                      child: Text(' - '),),
                                                    (user
                                                        .openingHours[6]['enhours']
                                                        .toString() !=
                                                        'null' || user
                                                        .openingHours[6]['open'][0]
                                                        .toString() !=
                                                        'null')
                                                        ?
                                                    Expanded(flex: 6,
                                                        child: Text(
                                                            (user
                                                                .openingHours[6]['enhours']
                                                                .toString() !=
                                                                "hourly") ?
                                                            user
                                                                .openingHours[6]['enhours']
                                                                .toString() :
                                                            user
                                                                .openingHours[6]['open'][0]
                                                                .toString() +
                                                                ' to ' + user
                                                                .openingHours[6]['close'][0]
                                                                .toString(),
                                                            textScaleFactor: 1.0,
                                                            style: TextStyle(
                                                                fontSize: 13
                                                                    .sp,
                                                                color: (user
                                                                    .openingHours[6]['enhours']
                                                                    .toString() ==
                                                                    "Closed full day")
                                                                    ? Colors
                                                                    .red
                                                                    : Colors
                                                                    .black)))
                                                        : Expanded(
                                                      flex: 6,
                                                      child: Container(),)
                                                  ],
                                                ),
                                              ]
                                          ) :
                                          Column(
                                            children: [
                                              SizedBox(height: 10.h,),
                                              Text('Not available'),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0.w),
                                        decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0.r),
                                        topRight: Radius.circular(15.0.r),
                                      ),
                                    ),
                                    child: Column(
                                         children:[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                BlurredPopup.withSlideUp(
                                                    screen: TestSlideUpScreen(
                                                      link: user.link,
                                                      number: user.mobile,
                                                      email: user.email,
                                                      address: user.address,
                                                      lat: user.latitude,
                                                      lon: user.longitude,
                                                      phoneStatus: user
                                                          .phonestatus,)
                                                ),
                                            );
                                          },
                                          child: GestureDetector(
                                            onVerticalDragUpdate:
                                                (dragUpdateDetails){
                                              Navigator.of(context).push(
                                                  BlurredPopup.withSlideUp(
                                                    settings: RouteSettings(

                                                    ),
                                                      screen: TestSlideUpScreen(
                                                        link: user.link,
                                                        number: user.mobile,
                                                        email: user.email,
                                                        address: user.address,
                                                        lat: user.latitude,
                                                        lon: user.longitude,
                                                        phoneStatus: user
                                                            .phonestatus,
                                                      )
                                                  )
                                              );
                                              // setState(() {
                                              //   _contact = !_contact;
                                              //   _controller.animateTo(
                                              //       _controller.position.maxScrollExtent,
                                              //       duration: Duration(seconds: 2),
                                              //       curve: Curves.fastOutSlowIn);
                                              //   // );
                                              // });
                                            },
                                              child:Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              decoration:BoxDecoration(
                                                color: ColorConstants
                                                    .themeBlue,
                                                borderRadius: BorderRadius
                                                    .only(
                                                  topLeft:
                                                  Radius.circular(15.0.r),
                                                  topRight:
                                                  Radius.circular(15.0.r),
                                                ),
                                              ),
                                              child:Column(
                                                      children:[
                                                      Container(
                                                      padding: const EdgeInsets.all(6),
                                                      child: Image.asset(
                                                      'assets/images/minus.png',
                                                       fit: BoxFit.fitWidth,
                                                       color: Colors.white,
                                                       height: 4.h,
                                                       width: 28.w,),
                                                     ),
                                                  Text('CONTACT NOW',
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 20.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                      ).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
     Future<void> feedbackDialog(BuildContext context) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
      setState((){
      print('sujegfdhfjdh $email');
      number = prefs.getString('phone') ?? '';
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      });
      print('dsfdsf');
      if(!mounted) return;
       return showDialog<void>(
        context: context,
         barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
           return (name.isNotEmpty) ?
          AlertDialog(
            title:const Text(
                'Leave Feedback',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorConstants.themeBlue)
            ),
            titleTextStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  TextButton(
                    onPressed: () async{
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            ColorConstants.themeBlue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                    color: ColorConstants.themeBlue)
                            ),
                        ),
                    ),
                    child: Text(
                        "Cancel", style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  TextButton(
                    onPressed: () async {
                      if (feedbackFormKey.currentState!.validate()) {
                        setState(() {
                          feedbackLoading = true;
                        });
                        feedback(feedbackName.text.toString(), feedbackText
                            .text.toString(),
                            feedbackNumber.text.toString(), feedbackEmail.text
                                .toString());
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                      backgroundColor: ColorConstants.themeBlue, //
                      // padding: const EdgeInsets.only(top: 10, bottom: 10),
                    ),
                    child: Text("SUBMIT", style: TextStyle(fontSize: 15.sp)),
                  ),
                ],
              ),
            ],
            content: RawScrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Form(
                  key: feedbackFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: feedbackName..text = name,
                        // initialValue: name,
                        // focusNode: _nodeFullname,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your name";
                          }
                          // else if (value.length <= 10) {
                          //   return "Describe yourself in greater than 10 words";
                          // }
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Fullname',
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          // FocusScope.of(context).requestFocus(_nodePassword);
                        },
                      ),
                      TextFormField(
                        autovalidateMode:AutovalidateMode.onUserInteraction,
                        controller: feedbackEmail..text = email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a valid email address";
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return "Enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          // FocusScope.of(context).requestFocus(_nodeFullname);
                        },
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: feedbackText,
                        // focusNode: _nodePassword,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter feedback";
                          }
                          // else if (value.length <= 10) {
                          //   return "Describe yourself in greater than 10 words";
                          // }
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Please enter feedback',
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      TextFormField(

                        controller: feedbackNumber..text = number,
                        // focusNode: _nodePhone,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                        ),
                        textInputAction: TextInputAction.next,

                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your phone number";
                          }
                          // else if (value.length < 10 || value.length > 10) {
                          //   return "Enter a valid phone number";
                          // }
                          else
                            return null;
                        },onEditingComplete: () {
                          // FocusScope.of(context).requestFocus(_nodeEmail);
                        },
                      ),
                      Container(
                        child: RatingBar
                            .builder(
                          initialRating: 3,
                          // (user.average_rating.toString() == 'null')?0.0:double.parse(user.average_rating),
                          minRating: 0,
                          direction: Axis
                              .horizontal,
                          allowHalfRating:
                          true,
                          itemCount: 5,
                          itemSize: 22,
                          itemPadding: EdgeInsets
                              .symmetric(
                              horizontal:
                              0.0),
                          itemBuilder:
                              (context,
                              _) =>
                              Icon(
                                Icons
                                    .star_rounded,
                                color: ColorConstants
                                    .themeBlue,
                              ),
                          onRatingUpdate:
                              (rating) {
                            rate = rating;
                            print('dsfdshf $rate');
                            // rate = rate;
                          },
                        ),
                      ),
                      Visibility(
                          visible: feedbackLoading,
                          child: LinearProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          ) :
          AlertDialog(
            contentPadding: EdgeInsets.symmetric(
                vertical:
                10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.login_rounded, color: ColorConstants.themeBlue,
                  size: 40.sp,),
                Text('Login first'),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                ColorConstants.themeBlue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: ColorConstants.themeBlue)
                                )
                            )
                        ),
                        child: Text("Cancel", style: TextStyle(fontSize: 20
                            .sp)),
                      ),
                    ),
                    SizedBox(width: 10.w,),
                    Container(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyLogin(title: 'title')),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                          backgroundColor: ColorConstants.themeBlue, //
                          // padding: const EdgeInsets.only(top: 10, bottom: 10),
                        ), child: Text("Login", style: TextStyle(fontSize: 20
                          .sp)),
                      ),
                    ),
                  ],
                ),
              ],
            ),);
        }
    );
  }


}


// class TestSlideUpScreen extends SlideUpScreen {
//   const TestSlideUpScreen(
//       {
//         super.key, required this.link, required this.number, required this.phoneStatus, required this.email, required this.address, required this.lat, required this.lon});
//   final String link;
//   final String number;
//   final String phoneStatus;
//   final String email;
//   final String address;
//   final String lat;
//   final String lon;
//
//   @override
//   TestSlideUpState createState() => TestSlideUpState();
// }
//
// class TestSlideUpState extends SlideUpScreenState<TestSlideUpScreen> {
//   @override
//   Color get backgroundColor => Colors.transparent;
//
//   @override
//   Radius get topRadius => Radius.circular(24);
//
//   @override
//   double get topOffset => 50;
//
//   @override
//   double get offsetToCollapse => 50;
//
//   final String lat = '30.704649';
//   final String lng = '76.717873';
//   final String currentLat = '30.72811';
//   final String currentLng = '76.77065';
//   final String desLat = '30.704649';
//   final String desLng = '76.717873';
//
//
//   @override
//   Widget? bottomBlock(BuildContext context) {
//     return Container(
//       // height: MediaQuery.of(context).padding.bottom +16,
//       color: const Color(0xffC9E9FC),
//     );
//   }
//
//   @override
//   Widget body(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(left: 10.w, right: 10.w),
//           alignment: Alignment.center,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: ColorConstants.themeBlue,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15.0.r),
//               topRight: Radius.circular(15.0.r),
//             ),
//           ),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                   padding:const EdgeInsets.all(6),
//                   child: Image.asset('assets/images/minus.png',
//                     fit: BoxFit.fitWidth, color: Colors.white, height: 4.h,
//                     width: 28.w,)
//               ),
//
//               Text(
//                 'CONTACT NOW',
//                 textScaleFactor: 1.0,
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//
//             ],
//           ),
//         ),
//
//         Container(
//           width: double.infinity,
//           // height: 150.0.h,
//           color: Colors.white,
//           margin: EdgeInsets.only(left: 10.w, right: 10.w),
//           padding:
//           EdgeInsets.only(top: 10.h, bottom: 20.h, left: 10.w, right: 10.w),
//           child: SingleChildScrollView(
//             child:
//             (widget.number.isEmpty) ?
//             Shimmer.fromColors(
//               baseColor: ColorConstants.lightGrey,
//               highlightColor: Colors.white,
//               child: Column(mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 170.0.w,
//                     height: 20.0.h,
//                     decoration: BoxDecoration(color: Colors.grey,
//                         borderRadius: BorderRadius.circular(10.r)),
//                   ),
//                   SizedBox(height: 8.h),
//                   Container(
//                     width: 210.0.w,
//                     height: 20.0.h,
//                     decoration: BoxDecoration(color: Colors.grey,
//                         borderRadius: BorderRadius.circular(10.r)),
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 170.0.w,
//                         height: 20.0.h,
//                         decoration: BoxDecoration(color: Colors.grey,
//                             borderRadius: BorderRadius.circular(10.r)),
//                       ),
//                       Container(
//                         width: 140.0.w,
//                         height: 20.0.h,
//                         decoration: BoxDecoration(color: Colors.grey,
//                             borderRadius: BorderRadius.circular(10.r)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ) :
//             Container(
//                 child: Column(
//                     children: [
//                       (widget.phoneStatus.toString() == 'public') ?
//                       GestureDetector(
//                         onTap: () async {
//                           final call = Uri.parse('tel:+91 ' + widget.number);
//                           if (await canLaunchUrl(call)) {
//                             launchUrl(call);
//                           } else {
//                             throw 'Could not launch $call';
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Icon(
//                              Icons.local_phone_rounded,
//                               size: 20.sp,
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               widget.number,
//                               textScaleFactor: 1.0,
//                               style: TextStyle(fontSize: 15.sp),
//                             )
//                           ],
//                         ),
//                       ) :
//                       Container(),
//                       SizedBox(height: 8.h),
//                       GestureDetector(
//                         onTap: () async {
//                           String email =
//                           Uri.encodeComponent(widget.email);
//                           String subject = Uri.encodeComponent("Hello Findpro");
//                           String body =
//                           Uri.encodeComponent("Hi! I'm ...");
//                           print(subject); //output: Hello%20Flutter
//                           Uri mail =
//                           Uri.parse(
//                               "mailto:$email?subject=$subject&body=$body");
//                           if (await launchUrl(mail)) {
//                             //email app opened
//                           } else {
//                             //email app is not opened
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.email_outlined,
//                               size: 20.sp,
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               widget.email,
//                               textScaleFactor: 1.0,
//                               style: TextStyle(fontSize: 15.sp),
//                             )
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               final String googleMapsUrl = 'comgooglemaps://?center=${widget
//                                   .lat},${widget.lon}';
//                               final String appleMapsUrl = 'https://maps.apple.com/?q=${widget
//                                   .lat},${widget.lon}';
//
//                               if (await canLaunchUrl(
//                                   Uri.parse(googleMapsUrl))) {
//                                 await launchUrl(Uri.parse(googleMapsUrl));
//                               }
//                               if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
//                                 await launch(
//                                     appleMapsUrl, forceSafariVC: false);
//                               } else {
//                                 throw 'Couldn’t launch URL';
//                               }
//                             },
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Icons.location_on_outlined,
//                                   size: 20.sp,
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Container(
//                                   width: 170.w,
//                                   child: Text(
//                                     widget.address,
//                                     maxLines: 2,
//                                     softWrap: false,
//                                     overflow: TextOverflow.ellipsis,
//                                     textScaleFactor: 1.0,
//                                     style: TextStyle(fontSize: 15.sp),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           InkWell(
//                             onTap: openDirection,
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.map_outlined,
//                                   size: 20.sp,
//                                 ),
//                                 SizedBox(width: 5.w,),
//                                 Text('(Get Direction)',
//                                   textScaleFactor: 1.0,
//                                   style: TextStyle(fontSize: 15.sp),
//                                 )],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                 ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   openDirection() async {
//     final String mapsUrl =
//         'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng &destination=$desLat,$desLng&travelmode=driving&dir_action=navigate';
//     final String appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';
//
//     if (await canLaunchUrl(Uri.parse(mapsUrl))) {
//       await launchUrl(Uri.parse(mapsUrl));
//     }
//
//     if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
//       await launch(appleMapsUrl, forceSafariVC: false);
//     } else {
//       throw 'Couldn’t launch URL';
//     }
//   }
// }


class GalleryWidget extends StatefulWidget {
  final List<String> galleryImages;

  GalleryWidget({required this.galleryImages});
  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
               //scrollDirection: Axis.horizontal,
        loadingBuilder: (context, event) => Center(
          child: Container(
         
            width: 80.0,
            height: 20.0,
            child: const CircularProgressIndicator(),
          ),
        ),


               itemCount:widget.galleryImages.length,
                backgroundDecoration:
                BoxDecoration(color: ColorConstants.backgroundColor),
                builder: (context, index) {
                  print('jhjhjh ${widget.galleryImages.length}');
                  final galleryImages = widget.galleryImages[index];

                  return PhotoViewGalleryPageOptions(

              initialScale: PhotoViewComputedScale.contained * 0,
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    imageProvider: NetworkImage(galleryImages),
                    heroAttributes: PhotoViewHeroAttributes(tag:[index]));

                }
                ),

            IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  },

                icon:Icon(Icons.arrow_back)

            ),
          ],
        ),
      ),
    );
  }
}


class ImageDialog extends StatelessWidget {
  ImageDialog(this.image);

  final int image;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/tamas.jpg'),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}
