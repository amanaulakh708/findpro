import 'package:findpro/screens/bottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class howItWorks extends StatefulWidget {

  const howItWorks({super.key,});

  @override
  State<howItWorks> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<howItWorks> {


  @override
  void initState() {
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
        child: Column(children: [
          MyAppBar2(),
          SizedBox(height: 15.h,),
          Text('How It Works',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.sp),),
          SizedBox(height: 20.h,),
          Container(
            child: Column(children: [
              Image.asset('assets/images/wk-search.png',height: 100.h,width: 100.w,),
              SizedBox(height: 15.h,),
              Text('Search Professional',style: TextStyle(fontSize: 30.sp),)
            ],
            ),
          ),
          SizedBox(height: 15.h,),
          Container(
            child: Column(children: [
              Image.asset('assets/images/wk-review.png',height: 100.h,width: 100.w,),
              SizedBox(height: 15.h,),
              Text('Review Profiles',style: TextStyle(fontSize: 30.sp),)
            ],
            ),
          ),
          SizedBox(height: 15.h,),
          Container(
            child: Column(children: [
              Image.asset('assets/images/wk-contact.png',height: 100.h,width: 100.w,),
              SizedBox(height: 15.h,),
              Text('Contact Them',style: TextStyle(fontSize: 30.sp),)
            ],
            ),
          ),
          SizedBox(height: 15.h,),
          Container(
            child: Column(children: [
              Image.asset('assets/images/wk-rate.png',height: 100.h,width: 100.w,),
              SizedBox(height: 15.h,),
              Text('Rate Them',style: TextStyle(fontSize: 30.sp),)
            ],
            ),
          ),
          SizedBox(height: 15.h,),
        ],),

      ),
    )
    );
  }
}
