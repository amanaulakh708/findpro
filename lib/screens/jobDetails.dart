import 'dart:convert';

import 'package:findpro/screens/bottomNav.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/Constants.dart';

class jobDetails extends StatefulWidget {
  final String id;
  final String title;
  final String companyPic;
  final String companyName;
  final String minExp;
  final String maxExp;
  final String minSalary;
  final String maxSalary;
  final String city;
  final String state;
  final String daysAgo;
  final String content;
  final String hiringTimeline;
  final String deadline;
  final String jobType;
  final String jobSchedule;
  final String quickHiring;
  final String supPay;
  final String qualification;
  final String company_id;
  final bool applied;
  final List skills;

  jobDetails(this.id,this.title,this.companyPic,this.companyName,this.minExp,this.maxExp,this.minSalary,this.maxSalary,this.city,this.state,
      this.daysAgo,this.content,this.hiringTimeline,this.deadline,this.jobType,this.jobSchedule,this.quickHiring,this.supPay,this.qualification,
      this.skills,this.applied,this.company_id);

  @override
  State<jobDetails> createState() => _jobDetails();
}


class _jobDetails extends State<jobDetails> {

  bool applyClicked = false;
  bool appliedButton = false;
  String name = '';


  Future<void> applyJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('loginId');
    print('sdfsf $userId');
    try {
      var response = await http.post(
          Uri.parse(apiURL + 'apply_job'),
          body: {
            'job_id': widget.id,
            'company_id': widget.company_id,
            'lister_id': (userId != null)?userId: '0',
          }
      );

      print('fgdgfxg${response}');
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        print('jbkjkb $jsondata');
        setState(() {
          // widget.applied = true;
          appliedButton = true;
          applyClicked = false;
          // initState();
        });


        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                jsondata['data'],
                style: TextStyle(color: Colors.white),),
              behavior: SnackBarBehavior.floating,));

        if (jsondata["error"]) {
          print(jsondata["msg"]);
        } else {
          print("Upload successful");
        }
      }
       else if(response.statusCode == 404){
         var jsondata = json.decode(response.body);
        print('sdgfsf ${response.statusCode}');
        setState(() {
          applyClicked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content:
              Text(
                jsondata['data'],
                style: TextStyle(color: Colors.white),),
              behavior: SnackBarBehavior.floating,));
      }
      else {
        print("Error during connection to server");
      }
    } catch (e) {
      print(e);
      print('thstfhsr');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return SafeArea(child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: MyAppBar(),
      ),
      endDrawer: MyEndDrawer(),
      backgroundColor: Color(0xffFAF9FF),
      body: SingleChildScrollView(

        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyAppBar2(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w,bottom: 10.h),
              margin: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Icon(Icons.more_horiz_rounded,color: Colors.transparent,),
                      Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp),),
                     Icon(Icons.more_horiz_rounded,color: Colors.transparent,),

                    ],),
                  SizedBox(height: 10.h,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (widget.companyPic!= '')?
                    Container(
                      margin: EdgeInsets
                          .only(
                          left: 5
                              .w,
                          right: 5
                              .w),
                      height: 30
                          .h,
                      width: 30
                          .w,
                      decoration: BoxDecoration(
                          shape: BoxShape
                              .circle,

                          image:  DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image: NetworkImage(widget.companyPic)
                          )),
                    ):
                    Container(
                      margin: EdgeInsets
                          .only(
                          left: 5
                              .w,
                          right: 5
                              .w),
                      height: 30
                          .h,
                      width: 30
                          .w,
                      decoration: BoxDecoration(
                          shape: BoxShape
                              .circle,

                          image:  DecorationImage(
                              fit: BoxFit
                                  .cover,
                              image:  AssetImage(
                                  'assets/images/findpro.png')
                          )),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.companyName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: 3,
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
                      ],)

                  ],),
                  SizedBox(height: 10.h,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Row(children: [
                        Icon(Icons.shopping_bag_outlined,size: 15,),
                        SizedBox(width: 2.w,),
                        Text(widget.minExp,style: TextStyle(fontSize: 13.sp,),),
                        Text(' - ',style: TextStyle(fontSize: 13.sp,),),
                        Text(widget.maxExp,style: TextStyle(fontSize: 13.sp,),),
                      ],),
                      SizedBox(width: 10.w,),
                      Row(children: [
                        Icon(Icons.currency_rupee_rounded,size: 15,),
                        SizedBox(width: 2.w,),
                        Text(widget.minSalary,style: TextStyle(fontSize: 13.sp,)),
                        Text(' - ',style: TextStyle(fontSize: 13.sp,)),
                        Text(widget.maxSalary,style: TextStyle(fontSize: 13.sp,)),

                      ],),
                      SizedBox(width: 10.w,),
                      Row(children: [
                        Icon(Icons.location_on,size: 15,),
                        SizedBox(width: 2.w,),
                        Text(widget.city,style: TextStyle(fontSize: 13.sp,)),
                        Text(',',style: TextStyle(fontSize: 13.sp,)),
                        Text(widget.state,style: TextStyle(fontSize: 13.sp,)),
                      ],),
                        SizedBox(width: 10.w,),
                        Row(children: [
                          Icon(Icons.access_time,size: 15,),
                          SizedBox(width: 2.w,),
                          Text(widget.daysAgo,style: TextStyle(fontSize: 13.sp,))
                        ],)
                    ],),
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center,
                    children: [
                      (widget.applied == false && appliedButton == false)?
                      Container(
                        child: (applyClicked == false)?
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            setState(() {
                              name = prefs.getString('name') ?? '';
                            });

                            if(name.isEmpty){
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
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
                            }else{
                              setState((){
                                applyClicked =true;
                              });
                              applyJob();
                            }
                            },
                          style: TextButton
                              .styleFrom(
                            foregroundColor: Colors
                                .white, splashFactory: NoSplash
                                .splashFactory,
                            backgroundColor: ColorConstants
                                .themeBlue, //
                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                          ),
                          child: Row(
                            children:[
                              Text(
                                  "Apply Now",
                                  style: TextStyle(
                                      fontSize: 12
                                          .sp),),
                              Icon(Icons.arrow_forward_rounded,size: 16,)
                            ],
                          ),
                        ):
                        CircularProgressIndicator(),
                      )
                          :
                     Container(
                          child: TextButton(
                            onPressed: () async {
                              // applyJob();
                            },
                            style: TextButton
                                .styleFrom(
                              foregroundColor: Colors
                                  .white, splashFactory: NoSplash
                                  .splashFactory,
                              backgroundColor: ColorConstants
                                  .themeBlue.withOpacity(0.5), //
                              // padding: const EdgeInsets.only(top: 10, bottom: 10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                    "Applied",
                                    style: TextStyle(
                                        fontSize: 12
                                            .sp)),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(
                        width: 10
                            .w,),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius
                            .circular(
                            5.0),
                            border: Border.all(
                              color: ColorConstants.themeBlue,
                              width: 1,
                            ),),
                        child: Icon(Icons.bookmarks_outlined,color: ColorConstants.themeBlue,size: 14.sp,),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  const Divider(
                    color: ColorConstants
                        .dividerGrey,
                    height: 0,
                    thickness: 1,
                    // indent: 10.0,
                    // endIndent: 10.0,
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(
                         top: 10),
                    child: Text(
                      "Job description:",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Align(
                    alignment: Alignment.topLeft,
                      child: Text(widget.content,textAlign: TextAlign.start,style: TextStyle(fontSize: 15.sp,))),
                  SizedBox(height: 16.h,),

                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Timeline for hiring: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.hiringTimeline,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('Application Deadline: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.deadline,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('Job Type: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.jobType,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('Job schedule: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.jobSchedule,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('How quickly you need to hire: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.quickHiring,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('Suplemental pay offered: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.supPay,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            Text('Qualification: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            Text(widget.qualification,style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        SizedBox(height: 3.h,),

                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Key Skills: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            SizedBox(height: 3.h,),
                            Row(
                              children: [
                                for (int s=0; s < widget.skills.length; s++)
                                  Container(
                                    margin: EdgeInsets.only(left: 3.w,right: 3.w),
                                    padding: EdgeInsets.only(
                                        left: 5.w,
                                        right: 5.w,
                                        top: 2.h,
                                        bottom: 2.h),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius
                                            .circular(10),
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: 1)),
                                    child: Text(
                                      widget.skills[s],
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                  top: 10,left: 10),
              child: Text(
                "Similar Job",
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
             Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
              padding: EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Flutter developer',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                      Row(children: [
                        Text('New',style: TextStyle(fontSize: 12,color: ColorConstants.themeBlue),),
                        SizedBox(width: 3.w,),
                        Icon(Icons.more_horiz_rounded)
                      ],)
                    ],),
                  SizedBox(height: 10.h,),
                  Row(children: [
                    Row(children: [
                      Icon(Icons.shopping_bag_outlined,size: 15,),
                      SizedBox(width: 2.w,),
                      Text('0-1 Yrs',style: TextStyle(fontSize: 13.sp,),)
                    ],),
                    SizedBox(width: 15.w,),
                    Row(children: [
                      Icon(Icons.currency_rupee_rounded,size: 15,),
                      SizedBox(width: 3.w,),
                      Text('50,000 - 1 Lakh',style: TextStyle(fontSize: 13.sp,))
                    ],),
                    SizedBox(width: 15.w,),
                    Row(children: [
                      Icon(Icons.location_on,size: 15,),
                      SizedBox(width: 3.w,),
                      Text('Mohali,Panjab',style: TextStyle(fontSize: 13.sp,))
                    ],)
                  ],),
                  SizedBox(height: 10.h,),
                  Text('Are you a talented,Ambitious and curious front-end developer lookimg for a new opportunity to showcase your skill',style: TextStyle(fontSize: 15.sp,)),
                  SizedBox(height: 10.h,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 2.h,bottom: 2.h),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey, width: 1)),
                        child: Text(
                          'Dart',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Container(
                        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 2.h,bottom: 2.h),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey, width: 1)),
                        child: Text(
                          'Android Studio',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w,),
                      Container(
                        padding: EdgeInsets.only(left: 5.w,right: 5.w,top: 2.h,bottom: 2.h),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey, width: 1)),
                        child: Text(
                          'Java',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Divider(
                    color: ColorConstants
                        .dividerGrey,
                    height: 0,
                    thickness: 1,
                    // indent: 10.0,
                    // endIndent: 10.0,
                  ),
                  SizedBox(height: 10.h,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          margin: EdgeInsets
                              .only(
                              left: 5
                                  .w,
                              right: 5
                                  .w),
                          height: 30
                              .h,
                          width: 30
                              .w,
                          decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle,

                              image:  DecorationImage(
                                  fit: BoxFit
                                      .cover,
                                  image: AssetImage('assets/images/findpro.png')
                              )),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Scorpio Info Tech',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),),
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: 3,
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
                          ],)

                      ],),
                      Row(children: [
                        Text('openings: 1',style: TextStyle(fontSize:13.sp ),),
                        SizedBox(width: 10,),
                        Row(children: [
                          Icon(Icons.access_time,size: 15,),
                          SizedBox(width: 3.w,),
                          Text('12 Hours Ago',style: TextStyle(fontSize:13.sp)),
                        ],)
                      ],)
                    ],)
                ],),
            ),


          ],
        ),
      ),
    )
    );
  }
}