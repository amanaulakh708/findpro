import 'dart:async';
import 'dart:convert';
import 'package:findpro/apis/nearByUserApi.dart';
import 'package:findpro/apis/similerProApi.dart';
import 'package:findpro/apis/userApi.dart';
import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;

class MyResult extends StatefulWidget {
  const MyResult({super.key, required this.title, required this.api});

  final String title;
  final String api;

  @override
  State<MyResult> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyResult> {
  ScrollController scrollController = ScrollController();
  String id = '';
  int limit = 10;
  int offset = 0;
  bool isFirstLoadRunning = false;
  List _posts = [];
  bool nextPage = true;
  bool loadMore = false;
  bool timer = false;
  List findData = [];


  Future<Users> fetchJSONData() async{
    print('kukjkj');
    // var jsonResponse = await http.get(Uri.parse(apiURL +'index'));

    var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
        body:{
          "type": 'profile',
          "limit": '10',
          "offset": '0'
        }
        );

    print('sdfdalklsf $jsonResponse');
    if (jsonResponse.statusCode == 200) {
      var resp = json.decode(jsonResponse.body);
      print('sdgfgfgsgv ${resp}');
      return Users.fromJson(resp['data']);
    } else{
      throw "not working";
    }
  }


  void firstload() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      //  SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? userId = prefs.getString('loginId');
      var allData = fetchJSONData();
      print('sfwefwe ${allData}');
      var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
        "type": 'profile',
        "limit": limit.toString(),
        "offset": offset.toString()
      });

      if (jsonResponse.statusCode == 200) {
        final jsonItems = json.decode(jsonResponse.body);
        print('sdflkyukuklksdf ${jsonItems}');
        _posts = jsonItems['data'];
        print('pooja ${_posts[0]}');
        print('dfkjbdjh ${_posts.length}');
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

  void loadmore() async {
    print('jnkjkj');
    if (nextPage == true &&
            isFirstLoadRunning == false &&
            loadMore == false &&
            scrollController.position.maxScrollExtent ==
                scrollController.position.pixels
        //scrollController.position.extentAfter < 300
        )
    {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });


      offset += 10;
      try {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        //  String? userId = prefs.getString('loginId');
        //  print('sdfsdf ${userId}');

        var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
            body: {
          "type": 'profile',
          "limit": limit.toString(),
          "offset": offset.toString()
        });

        print('dfkjbghfhfghdjh $jsonResponse');
        if (jsonResponse.statusCode == 200) {
          Timer(const Duration(seconds: 5),(){
            setState((){
              timer = true;
            });
          });
          var jsonItems = json.decode(jsonResponse.body);



          if (jsonItems.isNotEmpty) {
            _posts.addAll(jsonItems['data']);
            print('jjjkkk ${_posts.length}');
           
          }
          else {
            print('ukiukiki');
            setState((){
              nextPage = false;
            });
          }
        } else {
          throw Exception('Failed to load data from internet');
        }
      } catch (err){

        if (kDebugMode) {
          print('Something went wrong!');
        }
      }
      setState(() {
        loadMore = false;
      });
    }
  }

 void firstloadNearJson() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? city = prefs.getString('city');
      print('sfgsdefe $city');

      var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
        'keyword': 'mohali',
        'type': 'profile',
        "limit": limit.toString(),
        "offset": offset.toString()
      });

      if (jsonResponse.statusCode == 200) {
        final jsonItems = json.decode(jsonResponse.body);
        print('sdflkyukuklksdf ${jsonItems}');
        _posts = jsonItems['data'];
        print('pooja ${_posts[0]}');
        print('dfkjbdjh ${_posts.length}');
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

  void loadmoreNearJson() async {
    print('jnkjkj');
    if (nextPage == true &&
            isFirstLoadRunning == false &&
            loadMore == false &&
            scrollController.position.maxScrollExtent ==
                scrollController.position.pixels
        //scrollController.position.extentAfter < 300
        ) {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });

      offset += 10;
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? city = prefs.getString('city');
        print('sfgsdefe $city');

        var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
          'keyword': 'mohali',
          'type': 'profile',
          "limit": limit.toString(),
          "offset": offset.toString()
        });
        print('dfkjbghfhfghdjh $jsonResponse');
        if (jsonResponse.statusCode == 200) {
          Timer(const Duration(seconds: 5), () {
            // <-- Delay here
            setState(() {
              timer = true; // <-- Code run after delay
            });
          });
          final jsonItems = json.decode(jsonResponse.body);

          if (jsonItems.isNotEmpty) {
            _posts.addAll(jsonItems['data']);

            print('jjjkkk ${_posts.length}');
          } else {
            // This means there is no more data
            // and therefore, we will not send another GET request
            setState(() {
              nextPage = false;
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

  void firstloadSimilarJson() async {
    setState(() {
      isFirstLoadRunning = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? category = prefs.getString('category');

      var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
        // 'lister_id': (userId != null)?userId: null,
        'keyword': category,
        "type": 'profile',
        "limit": limit.toString(),
        "offset": offset.toString()
      });

      if (jsonResponse.statusCode == 200) {
        final jsonItems = json.decode(jsonResponse.body);
        print('sdflkyukuklksdf ${jsonItems}');
        _posts = jsonItems['data'];
        print('pooja ${_posts[0]}');
        print('dfkjbdjh ${_posts.length}');
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

  void loadmoreSimilarJson() async {
    print('jnkjkj');
    if (nextPage == true &&
            isFirstLoadRunning == false &&
            loadMore == false &&
            scrollController.position.maxScrollExtent ==
                scrollController.position.pixels
        //scrollController.position.extentAfter < 300
        ) {
      setState(() {
        loadMore = true;
        print('dfgtgrtg ${loadMore}');
      });

      offset += 10;
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? category = prefs.getString('category');

        var jsonResponse = await http.post(Uri.parse(apiURL + "index"), body: {
          // 'lister_id': (userId != null)?userId: null,
          'keyword': category,
          "type": 'profile',
          "limit": limit.toString(),
          "offset": offset.toString()
        });
        print('dfkjbghfhfghdjh $jsonResponse');
        if (jsonResponse.statusCode == 200){
          Timer(const Duration(seconds: 5),(){
            // <-- Delay here
            setState((){
              timer = true; // <-- Code run after delay
            });
          });
          final jsonItems = json.decode(jsonResponse.body);

          if (jsonItems.isNotEmpty) {
setState((){_posts.addAll(jsonItems['data']);}
            );
            print('jjjkkk ${_posts.length}');
          } else {
            // This means there is no more data
            // and therefore, we will not send another GET request
            setState(() {
              nextPage = false;
            });
          }
        }
        else {
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
  void dispose() {
    // TODO: implement dispose
    _posts.clear();
    super.dispose();
  }

  @override
  void initState() {
    getLoginId();

    if (widget.api.toString() == 'api1') {
      firstloadNearJson();

    } else if (widget.api.toString() == 'api2') {
      firstload();
    } else {
      firstloadSimilarJson();
    }

    if (widget.api.toString() == 'api1'){
      scrollController = ScrollController()..addListener((loadmoreNearJson));
    } else if (widget.api.toString() == 'api2') {
      scrollController = ScrollController()..addListener((loadmore));
    } else {
      scrollController = ScrollController()..addListener((loadmoreSimilarJson));
    }

    // scrollController = ScrollController()
    //   ..addListener((loadmore));
    super.initState();
  }

  getLoginId() async {
    // _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
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
          preferredSize: const Size(double.infinity, 100),
          child: MyAppBar(),
        ),
        endDrawer: MyEndDrawer(),
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xffFAF9FF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyAppBar2(),
                Container(
                  margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
                  child: Text('Result for Professionals',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 20.sp,
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.all(
                    //       10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Container(
                    //         alignment: Alignment.centerLeft,
                    //
                    //         child: Text(
                    //           "All Professionals",
                    //           textScaleFactor: 1.0,
                    //
                    //           style: TextStyle(
                    //               fontSize: 18.sp,
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ),
                    //       Container(alignment: Alignment.centerRight,
                    //           padding: EdgeInsets.all(4),
                    //           decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(10),
                    //               border: Border.all(
                    //                   color: Colors.grey, width: 1)),
                    //           child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Icon(Icons.filter_list_rounded,size: 10,),
                    //               SizedBox(width: 3.w,),
                    //               Text(
                    //                 "Filter",
                    //                 textScaleFactor: 1.0,
                    //                 style: TextStyle(
                    //                   fontSize: 9.sp,
                    //                   color: Colors.black,
                    //                 ),
                    //               ),
                    //             ],)
                    //
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: (isFirstLoadRunning)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: ColorConstants.themeBlue,),
                                  SizedBox(height:200.h,),
                                ],
                              )),
                            )
                          : (_posts.isNotEmpty)
                              ? Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: Column(
                                    children: [
                                      Expanded(

                                        child: GridView.builder(
                                          itemCount: _posts.length,
                                          controller: scrollController,
                                          scrollDirection: Axis.vertical,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            crossAxisCount: 2,
                                            childAspectRatio: 1.w / 1.4.h,
                                          ),
                                          itemBuilder: (context, index) {
                                            return Container(
                                                child: (id != _posts[index]['id'])
                                                        ? Visibility(
                                                            visible: (_posts[index]['id'] !=
                                                                    _posts.last[
                                                                        'id'])
                                                                ? true
                                                                : false,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                print('sfdsf ${_posts.last['city']}');
                                                                print('sfdsf ${_posts[index]['id']}');
                                                                SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                prefs.setString(
                                                                    'link',
                                                                    _posts[index]
                                                                        ['link']);
                                                                prefs.setString(
                                                                    'category',
                                                                    _posts[index]
                                                                        [
                                                                        'category']);

                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const MyProfile()));
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius: const BorderRadius
                                                                            .only(
                                                                            topRight:
                                                                                Radius.circular(10),
                                                                            topLeft: Radius.circular(10)),
                                                                        child:
                                                                            FadeInImage(
                                                                          height:
                                                                              150.h,
                                                                          fadeOutCurve:
                                                                              Curves.linear,
                                                                          placeholderFit:
                                                                              BoxFit.fitWidth,
                                                                          placeholder:
                                                                              const AssetImage('assets/images/logo.png'),
                                                                          image:
                                                                              NetworkImage(_posts[index]['profileImage']),
                                                                          imageErrorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset('assets/images/logo.png',
                                                                                height: 150.h,
                                                                                fit: BoxFit.fitWidth);
                                                                          },
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          left: 5
                                                                              .w,
                                                                          top: 5
                                                                              .h),
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Text(
                                                                            _posts[index]['name'],
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            maxLines:
                                                                                1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              fontSize: 20.sp,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          RatingBar
                                                                              .builder(
                                                                               initialRating: (_posts[index]['average_rating'].toString() == '' || _posts[index]['average_rating'].toString() == null || _posts[index]['average_rating'].toString() == 'null')
                                                                                ? 0.0
                                                                                : double.parse(_posts[index]['average_rating']),
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
                                                                                (rating){
                                                                              print(rating);
                                                                            },
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5.h,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.only(
                                                                                left: 3.w,
                                                                                right: 3.w,
                                                                                top: 2.h,
                                                                                bottom: 1.h),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                              border: Border.all(color: Colors.grey, width: 1),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              (_posts[index]['category'] == null) ? '' : _posts[index]['category'],
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(
                                                                                fontSize: 10.sp,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5.h,
                                                                          ),
                                                                          Row(children: <Widget>[
                                                                            const Icon(Icons.location_on_rounded,
                                                                                size: 15),
                                                                            Text(
                                                                              _posts[index]['city'],
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(fontSize: 10.sp),
                                                                            ),
                                                                          ]),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              print(
                                                                  'sfdsf $id');
                                                              print(
                                                                  'sfdsf ${_posts.last['id']}');
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.setString(
                                                                  'link',
                                                                  _posts.last[
                                                                      'link']);
                                                              prefs.setString('category', _posts.last['category']);
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder:
                                                                          (context) => const MyProfile()));
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius: const BorderRadius
                                                                          .only(
                                                                          topRight: Radius.circular(
                                                                              10),
                                                                          topLeft:
                                                                              Radius.circular(10)),
                                                                      child:
                                                                          FadeInImage(
                                                                        height:
                                                                            150.h,
                                                                        fadeOutCurve:
                                                                            Curves.linear,
                                                                        placeholderFit:
                                                                            BoxFit.fitWidth,
                                                                        placeholder:
                                                                            const AssetImage(
                                                                          'assets/images/logo.png',
                                                                        ),
                                                                        image:
                                                                            NetworkImage(
                                                                          _posts
                                                                              .last['profileImage'],
                                                                        ),
                                                                        imageErrorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Image.asset(
                                                                              'assets/images/logo.png',
                                                                              height: 150.h,
                                                                              fit: BoxFit.fitWidth);
                                                                        },
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            5.w,
                                                                        top: 5
                                                                            .h),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <Widget>[
                                                                        Text(
                                                                          _posts
                                                                              .last['name'],
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20.sp,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        RatingBar
                                                                            .builder(
                                                                          initialRating: (_posts.last['average_rating'].toString() == 'null')
                                                                              ? 0.0
                                                                              : double.parse(_posts.last['average_rating']),
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
                                                                          itemPadding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 0.0),
                                                                          itemBuilder: (context, _) =>
                                                                              const Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.amber,
                                                                          ),
                                                                          onRatingUpdate:
                                                                              (rating) {
                                                                            print(rating);
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5.h,
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.only(
                                                                              left: 3.w,
                                                                              right: 3.w,
                                                                              top: 2.h,
                                                                              bottom: 1.h),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                              border: Border.all(color: Colors.grey, width: 1)),
                                                                          child:
                                                                              Text(
                                                                            // (_posts[index].l ['category'] =='' )?'':
                                                                            // _posts[index]['category'],
                                                                            _posts.last['category'],
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 10.sp,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5.h,
                                                                        ),
                                                                        Row(
                                                                            children: <Widget>[
                                                                              const Icon(Icons.location_on_rounded, size: 15),
                                                                              Text(
                                                                                _posts.last['city'],
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(fontSize: 10.sp),
                                                                              )
                                                                            ]),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                          },
                                        ),
                                      ),


                                        if(loadMore == true )
                                        CircularProgressIndicator(),

                                      if (nextPage == false)
                                        Container(
                                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                                          color: Colors.amber,
                                          child: const Center(
                                            child: Text('You have fetched all of the content'),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
