import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slideupscreen/slide_up_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard.dart';

class TestSlideUpScreen extends SlideUpScreen {
  const TestSlideUpScreen(
      {
        super.key,
        required this.link,
        required this.number,
        required this.phoneStatus,
        required this.email,
        required this.address,
        required this.lat,
        required this.lon});

  final String link;
  final String number;
  final String phoneStatus;
  final String email;
  final String address;
  final String lat;
  final String lon;

  @override
  TestSlideUpState createState() => TestSlideUpState();
}

class TestSlideUpState extends SlideUpScreenState<TestSlideUpScreen> {
  @override
  Color get backgroundColor => Colors.transparent;

  @override
  Radius get topRadius => Radius.circular(24);

  @override
  double get topOffset => 50;

  @override
  double get offsetToCollapse => 50;

  final String lat = '30.704649';
  final String lng = '76.717873';
  final String currentLat = '30.72811';
  final String currentLng = '76.77065';
  final String desLat = '30.704649';
  final String desLng = '76.717873';


  @override
  Widget? bottomBlock(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).padding.bottom +16,
      color: const Color(0xffC9E9FC),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.themeBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0.r),
              topRight: Radius.circular(15.0.r),
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding:const EdgeInsets.all(6),
                  child: Image.asset('assets/images/minus.png',
                    fit: BoxFit.fitWidth, color: Colors.white, height: 4.h,
                    width: 28.w,)
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

        Container(
          width: double.infinity,
          // height: 150.0.h,
          color: Colors.white,
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          padding:
          EdgeInsets.only(top: 10.h, bottom: 20.h, left: 10.w, right: 10.w),
          child: SingleChildScrollView(
            child:
            (widget.number.isEmpty) ?
            Shimmer.fromColors(
              baseColor: ColorConstants.lightGrey,
              highlightColor: Colors.white,
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170.0.w,
                    height: 20.0.h,
                    decoration: BoxDecoration(color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 210.0.w,
                    height: 20.0.h,
                    decoration: BoxDecoration(color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Container(
                        width: 170.0.w,
                        height: 20.0.h,
                        decoration: BoxDecoration(color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.r)),
                      ),
                      Container(
                        width: 140.0.w,
                        height: 20.0.h,
                        decoration: BoxDecoration(color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.r)),
                      ),
                    ],
                  ),
                ],
              ),
            ) :
            Column(
              children: [
                (widget.phoneStatus.toString() == 'public') ?
                GestureDetector(
                  onTap: () async {
                    final call = Uri.parse('tel:+91 ' + widget.number);
                    if (await canLaunchUrl(call)) {
                      launchUrl(call);
                    } else {
                      throw 'Could not launch $call';
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_phone_rounded,
                        size: 20.sp,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        widget.number,
                        textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 15.sp),
                      )
                    ],
                  ),
                ):
                Container(),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () async {
                    String email =
                    Uri.encodeComponent(widget.email);
                    String subject = Uri.encodeComponent("Hello Findpro");
                    String body =
                    Uri.encodeComponent("Hi! I'm ...");
                    print(subject); //output: Hello%20Flutter
                    Uri mail =
                    Uri.parse(
                        "mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20.sp,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        widget.email,
                        textScaleFactor: 1.0,
                        style: TextStyle(fontSize: 15.sp),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        final String googleMapsUrl = 'comgooglemaps://?center=${widget
                            .lat},${widget.lon}';
                        final String appleMapsUrl = 'https://maps.apple.com/?q=${widget
                            .lat},${widget.lon}';

                        if (await canLaunchUrl(
                            Uri.parse(googleMapsUrl))) {
                          await launchUrl(Uri.parse(googleMapsUrl));
                        }
                        if (await canLaunchUrl(Uri.parse(appleMapsUrl))){
                          await launch(
                              appleMapsUrl, forceSafariVC: false);
                        } else {
                          throw 'Couldn’t launch URL';
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20.sp,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 170.w,
                            child: Text(
                              widget.address,
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: openDirection,
                      child: Row(
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 20.sp,
                          ),
                          SizedBox(width: 5.w,),
                          Text('(Get Direction)',
                            textScaleFactor: 1.0,
                            style: TextStyle(fontSize: 15.sp),
                          )],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  openDirection() async {
    final String mapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng &destination=$desLat,$desLng&travelmode=driving&dir_action=navigate';
    final String appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';

    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    }

    if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw 'Couldn’t launch URL';
    }
  }
}