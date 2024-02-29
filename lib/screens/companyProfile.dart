import 'dart:async';
import 'dart:convert';

import 'package:findpro/global/getSize.dart';
import 'package:findpro/models/jobsModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/jobDetails.dart';
import 'package:findpro/screens/testslide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slideupscreen/blurred_popup.dart';
import 'package:slideupscreen/slide_up_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/Constants.dart';
import 'login.dart';

class companyProfile extends StatefulWidget {
  final String companyId;

  companyProfile(this.companyId);

  @override
  State<companyProfile> createState() => _companyProfile();
}

class _companyProfile extends State<companyProfile>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _timeContainer = false;
  final _controller = ScrollController();
  late AnimationController controller;
  late TabController _tabController;
  dynamic Details;
  Size? tabSize;
  double? finalSize;
  String totalJobs = '';
  int index = 0;
  String id = ''; // try  code
  String name = '';
  String email = '';
  String number = '';
  bool feedbackLoading = false;
  late double rate = 0.0;
  final feedbackFormKey = GlobalKey<FormState>();
  TextEditingController feedbackName = TextEditingController();
  TextEditingController feedbackEmail = TextEditingController();
  TextEditingController feedbackText = TextEditingController();
  TextEditingController feedbackNumber = TextEditingController(); //
  // double tabHeight = double.parse(tabSize?.height.toString());
  int activeTabIndex = 0;
  bool hideNew = true;


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

  Future fetchComProfile() async {
    print('fhgfgf ${widget.companyId}');
    var jsonResponse =
        await http.post(Uri.parse(apiURL + "company_profile_info"),
            body: {
      'company_id': widget.companyId,
    });
    print('okiokimo ${jsonResponse}');
    if (jsonResponse.statusCode == 200){
      final jsonItems = json.decode(jsonResponse.body);
      print('okiokimo ${jsonItems}');
      setState(() {
        Details = jsonItems['data'];
      });
      // List<CompanyProfile> usersList = jsonItems['data']
      //     .map<CompanyProfile>((json) {
      //   return CompanyProfile.fromJson(json);
      // });
      // return result;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<List<Jobs>> fetchOpeningJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('loginId');

    print('sdfsdf ${widget.companyId}');
    var jsonResponse =
        await http.post(Uri.parse(apiURL + "jobs_of_company"), body: {
      'company_id': widget.companyId,
      'lister_id': (userId != null) ? userId : '0',
    });

    print('sdfsdf ${jsonResponse}');
    if (jsonResponse.statusCode == 200) {
      print('sdfsdf ${jsonResponse.body}');
      final jsonItems = json.decode(jsonResponse.body);
      print('gff ${jsonItems}');
      List<Jobs> usersList = jsonItems['data'].map<Jobs>((json) {
        return Jobs.fromJson(json);
      }).toList();
      return usersList;
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    super.initState();

    print('dsgfadf ${finalSize}');
    fetchComProfile();
    fetchOpeningJobs();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
        activeTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: MyAppBar(),
        ),
        endDrawer: MyEndDrawer(),
        backgroundColor: Color(0xffFAF9FF),
        body: (Details != null)
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyAppBar2(),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Container(

                                  margin:EdgeInsets.only(top:10.h),
                                  color: ColorConstants.themeBlue,
                                  width: double.infinity,
                                  height: 70.h,
                                ),
                                Container(
                                  color: ColorConstants.backgroundColor,
                                  width: double.infinity,
                                  height: 30.h,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                print('sdfdsfsfv ${Details['profile_pic']}');
                                print('sdfdsfsfv ${Details['company_id']}');
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: (Details['profile_pic'] == "")
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: 30.h, left: 5.w, right: 5.w),
                                        height: 80.h,
                                        width: 80.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/findpro.png'))),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                            top: 10.h, left: 5.w, right: 5.w),
                                        height: 80.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              Details['profile_pic'],
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          Details['company_name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.sp),
                        ),
                        Text(Details['company_desc'],
                            style: TextStyle(
                              fontSize: 15.sp,
                            )),
                        Text('IT Services & Consulting',
                            style: TextStyle(
                              fontSize: 13.sp,
                            )),
                      ],
                    ),

                    Stack(
                      children: <Widget>[
                        DefaultTabController(
                            length: 2,
                            child:Row(
                           //   crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                               // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TabBar(
                                     isScrollable: true,
                                     indicatorSize: TabBarIndicatorSize.label,
                                     controller: _tabController,
                                     labelColor: Colors.black,
                                     unselectedLabelColor: Colors.grey,
                                     indicatorColor: Colors.blue,indicatorWeight:2.9,
                                     tabs: [

                                         Tab(
                                           child: Row(
                                               mainAxisAlignment:
                                                   MainAxisAlignment.center,

                                               children: [
                                                 Text(
                                                   "Profile",
                                                   style: TextStyle(
                                                       fontSize: 12.sp),
                                                   textScaleFactor: 1.0,
                                                 ),
                                               ]),
                                         ),

                                       Tab(
                                         child: Text(
                                           "Jobs opening (${totalJobs})",
                                           style:
                                               TextStyle(fontSize: 12.sp),

                                           textScaleFactor: 1.0,
                                         ),
                                       ),
                                     ],
                                   ),

                                ])),
                             const Padding(
                             padding: EdgeInsets.only(top:14),
                             child: Divider(
                             indent: 120,
                             endIndent: 118,
                             color: Colors.grey,
                             height:65,thickness:1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 723.h,
                      child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: WidgetSize(
                                onChange: (Size size) {
                                  setState((){
                                    tabSize = size;
                                    // finalSize = tabSize?.height.roundToDouble();
                                  });
                                },
                                child: Column(
                                  children: [
                                     // Text(
                                     //     'Redbox size: ${tabSize?.height.roundToDouble()}'),
                                    const SizedBox(height: 20,),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 10.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10.r)),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children:[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
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
                                                style: TextStyle(
                                                    fontSize: 20.sp),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 5.w),
                                            child: ReadMoreText(
                                              Details['about'],
                                              trimLines: 5,
                                              textAlign:
                                              TextAlign.justify,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                              colorClickableText:
                                              ColorConstants
                                                  .themeBlue,
                                              trimMode: TrimMode.Length,
                                              trimCollapsedText:
                                              ' Show more',
                                              trimExpandedText:
                                              ' Show less',
                                              lessStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: ColorConstants
                                                      .themeBlue),
                                              moreStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: ColorConstants
                                                    .themeBlue,
                                                decoration:
                                                TextDecoration
                                                    .underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
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
                                            margin: EdgeInsets.only(
                                                left: 5.w),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .wallet_giftcard_rounded,
                                                  size: 23.sp,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  "Awards/Achievements",
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
                                          Container(
                                            margin:
                                            EdgeInsets.symmetric(
                                                vertical: 10.w),
                                            child: NotificationListener<
                                                OverscrollIndicatorNotification>(
                                              onNotification:
                                                  (OverscrollIndicatorNotification
                                              overscroll) {
                                                overscroll
                                                    .disallowIndicator();
                                                return true;
                                              },
                                              child: Container(
                                                height: 150.h,
                                                margin:
                                                EdgeInsetsDirectional
                                                    .symmetric(
                                                    horizontal:
                                                    10.h),
                                                child: ListView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    children: <Widget>[
                                                      for (int a = 0;
                                                      a <
                                                          Details['award_image']
                                                              .length;
                                                      a++)
                                                        GestureDetector(
                                                          onTap:
                                                              () async {
                                                            await showDialog<
                                                                void>(
                                                                context:
                                                                context,
                                                                barrierDismissible:
                                                                false,
                                                                // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                context) {
                                                                  return AlertDialog(
                                                                    contentPadding:
                                                                    EdgeInsets.all(5),
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                    ),
                                                                    content:
                                                                    SingleChildScrollView(
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            child: Column(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Align(alignment: Alignment.topRight, child: Transform.rotate(angle: 45 * math.pi / 180, child: Icon(Icons.add_circle_rounded))),
                                                                                ),
                                                                                Image.network(Details['award_image'][a]['img'], fit: BoxFit.fitWidth),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          child:
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                left:
                                                                5.w,
                                                                right: 5
                                                                    .w),
                                                            padding: EdgeInsets.only(
                                                                top:
                                                                5.h,
                                                                bottom:
                                                                5.h,
                                                                left:
                                                                5.w,
                                                                right: 5
                                                                    .w),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.1
                                                                        .w),
                                                                borderRadius:
                                                                BorderRadius.all(Radius.circular(10.r))),
                                                            child:
                                                            Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: <Widget>[
                                                                ClipRRect(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10.r),
                                                                  child:
                                                                  FadeInImage(
                                                                    height:
                                                                    100.h,
                                                                    width:
                                                                    100.w,
                                                                    fadeOutCurve:
                                                                    Curves.linear,
                                                                    placeholderFit:
                                                                    BoxFit.fitWidth,
                                                                    placeholder:
                                                                    const AssetImage(
                                                                      'assets/images/logo.png',
                                                                    ),
                                                                    image:
                                                                    NetworkImage(Details['award_image'][a]['img']),
                                                                    imageErrorBuilder: (context,
                                                                        error,
                                                                        stackTrace) {
                                                                      return Image.asset('assets/images/logo.png', height: 100.h, width: 100.w, fit: BoxFit.fitWidth);
                                                                    },
                                                                    fit:
                                                                    BoxFit.cover,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  Details['award_image'][a]
                                                                  [
                                                                  'name'],
                                                                  textScaleFactor:
                                                                  1.0,
                                                                  textAlign:
                                                                  TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 13.sp,
                                                                      color: Colors.black),
                                                                ),
                                                                Text(
                                                                  Details['award_image'][a]
                                                                  [
                                                                  'when'],
                                                                  overflow:
                                                                  TextOverflow.fade,
                                                                  textScaleFactor:
                                                                  1.0,
                                                                  textAlign:
                                                                  TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 13.sp,
                                                                      color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ]),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      decoration: BoxDecoration(
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
                                                left: 5.w),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .collections_rounded,
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
                                          Container(
                                            margin:
                                            EdgeInsets.symmetric(
                                                vertical: 10.w),
                                            child: NotificationListener<
                                                OverscrollIndicatorNotification>(
                                              onNotification:
                                                  (OverscrollIndicatorNotification
                                              overscroll) {
                                                overscroll
                                                    .disallowIndicator();
                                                return true;
                                              },
                                              child: Container(
                                                height: 100.h,
                                                margin:
                                                EdgeInsetsDirectional
                                                    .symmetric(
                                                    horizontal:
                                                    10.h),
                                                child: ListView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    children: <Widget>[
                                                      for (int g = 0;
                                                      g <
                                                          Details['gallery_image']
                                                              .length;
                                                      g++)
                                                        InkWell(
                                                          onTap: () {},
                                                          child:
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                right: 10
                                                                    .w),
                                                            child:
                                                            ClipRRect(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10.r),
                                                              child:
                                                              FadeInImage(
                                                                height:
                                                                100.h,
                                                                width:
                                                                100.w,
                                                                fadeOutCurve:
                                                                Curves.linear,
                                                                placeholderFit:
                                                                BoxFit.fitWidth,
                                                                placeholder:
                                                                const AssetImage(
                                                                  'assets/images/logo.png',
                                                                ),
                                                                image: NetworkImage(Details['gallery_image']
                                                                [
                                                                g]),
                                                                imageErrorBuilder: (context,
                                                                    error,
                                                                    stackTrace) {
                                                                  return Image.asset(
                                                                      'assets/images/noimage.jpeg',
                                                                      height: 100.h,
                                                                      width: 100.w,
                                                                      fit: BoxFit.fitWidth);
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5.0),
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
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .star_rounded,
                                                      size: 23.sp,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      "Review",
                                                      textScaleFactor:
                                                      1.0,
                                                      style: TextStyle(
                                                          fontSize:
                                                          20.sp),
                                                    )
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    //   SharedPreferences profilePrefs = await SharedPreferences.getInstance();
                                                    // profilePrefs.setString('listerId', user.id);
                                                    feedbackDialog(
                                                        context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.only(
                                                        left: 4.w,
                                                        right: 4.w,
                                                        top: 4.h,
                                                        bottom:
                                                        3.h),
                                                    decoration:
                                                    BoxDecoration(
                                                      color:
                                                      Colors.white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          4.r),
                                                      border: Border.all(
                                                          color: ColorConstants
                                                              .themeBlue,
                                                          width: 1),
                                                    ),
                                                    child: Text(
                                                      'Leave Feedback',
                                                      textScaleFactor:
                                                      1.0,
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
                                          Container(
                                            // margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              child: ImageSlideshow(
                                                width: double.infinity,
                                                height: 100,
                                                initialPage: 0,
                                                indicatorColor:
                                                ColorConstants
                                                    .themeBlue,
                                                indicatorBackgroundColor:
                                                Color(0xffC9E9FC),
                                                onPageChanged: (value) {
                                                  print(
                                                      'Page changed: $value');
                                                },
                                                // autoPlayInterval: 5000,
                                                // isLoop: true,
                                                children: [
                                                  // for (int i=1; i<user.feedback.length; i+=2)
                                                  Container(
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10.w),
                                                      child:
                                                      IntrinsicHeight(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                child:
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                      height: 40.h,
                                                                      width: 40.w,
                                                                      decoration: BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.cover, image: NetworkImage('https:\/\/www.findpro.net\/uploads\/avatars\/2016\/epageImg23459_fd02122b-9152-40a8-a31d-b25f2623c323.jpg'))),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'xhgfh',
                                                                          textScaleFactor: 1.0,
                                                                          style: TextStyle(fontSize: 16.sp),
                                                                        ),
                                                                        Container(
                                                                          child: RatingBar.builder(
                                                                            ignoreGestures: true,
                                                                            initialRating: 3,
                                                                            minRating: 0,
                                                                            direction: Axis.horizontal,
                                                                            allowHalfRating: true,
                                                                            itemCount: 5,
                                                                            itemSize: 12,
                                                                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                                            itemBuilder: (context, _) => Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate: (rating) {
                                                                              print(rating);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 100.w,
                                                                          child: Text('ghjjghj', maxLines: 2, overflow: TextOverflow.ellipsis, textScaleFactor: 1.0, style: TextStyle(fontSize: 13.sp)),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            VerticalDivider(
                                                              color: Colors
                                                                  .grey,
                                                              //color of divider
                                                              width: 20,
                                                              //width space of divider
                                                              thickness:
                                                              0.5,
                                                              //thickness of divier line
                                                              indent: 5,
                                                              //Spacing at the top of divider.
                                                              endIndent:
                                                              25, //Spacing at the bottom of divider.
                                                            ),

                                                            // (user.feedback.length!= a+1)?a:a+1

                                                            Expanded(
                                                              child:
                                                              Container(
                                                                child:
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                      height: 40.h,
                                                                      width: 40.w,
                                                                      decoration: BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.cover, image: NetworkImage('https:\/\/www.findpro.net\/uploads\/avatars\/2016\/epageImg23459_fd02122b-9152-40a8-a31d-b25f2623c323.jpg'))),
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'sdvf',
                                                                          maxLines: 2,
                                                                          textScaleFactor: 1.0,
                                                                          style: TextStyle(fontSize: 16.sp),
                                                                        ),
                                                                        Container(
                                                                          child: RatingBar.builder(
                                                                            ignoreGestures: true,
                                                                            initialRating: 3,
                                                                            minRating: 0,
                                                                            direction: Axis.horizontal,
                                                                            allowHalfRating: true,
                                                                            itemCount: 5,
                                                                            itemSize: 12,
                                                                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                                            itemBuilder: (context, _) => Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate: (rating) {
                                                                              print(rating);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 100.w,
                                                                          child: Text('cghc', maxLines: 2, overflow: TextOverflow.ellipsis, textScaleFactor: 1.0, style: TextStyle(fontSize: 13.sp)),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                child: SingleChildScrollView(
controller: _controller,                           physics:
                                  const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<Jobs>>(
                                        future: fetchOpeningJobs(),
                                        builder: (context, snapshot) {
                                          totalJobs = snapshot.data!.length.toString();
                                          if (snapshot.connectionState
                                              .toString() ==
                                              'ConnectionState.waiting') {
                                            return Shimmer.fromColors(
                                              baseColor: ColorConstants
                                                  .lightGrey,
                                              highlightColor:
                                              Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10)),
                                                margin: EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    10.w,
                                                    vertical: 5.h),
                                                padding:
                                                EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          '',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              20.sp),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'New',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  12,
                                                                  color:
                                                                  ColorConstants.themeBlue),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              3.w,
                                                            ),
                                                            Icon(Icons
                                                                .more_horiz_rounded)
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
                                                              Icons
                                                                  .shopping_bag_outlined,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              2.w,
                                                            ),
                                                            Text(
                                                              '',
                                                              style:
                                                              TextStyle(
                                                                fontSize:
                                                                13.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' - ',
                                                              style:
                                                              TextStyle(
                                                                fontSize:
                                                                13.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              '',
                                                              style:
                                                              TextStyle(
                                                                fontSize:
                                                                13.sp,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .currency_rupee_rounded,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              3.w,
                                                            ),
                                                            Text('',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
                                                                )),
                                                            Text(' - ',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
                                                                )),
                                                            Text('',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 15.w,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              3.w,
                                                            ),
                                                            Text('',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
                                                                )),
                                                            Text(',',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
                                                                )),
                                                            Text('',
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13.sp,
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
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style:
                                                        TextStyle(
                                                          fontSize:
                                                          15.sp,
                                                        )),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                              left: 3
                                                                  .w,
                                                              right:
                                                              3.w),
                                                          padding: EdgeInsets.only(
                                                              left: 5.w,
                                                              right:
                                                              5.w,
                                                              top: 2.h,
                                                              bottom:
                                                              2.h),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width:
                                                                  1)),
                                                          child: Text(
                                                            '',
                                                            textScaleFactor:
                                                            1.0,
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              10.sp,
                                                              color: Colors
                                                                  .black,
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
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    left:
                                                                    5.w,
                                                                    right: 5.w),
                                                                height:
                                                                30.h,
                                                                width:
                                                                30.w,
                                                                decoration: const BoxDecoration(
                                                                    shape:
                                                                    BoxShape.circle,
                                                                    image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(''))),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                    130.w,
                                                                    child:
                                                                    Text(
                                                                      '',
                                                                      overflow: TextOverflow.ellipsis,
                                                                      softWrap: false,
                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                                    ),
                                                                  ),
                                                                  RatingBar
                                                                      .builder(
                                                                    ignoreGestures:
                                                                    true,
                                                                    initialRating:
                                                                    3,
                                                                    minRating:
                                                                    0,
                                                                    direction:
                                                                    Axis.horizontal,
                                                                    allowHalfRating:
                                                                    true,
                                                                    itemCount:
                                                                    5,
                                                                    itemSize:
                                                                    12,
                                                                    itemPadding:
                                                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                                                    itemBuilder: (context, _) =>
                                                                    const Icon(
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
                                                                  fontSize:
                                                                  13.sp),
                                                            ),
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  13.sp),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  size:
                                                                  15,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                  3.w,
                                                                ),
                                                                Text('',
                                                                    style:
                                                                    TextStyle(fontSize: 13.sp)),
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

                                          if ((snapshot.data != null)) {
                                            return Column(
                                              children: [
                                                for (int i = 0;
                                                i <
                                                    snapshot.data!
                                                        .length;
                                                i++)
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
                                                                    snapshot.data![i].company_profile_pic,
                                                                    snapshot.data![i].company_name,
                                                                    snapshot.data![i].min_experience,
                                                                    snapshot.data![i].max_experience,
                                                                    snapshot.data![i].minimum,
                                                                    snapshot.data![i].maximum,
                                                                    snapshot.data![i].city,
                                                                    snapshot.data![i].state,
                                                                    snapshot.data![i].created_hours,
                                                                    snapshot.data![i].content,
                                                                    snapshot.data![i].hiring_timeline,
                                                                    snapshot.data![i].deadline,
                                                                    snapshot.data![i].job_type,
                                                                    snapshot.data![i].job_schedule,
                                                                    snapshot.data![i].quick_hiring_time,
                                                                    snapshot.data![i].suplement_pay,
                                                                    snapshot.data![i].qualification,
                                                                    snapshot.data![i].skill_id,
                                                                    snapshot.data![i].applied,
                                                                    snapshot.data![i].company_id,
                                                                  )),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .white,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            0.w,
                                                            vertical:
                                                            5.h),
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                            10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data![i]
                                                                      .title,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 20.sp),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Visibility(
                                                                        visible: hideNew,
                                                                        child: (snapshot.data![i]
                                                                            .created_hours
                                                                            .toString()
                                                                            .contains(
                                                                            'days') ||
                                                                            snapshot.data![i]
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
                                                                    // const Text(
                                                                    //   'New',
                                                                    //   style: TextStyle(fontSize: 12, color: ColorConstants.themeBlue),
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 3.w,
                                                                    ),
                                                                    // Icon(Icons.more_horiz_rounded)
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              10.h,
                                                            ),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                              Axis.horizontal,
                                                              child:
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons.shopping_bag_outlined,
                                                                        size: 15,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 2.w,
                                                                      ),
                                                                      Text(
                                                                        snapshot.data![i].min_experience,
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
                                                                        snapshot.data![i].max_experience,
                                                                        style: TextStyle(
                                                                          fontSize: 13.sp,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    15.w,
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
                                                                      Text(snapshot.data![i].minimum,
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                      Text(' - ',
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                      Text(snapshot.data![i].maximum,
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    15.w,
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
                                                                      Text(snapshot.data![i].city,
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                      Text(',',
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                      Text(snapshot.data![i].state,
                                                                          style: TextStyle(
                                                                            fontSize: 13.sp,
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              10.h,
                                                            ),
                                                            Text(
                                                                snapshot.data![i].content,
                                                                maxLines:
                                                                3,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  15.sp,
                                                                )),
                                                            SizedBox(
                                                              height:
                                                              10.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                for (int s =
                                                                0;
                                                                s < snapshot.data![i].skill_id.length;
                                                                s++)
                                                                  Container(
                                                                    margin:
                                                                    EdgeInsets.only(left: 3.w, right: 3.w),
                                                                    padding: EdgeInsets.only(
                                                                        left: 5.w,
                                                                        right: 5.w,
                                                                        top: 2.h,
                                                                        bottom: 2.h),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.transparent,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        border: Border.all(color: Colors.grey, width: 1)),
                                                                    child:
                                                                    Text(
                                                                      snapshot.data![i].skill_id[s],
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
                                                              height:
                                                              10.h,
                                                            ),
                                                            const Divider(
                                                              color: ColorConstants
                                                                  .dividerGrey,
                                                              height: 0,
                                                              thickness:
                                                              1,
                                                              // indent: 10.0,
                                                              // endIndent: 10.0,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              10.h,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => companyProfile(snapshot.data![i].company_id)),
                                                                    );
                                                                  },
                                                                  child:
                                                                  Row(
                                                                    children: [
                                                                      (snapshot.data![i].company_profile_pic != null)
                                                                          ? Container(
                                                                        margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                        height: 30.h,
                                                                        width: 30.w,
                                                                        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(snapshot.data![i].company_profile_pic))),
                                                                      )
                                                                          : Container(
                                                                        margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                        height: 30.h,
                                                                        width: 30.w,
                                                                        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/findpro.png'))),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            snapshot.data![i].company_name,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            softWrap: false,
                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                                          ),
                                                                          RatingBar.builder(
                                                                            ignoreGestures: true,
                                                                            initialRating: 3,
                                                                            minRating: 0,
                                                                            direction: Axis.horizontal,
                                                                            allowHalfRating: true,
                                                                            itemCount: 5,
                                                                            itemSize: 12,
                                                                            itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                                            itemBuilder: (context, _) => const Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate: (rating) {
                                                                              print(rating);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(
                                                                      'openings: ',
                                                                      style: TextStyle(fontSize: 13.sp),
                                                                    ),
                                                                    Text(
                                                                      snapshot.data![i].position_available,
                                                                      style: TextStyle(fontSize: 13.sp),
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
                                                                        Text(snapshot.data![i].created_hours, style: TextStyle(fontSize: 13.sp)),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
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
                                                  child: Text(
                                                      'No jobs available')),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ]),
                    ),



                    Container(
                      // padding: EdgeInsets.all(5.0),
                      margin: const EdgeInsets.all(10.0),
                      height: 30.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              bottom: 3.h,
                              left: 10.w,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                          (_timeContainer == false)
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      Timer(const Duration(seconds: 1), () {
                                        setState(() {
                                          if (_controller.hasClients) {
                                            final position = _controller
                                                .position.maxScrollExtent;
                                            _controller.animateTo(
                                              position,
                                              duration: const Duration(
                                                  milliseconds: 400),
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
                                        Text(
                                          'Check Opening Hour',
                                          textScaleFactor: 1.0,
                                          style: TextStyle(fontSize: 13.sp),
                                        ),
                                        SizedBox(width: 10.w),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                      ],
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      controller.forward();
                                      _timeContainer = false;
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
                                          style: TextStyle(fontSize: 13.sp),
                                        ),
                                        SizedBox(width: 10.w),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: const Icon(
                                            Icons.keyboard_arrow_up_rounded,
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
                      margin: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.linear,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'Working hours',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Column(children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Monday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(
                                    child: Text(''),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Tuesday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Wednesday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Thursday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Friday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Saturday',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontSize: 13.sp)),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Sunday',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Text(' - '),
                                  ),
                                  const Expanded(flex: 6, child: Text(''))
                                ],
                              ),
                            ])
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0.r),
                          topRight: Radius.circular(15.0.r),
                          ),
                      ),
                      child:GestureDetector(
                        onTap: () {
                                  Navigator.of(context).push(
                                      BlurredPopup.withSlideUp(
                                          screen: TestSlideUpScreen(
                                            link: Details['profile_pic'],
                                            number: 'user.mobile',
                                            email: 'user.email',
                                            address: Details['city']+','+Details['state'],
                                            lat: 'user.latitude',
                                            lon: 'user.longitude',
                                            phoneStatus: 'user.phonestatus',
                                          )
                                  )
                                  );

                                 },
                              child: Container(
                                // padding: EdgeInsets.only(bottom: 10.h),
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorConstants.themeBlue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0.r),
                                    topRight: Radius.circular(15.0.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                        'assets/images/minus.png',
                                        fit: BoxFit.fitWidth,
                                        color: Colors.white,
                                        height: 4.h,
                                        width: 28.w,
                                      ),
                                    ),
                                    Text(
                                      'CONTACT NOW',
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  Future<void> feedbackDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('sujegfdhfjdh $email');
      number = prefs.getString('phone') ?? '';
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
    });
    print('dsfdsf');
    if(!mounted) return;
    return showDialog<void>(

        context: context,
        barrierDismissible: false,
        // user must tap button!
        builder: (BuildContext context) {

          return (name.isNotEmpty)
              ? AlertDialog(
              title: const Text('Leave Feedback',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ColorConstants.themeBlue)),
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
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorConstants.themeBlue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: ColorConstants.themeBlue)))),
                            child: Text("Cancel",
                                style: TextStyle(fontSize: 15.sp)),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (feedbackFormKey.currentState!.validate()) {
                              setState(() {
                                feedbackLoading = true;
                              });
                              feedback(
                                  feedbackName.text.toString(),
                                  feedbackText.text.toString(),
                                  feedbackNumber.text.toString(),
                                  feedbackEmail.text.toString());
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: ColorConstants.themeBlue, //
                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                          ),
                          child: Text("SUBMIT",
                              style: TextStyle(fontSize: 15.sp)),
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              decoration: InputDecoration(
                                labelText: 'Fullname',
                              ),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(_nodePassword);
                              },
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: feedbackEmail..text = email,
                              // focusNode: _nodeEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter a valid email address";
                                } else if (!RegExp(r'\S+@\S+\.\S+')
                                    .hasMatch(value)) {
                                  return "Enter a valid email address";
                                } else
                                  return null;
                              },
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(_nodeFullname);
                              },
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              },
                              onEditingComplete: () {
                                // FocusScope.of(context).requestFocus(_nodeEmail);
                              },
                            ),
                            Container(
                              child: RatingBar.builder(
                                initialRating: 3,
                                // (user.average_rating.toString() == 'null')?0.0:double.parse(user.average_rating),
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 22,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_rounded,
                                  color: ColorConstants.themeBlue,
                                ),
                                onRatingUpdate: (rating) {
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
                )
              : AlertDialog(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        color: ColorConstants.themeBlue,
                        size: 40.sp,
                      ),
                      Text('Login first'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorConstants.themeBlue),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color:
                                                  ColorConstants.themeBlue)))),
                              child: Text("Cancel",
                                  style: TextStyle(fontSize: 20.sp)),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyLogin(title: 'title')),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: ColorConstants.themeBlue, //
                                // padding: const EdgeInsets.only(top: 10, bottom: 10),
                              ),
                              child: Text("Login",
                                  style: TextStyle(fontSize: 20.sp)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        });
  }

  void feedback(String name, feedback, phone, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('listerId');
    String? senderId = prefs.getString('id');

    try {
      Response response = await post(Uri.parse(apiURL + 'star_rating'), body: {
        'lister_id': id,
        'sender_id': senderId,
        'name': feedbackName.text.toString(),
        'email': feedbackEmail.text.toString(),
        'phone': feedbackNumber.text.toString(),
        'feedback': feedbackText.text.toString(),
        'rating': rate.toString()
      });
      print('sdf ${response.body}');

      if (response.statusCode == 200) {
        feedbackLoading = false;
        Navigator.of(context).pop();
        var data = jsonDecode(response.body.toString());

        feedbackName.clear();
        feedbackText.clear();
        feedbackNumber.clear();
        feedbackEmail.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Feedback submitted",
              style: TextStyle(color: Colors.white),
            )));
      } else {
        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        });

        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

}

