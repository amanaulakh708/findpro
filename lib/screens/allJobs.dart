import 'dart:async';
import 'dart:convert';
import 'package:findpro/apis/appliedJobsApi.dart';
import 'package:findpro/models/appliedJobsModel.dart';
import 'package:findpro/models/jobsModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/companyProfile.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/jobDetails.dart';
import 'package:findpro/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import '../global/Constants.dart';
class AllJobs extends StatefulWidget {
  @override
  _AllJobs createState() => _AllJobs();
}

class _AllJobs extends State<AllJobs> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  int _selectedIndex = 0;
  late TabController _tabController;
  String name = '';
  int limit = 10;
  int offset = 0;
  bool showProgress = false;
  var allJobsData;
  bool hideNew = true;
  bool isFirstLoadRunning = false;
  List _posts = [];
  bool nextPage = false;
  bool loadMore = false;

  bool timer =false;

    void firstload() async {
      setState(() {
        isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('loginId');
      var jsonResponse = await http.post(Uri.parse(apiURL + "listing"),
          body: {
            'lister_id': (userId != null)?userId: '0',
            "type": 'jobs',
            "limit": limit.toString(),
            "offset": offset.toString(),
          }
      );
      if (jsonResponse.statusCode == 200){
        final  jsonItems = json.decode(jsonResponse.body);
      //  print('sdflkyukuklksdf ${jsonItems}');
        _posts= jsonItems['data'];
            print('dfkjbdjh ${_posts.length}');

      } else{
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

  void loadmore() async {
    print('jnkjkj ');
    if (nextPage == false && isFirstLoadRunning == false &&
        loadMore == false && scrollController.position.maxScrollExtent == scrollController.position.pixels
       // scrollController.position.extentAfter < 300
    ) {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });



      offset +=10;
      try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('loginId');

        print('sdfsdf ${userId}');

        var jsonResponse = await http.post(
            Uri.parse(apiURL + "listing"),
            body:
            {
              'lister_id': (userId != null)?userId: '0',
              "type": 'jobs',
              "limit": limit.toString(),
              "offset": offset.toString(),
            }
        );
          print('dfkjbghfhfghdjh ${jsonResponse}');
          if (jsonResponse.statusCode == 200){
            Timer(Duration(seconds: 5), () { // <-- Delay here
              setState(() {
                timer = true; // <-- Code run after delay
              });
            });
          final jsonItems = json.decode(jsonResponse.body);


          if (jsonItems.isNotEmpty){
            _posts.addAll(jsonItems['data']);
          }
          if (jsonItems.isEmpty){
            setState(() {
              print('hbjhbj${nextPage}');
              nextPage = true;
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

  getAppliedJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      print('dsfdsf $name');
    });
    if (name.isNotEmpty) {
      fetchAppliedJobs();
    }
  }

  @override
  void initState() {
    super.initState();
    firstload();
    scrollController = ScrollController()
      ..addListener((loadmore));
    getAppliedJobs();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        timer = false;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Container(
            margin: EdgeInsets.only(top: 5.h),
            child: MyAppBar2(),
          ),
        ),
        endDrawer: MyEndDrawer(),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 40.h,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(10),
                    ),
                  ),
                  flexibleSpace: TabBar(
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: _selectedIndex == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                        color: ColorConstants.themeBlue),
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 23.sp,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "All Jobs",
                              style: TextStyle(fontSize: 15.sp),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Icon(
                              Icons.work_history_outlined,
                              size: 23.sp,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Applied Jobs",
                              style: TextStyle(fontSize: 15.sp),
                              textScaleFactor: 1.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  // padding: EdgeInsets.only(top: 15.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),

                  child:
                      TabBarView(
                          controller: _tabController, children: <Widget>[
                     Container(
                         color: ColorConstants.backgroundColor,
                        child: isFirstLoadRunning?
                         Shimmer.fromColors(
                          baseColor: ColorConstants.lightGrey,
                          highlightColor: Colors.white,
                         child: Column(
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius:
                                   BorderRadius.circular(10)),
                               margin: EdgeInsets.symmetric(
                                   horizontal: 10.w, vertical: 5.h),
                               padding: const EdgeInsets.all(10),
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
                                           const Text(
                                             'New',
                                             style: TextStyle(
                                                 fontSize: 12,
                                                 color: ColorConstants
                                                     .themeBlue),
                                           ),
                                           SizedBox(
                                             width: 3.w,
                                           ),
                                           const Icon(
                                               Icons.more_horiz_rounded)
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
                                           const Icon(
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
                                             Icons
                                                 .currency_rupee_rounded,
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
                                           const Icon(
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
                                             BorderRadius.circular(
                                                 10),
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
                                   const Divider(
                                     color: ColorConstants.dividerGrey,
                                     height: 0,
                                     thickness: 1,
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
                                                   left: 5.w,
                                                   right: 5.w),
                                               height: 30.h,
                                               width: 30.w,
                                               decoration:
                                               const BoxDecoration(
                                                 shape: BoxShape.circle,
                                               ),
                                             ),
                                             Column(
                                               crossAxisAlignment:
                                               CrossAxisAlignment
                                                   .start,
                                               children: [
                                                 SizedBox(
                                                   width: 130.w,
                                                   child: Text(
                                                     '',
                                                     overflow:
                                                     TextOverflow
                                                         .ellipsis,
                                                     softWrap: false,
                                                     style: TextStyle(
                                                         fontWeight:
                                                         FontWeight
                                                             .bold,
                                                         fontSize:
                                                         14.sp),
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
                             Container(
                               decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius:
                                   BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                      padding: const EdgeInsets.all(10),
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
                                           const Text(
                                             'New',
                                             style: TextStyle(
                                                 fontSize: 12,
                                                 color: ColorConstants
                                                     .themeBlue),
                                           ),
                                           SizedBox(
                                             width: 3.w,
                                           ),
                                           const Icon(Icons.more_horiz_rounded)
                                         ],
                                       )
                                     ],
                                   ),
                                   SizedBox(
                                     height: 10.h,
                                   ),
                                   Row(
                                     children:[
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
                                             Icons
                                                 .currency_rupee_rounded,
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
                                           const Icon(
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
                                             BorderRadius.circular(
                                                 10),
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
                                   const Divider(
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
                                                   left: 5.w,
                                                   right: 5.w),
                                               height: 30.h,
                                               width: 30.w,
                                               decoration:
                                               const BoxDecoration(
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
                                                     overflow:
                                                     TextOverflow
                                                         .ellipsis,
                                                     softWrap: false,
                                                     style: TextStyle(
                                                         fontWeight:
                                                         FontWeight
                                                             .bold,
                                                         fontSize:
                                                         14.sp),
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
                             Container(
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
                                           const Text(
                                             'New',
                                             style: TextStyle(
                                                 fontSize: 12,
                                                 color: ColorConstants
                                                     .themeBlue),
                                           ),
                                           SizedBox(
                                             width: 3.w,
                                           ),
                                           const Icon(
                                               Icons.more_horiz_rounded)
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
                                           const Icon(
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
                                             Icons
                                                 .currency_rupee_rounded,
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
                                           const Icon(
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
                                             BorderRadius.circular(
                                                 10),
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
                                   const Divider(
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
                                                   left: 5.w,
                                                   right: 5.w),
                                               height: 30.h,
                                               width: 30.w,
                                               decoration:
                                               const BoxDecoration(
                                                 shape: BoxShape.circle,
                                               ),
                                             ),
                                             Column(
                                               crossAxisAlignment:
                                               CrossAxisAlignment
                                                   .start,
                                               children: [
                                                 SizedBox(
                                                   width: 130.w,
                                                   child: Text(
                                                     '',
                                                     overflow:
                                                     TextOverflow
                                                         .ellipsis,
                                                     softWrap: false,
                                                     style: TextStyle(
                                                         fontWeight:
                                                         FontWeight
                                                             .bold,
                                                         fontSize:
                                                         14.sp),
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
                             Container(
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
                                           const Text(
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
                                           const Icon(
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
                                             Icons
                                                 .currency_rupee_rounded,
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
                                           const Icon(
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
                                             BorderRadius.circular(
                                                 10),
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
                                   const Divider(
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
                                                   left: 5.w,
                                                   right: 5.w),
                                               height: 30.h,
                                               width: 30.w,
                                               decoration:
                                               const BoxDecoration(
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
                                                     overflow:
                                                     TextOverflow
                                                         .ellipsis,
                                                     softWrap: false,
                                                     style: TextStyle(
                                                         fontWeight:
                                                         FontWeight
                                                             .bold,
                                                         fontSize:
                                                         14.sp),
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
                           ],
                         ),
                        )
                            :
                        Column(
                          children:[
                             //  for(int i = 0;i < _posts.length;i++ )

                            Expanded(
                              child:   ListView.builder(
                                                itemCount: _posts.length,
                                                shrinkWrap: true,
                                                physics: AlwaysScrollableScrollPhysics(),
                                                controller: scrollController,
                                                itemBuilder: (_, index) => Card(
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 8, horizontal: 10),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                jobDetails(
                                                                  _posts[index]['id'],
                                                                  _posts[index]['title'],
                                                                  _posts[index]['company_profile_pic'],
                                                                  _posts[index]['company_name'],
                                                                  _posts[index]['min_experience'],
                                                                  _posts[index]['max_experience'],
                                                                  _posts[index]['minimum'],
                                                                  _posts[index]['maximum'],
                                                                  _posts[index]['city'],
                                                                  _posts[index]['state'],
                                                                  _posts[index]['created_hours'],
                                                                  _posts[index]['content'],
                                                                  _posts[index]['hiring_timeline'],
                                                                  _posts[index]['deadline'],
                                                                  _posts[index]['job_type'],
                                                                  _posts[index]['job_schedule'],
                                                                  _posts[index]['quick_hiring_time'],
                                                                  _posts[index]['suplement_pay'],
                                                                  _posts[index]['qualification'],
                                                                  _posts[index]['skill_id'],
                                                                  _posts[index]['applied'],
                                                                  _posts[index]['company_id'],
                                                                )),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                          BorderRadius.circular(10)),
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
                                                                _posts[index]['title'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20.sp),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Visibility(
                                                                      visible: hideNew,
                                                                      child: (_posts[index]['created_hours']
                                                                          .toString()
                                                                          .contains(
                                                                          'days') ||
                                                                          _posts[index]['created_hours']
                                                                              .toString()
                                                                              .contains(
                                                                              '-'))
                                                                          ? Container()
                                                                          : Text(
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
                                                                  // Icon(Icons.more_horiz_rounded)
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
                                                                    Icon(
                                                                      Icons
                                                                          .shopping_bag_outlined,
                                                                      size: 15,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2.w,
                                                                    ),
                                                                    Text(
                                                                      _posts[index]['min_experience'],
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
                                                                      _posts[index]['max_experience'],
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
                                                                    Icon(
                                                                      Icons
                                                                          .currency_rupee_rounded,
                                                                      size: 15,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 3.w,
                                                                    ),
                                                                    Text(
                                                                        _posts[index]['minimum'],
                                                                        style: TextStyle(
                                                                          fontSize: 13.sp,
                                                                        )),
                                                                    Text(' - ',
                                                                        style: TextStyle(
                                                                          fontSize: 13.sp,
                                                                        )),
                                                                    Text(
                                                                        _posts[index]['maximum'],
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
                                                                    Text(
                                                                        _posts[index]['city'],
                                                                        style: TextStyle(
                                                                          fontSize: 13.sp,
                                                                        )),
                                                                    Text(',',
                                                                        style: TextStyle(
                                                                          fontSize: 13.sp,
                                                                        )),
                                                                    Text(
                                                                        _posts[index]['state'],
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
                                                          Text(_posts[index]['content'],
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
                                                                  _posts[index]['skill_id'].length;
                                                              s++)
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      left: 3.w,
                                                                      right: 3.w),
                                                                  padding: EdgeInsets.only(
                                                                      left: 5.w,
                                                                      right: 5.w,
                                                                      top: 2.h,
                                                                      bottom: 2.h),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(10),
                                                                      border: Border.all(
                                                                          color:
                                                                          Colors.grey,
                                                                          width: 1)),
                                                                  child: Text(
                                                                    _posts[index]['skill_id'][s],
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
                                                            color:
                                                            ColorConstants.dividerGrey,
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
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            companyProfile(
                                                                                _posts[index]['company_id'])),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    (_posts[index]['company_profile_pic'] !=
                                                                        "")
                                                                        ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          5.w,
                                                                          right: 5
                                                                              .w),
                                                                      height: 30.h,
                                                                      width: 30.w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                              image: NetworkImage(_posts[index]['company_profile_pic']))),
                                                                    )
                                                                        : Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          5.w,
                                                                          right: 5
                                                                              .w),
                                                                      height: 30.h,
                                                                      width: 30.w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          image: DecorationImage(
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                              image: AssetImage(
                                                                                  'assets/images/findpro.png'))),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Container(
                                                                          // width: 130.w,
                                                                          child: Text(
                                                                            _posts[index]['company_name'],
                                                                            overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                            maxLines: 1,
                                                                            softWrap: false,
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
                                                                          initialRating: 3,
                                                                          minRating: 0,
                                                                          direction: Axis
                                                                              .horizontal,
                                                                          allowHalfRating:
                                                                          true,
                                                                          itemCount: 5,
                                                                          itemSize: 12,
                                                                          itemPadding: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal:
                                                                              0.0),
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
                                                                    _posts[index]['position_available'],
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
                                                                      Text(
                                                                          _posts[index]['created_hours'],
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              13.sp)),
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),


                                        ),

                        if(loadMore==true)
                          const CircularProgressIndicator(),

                          ],
                        )
                      ),


                    Container(

                      color: ColorConstants.backgroundColor,
                      child: FutureBuilder<List<AplliedJobs>>(
                        future: fetchAppliedJobs(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState.toString() ==
                              'ConnectionState.waiting') {
                            return Shimmer.fromColors(
                              baseColor: ColorConstants.lightGrey,
                              highlightColor: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  for (int i = 0; i < 10; i++)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      padding: const EdgeInsets.all(15),
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
                                              Row(
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5.w,
                                                          right: 5.w),
                                                      height: 40.h,
                                                      width: 40.w,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      )),
                                                  //  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20.sp),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                            Text(' • '),
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 5.w,
                                                    right: 5.w,
                                                    top: 3.h,
                                                    bottom: 4.h),
                                                decoration: BoxDecoration(
                                                  color: ColorConstants
                                                      .themeBlue
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check_rounded,
                                                      color: Colors.white,
                                                      size: 15.sp,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    Text(
                                                      'Applied',
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                ]),
                              ),
                            );
                          }

                          if ((snapshot.data != null &&
                              snapshot.data!.length > 0)) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.length;
                                      i++)
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  companyProfile(snapshot
                                                      .data![i].company_id)),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        padding: EdgeInsets.all(15),
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
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5.w,
                                                          right: 5.w),
                                                      height: 40.h,
                                                      width: 40.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              snapshot.data![i]
                                                                  .company_profile_pic),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot.data![i]
                                                              .company_name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.sp),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                snapshot
                                                                    .data![i]
                                                                    .title,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.sp),
                                                              ),
                                                              Text(' • '),
                                                              Text(
                                                                snapshot
                                                                    .data![i]
                                                                    .created_hours,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.sp),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w,
                                                      right: 5.w,
                                                      top: 3.h,
                                                      bottom: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .themeBlue
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_rounded,
                                                        color: Colors.white,
                                                        size: 15.sp,
                                                      ),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Text(
                                                        'Applied',
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              child: Center(child: Text('No Applied jobs')),
                            );
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
