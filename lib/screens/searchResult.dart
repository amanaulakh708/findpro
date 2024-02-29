import 'dart:async';
import 'dart:convert';

import 'package:findpro/apis/searchResultApi.dart';
import 'package:findpro/models/jobsModel.dart';
import 'package:findpro/models/profileModel.dart';
import 'package:findpro/models/searchModel.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/companyProfile.dart';
import 'package:findpro/screens/jobDetails.dart';
import 'package:findpro/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../global/Constants.dart';
import 'dashboard.dart';

class searchResult extends StatefulWidget {
  final String keyword;
  const searchResult({super.key, required this.keyword});

  @override
  State<searchResult> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<searchResult> {
  ScrollController jobscontroller = ScrollController();
  ScrollController profilecontroller = ScrollController();
  String id = '';

  bool showSearchResults = false;
  bool showProfileResults = false;
  bool showJobsResults = false;

  int page = 0;
  int limit = 10;
  int offset = 0;
  bool isFirstLoadRunning = false;
  bool loadMore = false;
  bool hasNextPage = true;
  List job = [];
  List profile = [];
  bool timer = false;
  bool sscontroller = true;
  //String type = 'profile';

  void firstloadJob() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('loginId');
      String? keyword = prefs.getString('keyword');
      // String? type = prefs.getString('type');

      var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
        'lister_id': (userId != null) ? userId : null,
        'keyword': keyword,
        "type": 'job',
        "limit": limit.toString(),
        "offset": offset.toString(),
      });

      print('dfkjbdjh ${keyword}');
      // print('dfkjbdjh ${type}');
      print('dfkjbdjh ${job}');
      if (jsonResponse.statusCode == 200) {
        final jsonItems = json.decode(jsonResponse.body);
        //  print('sdflkyukuklksdf ${jsonItems}');
        job = jsonItems['data'];
        print('dfkjbdjh ${job.length}');
      } else {
        throw Exception('Failed to load data from internet');
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadmoreJob() async {
    print('jnkjkj ');
    if (hasNextPage == true &&
            isFirstLoadRunning == false &&
            loadMore == false &&
            jobscontroller.position.maxScrollExtent ==
                jobscontroller.position.pixels
        // scrollController.position.extentAfter < 300
        ) {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });

      offset += 10;
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('loginId');
        String? keyword = prefs.getString('keyword');
        // String? type = prefs.getString('type');

        print('sdfsdf $userId');

        var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
          'lister_id': (userId != null) ? userId : null,
          'keyword': keyword,
          "type": 'job',
          "limit": limit.toString(),
          "offset": offset.toString()
        });

        if (jsonResponse.statusCode == 200) {
          Timer(const Duration(seconds: 5), () {
            setState(() {
              timer = true;
            });
          });
          final jsonItems = json.decode(jsonResponse.body);

          if (jsonItems.isNotEmpty) {
            job.addAll(jsonItems['data']);
          }
          if (jsonItems.isEmpty) {
            setState(() {
              print('hbjhbj${hasNextPage}');
              hasNextPage = true;
            });
          }
        } else {
          throw Exception('Failed to load data from internet');
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        loadMore = false;
      });
    }
  }

  void firstloadProfile() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('loginId');
      String? keyword = prefs.getString('keyword');
      // String? type = prefs.getString('type');

      var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
        'lister_id': (userId != null) ? userId : null,
        'keyword': keyword,
        "type": 'profile',
        "limit": limit.toString(),
        "offset": offset.toString(),
      });

      print('dfkjbdjh ${keyword}');
      // print('dfkjbdjh ${type}');
      print('dfkjbdjh ${profile}');
      if (jsonResponse.statusCode == 200) {
        final jsonItems = json.decode(jsonResponse.body);
        //  print('sdflkyukuklksdf ${jsonItems}');
        profile = jsonItems['data'];
        print('dfkjbdjh ${profile.length}');
      } else {
        throw Exception('Failed to load data from internet');
      }
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadmoreProfile() async {
    print('jnkjkj ');
    if (hasNextPage == true &&
            isFirstLoadRunning == false &&
            loadMore == false &&
            profilecontroller.position.maxScrollExtent ==
                profilecontroller.position.pixels
        // scrollController.position.extentAfter < 300
        ) {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });

      offset += 10;
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('loginId');
        String? keyword = prefs.getString('keyword');
        // String? type = prefs.getString('type');

        print('sdfsdf $userId');

        var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
          'lister_id': (userId != null) ? userId : null,
          'keyword': keyword,
          "type": 'profile',
          "limit": limit.toString(),
          "offset": offset.toString()
        });

        if (jsonResponse.statusCode == 200) {
          Timer(const Duration(seconds: 5), () {
            setState(() {
              timer = true;
            });
          });
          final jsonItems = json.decode(jsonResponse.body);

          if (jsonItems.isNotEmpty) {
            profile.addAll(jsonItems['data']);
          }
          if (jsonItems.isEmpty) {
            setState(() {
              print('hbjhbj${hasNextPage}');
              hasNextPage = true;
            });
          }
        } else {
          throw Exception('Failed to load data from internet');
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        loadMore = false;
      });
    }
  }

  @override
  void initState() {
    firstloadJob();
    firstloadProfile();
    getLoginId();
    jobscontroller = ScrollController()..addListener((loadmoreJob));
    profilecontroller = ScrollController()..addListener(loadmoreProfile);
    super.initState();
  }

  getLoginId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('dfgxdgf $id');
      id = prefs.getString('loginId') ?? '';
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
      backgroundColor: const Color(0xffFAF9FF),
      body: SingleChildScrollView(
        controller: (sscontroller == true) ? jobscontroller : profilecontroller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyAppBar2(),
            Padding(
                  padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: 20.h, bottom: 10.h),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Flexible(
                    child:Text(
                      "Result for " + widget.keyword,
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                    children:[
                      InkWell(
                        onTap: (){
                          setState((){
                            sscontroller = true;
                            // type = 'job';
                            firstloadJob();
                            showSearchResults = false;
                           }
                           );
                           },
                        child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: (showSearchResults == true)
                                    ? Colors.white
                                    : ColorConstants.themeBlue,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                  "Jobs",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: (showSearchResults == true)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      InkWell(
                        onTap: (){
                          setState((){
                            sscontroller = false;
                            firstloadProfile();
                            showSearchResults = true;
                          });
                        },
                        child:Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                color: (showSearchResults == false)
                                    ? Colors.white
                                    : ColorConstants.themeBlue,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Text(
                              "Profiles", textScaleFactor: 1.0,
                              style:TextStyle(
                                    fontSize: 12.sp,
                                    color: (showSearchResults == false)
                                    ? Colors.black
                                    : Colors.white,
                                    ),
                                    ),
                                    ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.filter_list_rounded,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  "Filter",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (showSearchResults == true)
                ? Container(
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: (isFirstLoadRunning)
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                     const CircularProgressIndicator(
                                      color: ColorConstants.themeBlue,),
                                      SizedBox(height: 200.h,),
                                ],
                              ),
                            ),
                          ):(profile.isNotEmpty)
                            ? Column(
                                children:[
                                  GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: profile.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: (1.w / 1.4.h),
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Visibility(
                                        visible: true,
                                        child: GestureDetector(
                                          onTap: () async {
                                            print(
                                                'sdfkkksdf ${profile[index]}');
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                'link', profile[index]['link']);
                                            prefs.setString('category',
                                                profile[index]['category']);

                                            if (!mounted) return;
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyProfile()));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    child: FadeInImage(
                                                      height: 150.h,
                                                      fadeOutCurve:
                                                          Curves.linear,
                                                      placeholderFit:
                                                          BoxFit.fitWidth,
                                                      placeholder:
                                                          const AssetImage(
                                                        'assets/images/logo.png',
                                                      ),
                                                      image: NetworkImage(
                                                          profile[index]
                                                              ['profileImage']),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                            'assets/images/logo.png',
                                                            height: 150.h,
                                                            fit: BoxFit
                                                                .fitWidth);
                                                      },
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w, top: 5.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Text(
                                                        profile[index]['name'],
                                                        textScaleFactor: 1.0,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      RatingBar.builder(
                                                        initialRating: (profile[
                                                                            index]
                                                                        [
                                                                        'average_rating']
                                                                    .toString() ==
                                                                "")
                                                            ? 0.0
                                                            : double.parse(profile[
                                                                    index][
                                                                'average_rating']),
                                                        minRating: 0,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 12,
                                                        itemPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    0.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                        },
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
                                                                bottom: 1.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1),
                                                        ),
                                                        child: Text(
                                                          profile[index]
                                                              ['category'],
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(children: <Widget>[
                                                        const Icon(
                                                            Icons
                                                                .location_on_rounded,
                                                            size: 15),
                                                        Text(
                                                          profile[index]
                                                              ['city'],
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 10.sp),
                                                        )
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                      //:Container();
                                    },
                                  ),
                                  if (loadMore == true)
                                    const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/no-results.png',
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                    Text(
                                      'No Search Found',
                                      style: TextStyle(
                                          color: const Color(0xFF0681af),
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(
                                      height: 200.h,
                                    )
                                  ],
                                )),
                              ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: (isFirstLoadRunning)
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: ColorConstants.themeBlue,
                                ),
                                SizedBox(
                                  height: 200.h,
                                ),
                              ],
                            )),
                          )
                        : (job.isNotEmpty)
                            ? Column(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (int i = 0; i < job.length; i++)
                                          Container(
                                            child:
                                                (job[i]['type'] !=
                                                        'multipleprofile')
                                                    ? InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    //  _posts[index]['id'],
                                                                    jobDetails(
                                                                      job[i][
                                                                          'id'],
                                                                      job[i][
                                                                          'title'],
                                                                      job[i][
                                                                          'company_profile_pic'],
                                                                      job[i][
                                                                          'company_name'],
                                                                      job[i][
                                                                          'min_experience'],
                                                                      job[i][
                                                                          'max_experience'],
                                                                      job[i][
                                                                          'minimum'],
                                                                      job[i][
                                                                          'maximum'],
                                                                      job[i][
                                                                          'city'],
                                                                      job[i][
                                                                          'state'],
                                                                      job[i][
                                                                          'created_hours'],
                                                                      job[i][
                                                                          'content'],
                                                                      job[i][
                                                                          'hiring_timeline'],
                                                                      job[i][
                                                                          'deadline'],
                                                                      job[i][
                                                                          'job_type'],
                                                                      job[i][
                                                                          'job_schedule'],
                                                                      job[i][
                                                                          'quick_hiring_time'],
                                                                      job[i][
                                                                          'suplement_pay'],
                                                                      job[i][
                                                                          'qualification'],
                                                                      job[i][
                                                                          'skill_id'],
                                                                      job[i][
                                                                          'applied'],
                                                                      job[i][
                                                                          'company_id'],
                                                                    )),
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.w,
                                                                  vertical:
                                                                      5.h),
                                                          padding:
                                                              EdgeInsets.all(
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
                                                                    job[i][
                                                                        'title'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20.sp),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
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
                                                                      const Icon(
                                                                          Icons
                                                                              .more_horiz_rounded)
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
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.w,
                                                                        ),
                                                                        Text(
                                                                          job[i]
                                                                              [
                                                                              'min_experience'],
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
                                                                          job[i]
                                                                              [
                                                                              'max_experience'],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13.sp,
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
                                                                          Icons
                                                                              .currency_rupee_rounded,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3.w,
                                                                        ),
                                                                        Text(
                                                                            job[i][
                                                                                'minimum'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13.sp,
                                                                            )),
                                                                        Text(
                                                                            ' - ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13.sp,
                                                                            )),
                                                                        Text(
                                                                            job[i][
                                                                                'maximum'],
                                                                            style:
                                                                                TextStyle(
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
                                                                          Icons
                                                                              .location_on,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3.w,
                                                                        ),
                                                                        Text(
                                                                            job[i][
                                                                                'city'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13.sp,
                                                                            )),
                                                                        Text(
                                                                          ',',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13.sp,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                            job[i][
                                                                                'state'],
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
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
                                                              Text(
                                                                  job[i][
                                                                      'content'],
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
                                                                  for (int s =
                                                                          0;
                                                                      s <
                                                                          job[i]['skill_id']
                                                                              .length;
                                                                      s++)
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left: 3
                                                                              .w,
                                                                          right:
                                                                              3.w),
                                                                      padding: EdgeInsets.only(
                                                                          left: 5
                                                                              .w,
                                                                          right: 5
                                                                              .w,
                                                                          top: 2
                                                                              .h,
                                                                          bottom:
                                                                              2.h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.grey,
                                                                            width: 1),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        job[i]['skill_id']
                                                                            [s],
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10.sp,
                                                                          color:
                                                                              Colors.black,
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
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                companyProfile(job[i]['company_id'])),
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        (job[i]['company_profile_pic'] !=
                                                                                '')
                                                                            ? Container(
                                                                                margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                                height: 30.h,
                                                                                width: 30.w,
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(job[i]['company_profile_pic']))),
                                                                              )
                                                                            : Container(
                                                                                margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                                                                height: 30.h,
                                                                                width: 30.w,
                                                                                decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/findpro.png'))),
                                                                              ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              job[i]['company_name'],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
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
                                                                    children: [
                                                                      Text(
                                                                        'openings: ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13.sp),
                                                                      ),
                                                                      Text(
                                                                        job[i][
                                                                            'position_available'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13.sp),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3.w,
                                                                          ),
                                                                          Text(
                                                                              job[i]['created_hours'],
                                                                              style: TextStyle(fontSize: 13.sp)),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (loadMore == true)
                                    const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/no-results.png',
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                    Text(
                                      'No Search Found',
                                      style: TextStyle(
                                          color: Color(0xFF0681af),
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(
                                      height: 200.h,
                                    ),
                                  ],
                                )),
                              ),
                  ),
          ],
        ),
      ),
    ));
  }
}
