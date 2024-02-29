import 'dart:async';
import 'dart:convert';
import 'package:findpro/global/Constants.dart';
import 'package:findpro/screens/allJobs.dart';
import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/editProfile.dart';
import 'package:findpro/screens/howItWorks.dart';
import 'package:findpro/screens/registration.dart';
import 'package:findpro/screens/searchResult.dart';
import 'package:findpro/screens/signInUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class MyAppBar extends StatefulWidget {

  @override
  _MyAppBar createState() => _MyAppBar();
}

class _MyAppBar extends State<MyAppBar> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final fieldText = TextEditingController();
  Stopwatch watch = Stopwatch();
  bool isSearchEmpty = false;

  String city = '';
  String stateArea = '';
  String name = '';
  String id = '';
  String elapsedTime = '03:00';
  int counter = 0;
 Timer? _timer;

  bool hideProfie = true;

  updateCounter() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
          city = prefs.getString('city')!;
          stateArea = prefs.getString('state')!;
        });
  }

  stopCounter() {
    setState(() {
      _timer?.cancel();
      // _timer.cancel();
    });
  }



  @override
  initState() {
    hideProIcon();
    _nameRetriever();
    super.initState();
  }

  hideProIcon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('agfadfvd $id');
    print('agfadfvd $name');
    setState(() {
      print('agfadfvd $id');
      print('agfadfvd $name');
      name = prefs.getString('name') ?? '';
      id = prefs.getString('id') ?? '';
      (name.isEmpty)?hideProfie = true:hideProfie = false;
    });
  }

  _nameRetriever() async {
    print('tfgfdgfd ${city}');
    if(city == '' ){
      Timer.periodic(Duration(seconds: 3), (timer) {
        print('hghgvhg');
        if (city.isNotEmpty) {
          timer.cancel();
        }
        updateCounter();
      });

      }else{
        _timer?.cancel();
      }
    }


  void clearText() {
    fieldText.clear();
    setState(() {
      isSearchEmpty = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Wrap(
        children: [
          Container(
            color: const Color(0xffFAF9FF),
            padding: EdgeInsets.only(
                right: 10.w, top: 5.h, bottom: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 20,
                  width: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (city.isNotEmpty)?
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         const Icon(Icons.location_pin, size: 13),
                          SizedBox(width: 2.w,),
                          Text(
                            '${"$city, $stateArea"} ',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ):
                    Container(),

                    SizedBox(
                      width: 10.w,
                    ),

                    Visibility(
                      visible: hideProfie,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const signInUp(title: 'FindPro'),
                            ),
                          );
                        },
                        child: const Icon(Icons.person),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(
            color: ColorConstants.dividerGrey,
            height: 0,
            thickness: 1,
            indent: 5.0,
            endIndent: 5.0,
          ),

        ],
      );
  }





//   void onTabTapped(int index) {
//     this._pageController?.animateToPage(index,
//         duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//   }
}



class MyAppBar1 extends StatefulWidget {

  @override
  State<MyAppBar1> createState() => _MyAppBar1();
}

class category {
  String? name;


  category(
      {
        required this.name,
      });

  factory category.fromJson(Map<String, dynamic> json) {
    return category(
      name: json['name'].toString(),

    );
  }


}

class _MyAppBar1 extends State<MyAppBar1> {

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final fieldText = TextEditingController();
  final _suggestionBox = SuggestionsBoxController();
  bool isSearchEmpty = false;
  List suggestons = [];



  @override
  void initState() {
    fetchCatJSONData();
    super.initState();
  }

  void clearText() {
    fieldText.clear();
    setState(() {
      isSearchEmpty = false;
    });
  }

  Future<List<category>> fetchCatJSONData() async {
    var jsonResponse = await http.get(Uri.parse(apiURL +'autoCompleteData?q=' + fieldText.text));

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);

     var data = jsonItems['data'];
      suggestons = [];
        setState(() {
          suggestons.addAll(data);
        });

     // return [];
     List<category> usersList = jsonItems['data'].map<category>((json){
        return category.fromJson(json);
      }).toList();

      return usersList;
    }
    else {
      throw Exception('Failed to load data from internet');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5.h,
      ),

      child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
              IconButton(
                  icon: SvgPicture.asset(
                    'assets/Svg/menu.svg',
                    width: 28.w,
                    height: 28.h,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                    // _key.currentState!.openDrawer();
                  }),
              Container(
                height: 45.h,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.zero,
                child:
                TypeAheadField(
                  hideOnLoading: true,
                  animationStart: 0,
                  animationDuration: Duration.zero,
                  // hideKeyboard: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    onChanged: (value) => {
                      fetchCatJSONData(),
                      setState(() {
                        isSearchEmpty = (value.isEmpty) ? false : true;
                      }),
                    },
                    controller: fieldText,
                    textCapitalization: TextCapitalization.words,
                    onEditingComplete: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('keyword', fieldText.text);


                //      FocusScope.of(context).unfocus();
                      if(fieldText.text.isNotEmpty) {
                        isSearchEmpty=false;
                        //fieldText.clear();

                       Navigator.push(
                         context,
                         MaterialPageRoute(
                            builder:  (context) =>
                              searchResult(keyword: fieldText.text,),
                             ),
                        );
                      }
                    },

                   textInputAction: TextInputAction.go,
                      autofocus: false,
                      style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(

                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        // isDense: true,
                        // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        hintText: 'Search Professionals',
                        suffixIcon: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: (isSearchEmpty)
                              ? IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: clearText,
                              icon: const Icon(Icons.cancel_rounded))
                              : IconButton(splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              padding: EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.search_rounded,
                                size: 25,
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         searchResult(title: 'FindPro'),
                                //   ),
                                // );
                              }),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))
                    ),
                   ),

                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      // color: Colors.lightBlue[50],

                          constraints:BoxConstraints(maxHeight:350.0),
                          hasScrollbar: true,



                          borderRadius: BorderRadius.circular(5.r)
                  ),

                  suggestionsCallback: (pattern){

                    List<String> matches = <String>[];
                    if(fieldText.text.isEmpty){
                        matches.length = 0;
                    } else {
                      if (suggestons.length > 0) {
                        for (int i = 0; i < suggestons.length; i++) {
                          matches.add(suggestons[i]['name']);
                        }
                      }
                    }
                    matches.retainWhere((s){
                      return s.toLowerCase().contains(pattern.toLowerCase());
                    });
                    return matches;
                  },

                  itemBuilder: (context, sone) {
                    return Container(
                            // margin: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                            padding: EdgeInsets.all(10),
                            child:Text(sone.toString()),
                          )
                     ;
                  },

                  onSuggestionSelected: (suggestion) async {
                    fieldText.text = suggestion;
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('keyword', fieldText.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            searchResult(keyword:fieldText.text),
                      ),
                    );
                    print('fsdfsd $suggestion');
                  },
                )
              ),
              IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  alignment: Alignment.center,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                    // _key.currentState!.openEndDrawer();
                  },
                  icon: Icon(Icons.notifications,size: 25,)),
            ],
          ),
    );
  }
}




class MyAppBar2 extends StatefulWidget {

  @override
  State<MyAppBar2> createState() => _MyAppBar2();
}

class _MyAppBar2 extends State<MyAppBar2> {

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final fieldText = TextEditingController();
  bool isSearchEmpty = false;
  List suggestons = [];


  @override
  void initState() {
    fetchCatJSONData();
    super.initState();
  }

  Future<List<category>> fetchCatJSONData() async {
    var jsonResponse = await http.get(Uri.parse(apiURL +'autoCompleteData?q=' + fieldText.text));

    if (jsonResponse.statusCode == 200) {
      final jsonItems = json.decode(jsonResponse.body);

      var data = jsonItems['data'];

      suggestons = [];
      setState(() {
        suggestons.addAll(data);
      });
      // return [];
      List<category> usersList = jsonItems['data'].map<category>((json) {
        return category.fromJson(json);
      }).toList();

      return usersList;
    } else{
      throw Exception('Failed to load data from internet');
    }
  }

  void clearText() {
    fieldText.clear();
    setState(() {
      isSearchEmpty = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
        top: 5.h,
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
             splashColor: Colors.transparent,
             highlightColor: Colors.transparent,
             hoverColor: Colors.transparent,
              onPressed: () {
            Navigator.pop(context);
            // _key.currentState!.openDrawer();
          },
            icon: Icon(Icons.arrow_back,size: 25,),
          ),

          //AutocompleteBasicExample(),
          Container(
            // color: Colors.red,
              height: 45.h,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
            //  padding: EdgeInsets.only(bottom: 5),
              child: TypeAheadField(
                   hideOnLoading: true,
                   animationStart: 0,
                   animationDuration: Duration.zero,
                   textFieldConfiguration: TextFieldConfiguration(
                   onChanged: (value) => {
                    fetchCatJSONData(),
                    setState((){
                       isSearchEmpty = (value.isEmpty) ? false : true;
                         },
                    ),
                  },

                    controller: fieldText,
                    textCapitalization: TextCapitalization.words,
                    onEditingComplete: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('keyword', fieldText.text);


                    FocusScope.of(context).unfocus();
                    if(!fieldText.text.isEmpty) {
                      isSearchEmpty=false;
                      //fieldText.clear();
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              searchResult(keyword: fieldText.text,),
                        ),
                      );
                    }
                  },

                  textInputAction: TextInputAction.go,
                  autofocus: false,
                  style:const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      // isDense: true,
                      // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      hintText: 'Search Professionals',
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: (isSearchEmpty)
                            ? IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: clearText,
                            icon:const Icon(Icons.cancel_rounded))
                            : IconButton(splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 25,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         searchResult(title: 'FindPro'),
                              //   ),
                              // );
                            }),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))
                  ),
                ),

                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  // color: Colors.lightBlue[50],
                      constraints:const BoxConstraints(maxHeight:350.0),
                      hasScrollbar: true,
                     borderRadius: BorderRadius.circular(5.r)
                ),

                suggestionsCallback: (pattern){
                  List<String> matches = <String>[];
                  if(fieldText.text.isEmpty){
                    matches.length = 0;
                  } else{
                    if (suggestons.length > 0){
                      for (int i = 0; i < suggestons.length; i++){
                        matches.add(suggestons[i]['name']);
                      }
                    }
                  }
                  matches.retainWhere((s){
                    return s.toLowerCase().contains(pattern.toLowerCase());
                  });
                  return matches;
                },

                itemBuilder: (context, sone) {
                  return Container(
                    // margin: EdgeInsets.symmetric(vertical: 10.h),
                    width: double.infinity,
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.all(10),
                    child:Text(sone.toString()),
                  )
                  ;
                },

                onSuggestionSelected: (suggestion) async {
                  fieldText.text = suggestion;
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('keyword', fieldText.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          searchResult(keyword:fieldText.text),
                    ),
                  );
                  print('fsdfsd $suggestion');
                },
              )
          ),

          IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                // Scaffold.of(context).openEndDrawer();
                Scaffold.of(context).openEndDrawer();
              }, icon: const Icon(Icons.notifications,size: 25,)),
        ],
      ),
    );
  }
}



class MyDrawer extends StatefulWidget {

  @override
  State<MyDrawer> createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {

  String profilePic = '';
  static String name = '';
  String email = '';
  String id = '';

  int counter = 0;
  late Timer _timer;

  stopCounter() {
    _timer.cancel();
  }

  update() async {
    // _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        profilePic = prefs.getString('uploadImage') ?? '';
        id = prefs.getString('id') ?? '';
        name = prefs.getString('name') ?? '';
        email = prefs.getString('email') ?? '';
      });
    // });
  }

  _nameRetriever() async {
    if(profilePic.isEmpty){
      update();
    } else{
      stopCounter();
    }
  }

  // profileData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     profilePic = prefs.getString('avatar') ?? '';
  //     name = prefs.getString('name') ?? '';
  //     number = prefs.getString('phone') ?? '';
  //     print('rsdfsdf $profilePic');
  //     print('rsdfsdf $name');
  //   });
  // }

  @override
  void initState() {
    print('dfgxdgf $profilePic');
    _nameRetriever();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        width: 280.w,
        backgroundColor: ColorConstants.backgroundColor,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.fromLTRB(10.w, 0, 0.w, 0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (profilePic.isEmpty)?
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => MyLogin(title: 'FindPro')),
                          );
                        },
                        child: Stack(
                          children: [

                            Container(
                                width: 80.0.w,
                                height: 80.0.h,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                ),
                                        child:
                                        Image.asset('assets/images/Profilemale.png',)),
                            Positioned.fill(
                              // top: 30,
                              //   left: 20,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 7.w,top: 2.h,bottom: 2.h,left: 7.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.r),
                                        color: Color(0xFFF9F9F9),
                                      ),
                                        child: Text('LOGIN',style: TextStyle(fontSize: 15.sp),)))),
                          ],
                        ),
                      ) :
                      Container(
                          width: 80.0.w,
                          height: 80.0.h,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                  NetworkImage(profilePic)))),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      (name.isEmpty)?
                          Container(height: 20.h,):
                      Container(
                        margin: EdgeInsets.only(left: 2.w,bottom: 2.h),
                          child: Text(name,textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'DMSans-Bold',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                  ))),
                      (email.isEmpty)?
                          Container():
                      Container(
                          margin: EdgeInsets.only(left: 2.w),
                          child: Text(email,textScaleFactor: 1.0,
                              style:
                              TextStyle(color: Colors.black54, fontSize: 12.sp))),

                    ],
                  ),
                  (name.isEmpty)?
                      Container():
                  GestureDetector(
                      onTap: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(title: 'title')),
                        );
                      },
                      child: Icon(Icons.edit,color: Colors.grey,))
                ],
              ),
            ),
            ListTile(
                shape: RoundedRectangleBorder( //<-- SEE HERE
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(
                  Icons.home_filled,
                ),
                title:  Text('Home',textScaleFactor: 1.0),
                onTap: () {
                },
              ),
            ListTile(
                shape: RoundedRectangleBorder( //<-- SEE HERE
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(
                  Icons.settings_suggest_rounded,
                ),
                title: const Text('How it works',textScaleFactor: 1.0,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => howItWorks()),
                  );
                },
              ),
               ListTile(
                shape: RoundedRectangleBorder( //<-- SEE HERE
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(
                  Icons.work_rounded,
                ),
                title: const Text('Jobs',textScaleFactor: 1.0,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllJobs()),
                  );
                },
              ),

            (name.isEmpty)?
            ListTile(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                Icons.join_left_rounded,
              ),
              title: const Text('JOIN AS PRO',textScaleFactor: 1.0,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyRegistration(title: 'FindPro')),
                );
              },
            ):
                Container(),


            (name.isEmpty)?
            ListTile(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                Icons.person_rounded,
              ),
              title: const Text('Login',textScaleFactor: 1.0,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyLogin(title: 'FindPro')),
                );
              },
            ):
            ListTile(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                borderRadius: BorderRadius.circular(10),
              ),
              leading: Icon(
                Icons.power_settings_new_rounded,
              ),
              title: const Text('Log out',textScaleFactor: 1.0,),
              onTap: () async {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context)
                    {
                      return
                      AlertDialog(
                        contentPadding: EdgeInsets.symmetric(
                            vertical:
                            10),
                        title: Text(
                          'Confirm logout',
                          textAlign: TextAlign.center,style: TextStyle(color: ColorConstants.themeBlue),
                        ),
                        titleTextStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        content:Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: 
                                   Text('Are you sure you want to log out?')
                                  ),
                                  SizedBox(height: 10.h,),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                              foregroundColor: MaterialStateProperty.all<Color>(ColorConstants.themeBlue),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      side: BorderSide(color: ColorConstants.themeBlue)
                                                  )
                                              )
                                          ),
                                          child: Text("Cancel",style: TextStyle(fontSize: 15.sp)),
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      Container(
                                        child: TextButton(
                                          onPressed: () async {
                                            SharedPreferences preferences = await SharedPreferences.getInstance();
                                            await preferences.clear();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyDashboard()),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white, splashFactory: NoSplash.splashFactory,
                                            backgroundColor: ColorConstants.themeBlue, //
                                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          ), child: Text("OK",style: TextStyle(fontSize: 15.sp)),
                                        ),
                                      ),
                                    ],
                                  ),
                                 
                                ],
                              ),
                           
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }}



class MyEndDrawer extends StatefulWidget {

  @override
  State<MyEndDrawer> createState() => _MyEndDrawer();
}

class _MyEndDrawer extends State<MyEndDrawer> with SingleTickerProviderStateMixin{
  ScrollController controller = ScrollController();

  bool btVisiblity = false;


  late AnimationController acontroller =  AnimationController(vsync: this, duration: const Duration(seconds: 2));
  late final Animation<Offset> offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0))
      .animate(acontroller);



  @override
  void initState() {
    showButton();
    super.initState();
  }

  void showButton() {
    controller = ScrollController()
      ..addListener(() {
        setState(() {
          if (controller.position.pixels >= 150) {
            btVisiblity = true; // show the back-to-top button
          } else {
            btVisiblity = false; // hide the back-to-top button
          }
        });
      });

  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Drawer(
              backgroundColor: ColorConstants.backgroundColor,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: controller,
                  child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(30.w, 30.h, 0, 20.h),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notifications',textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontFamily: 'DMSans-Bold',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 35.sp,
                                    ),),
                                  SizedBox(height: 5.h,),
                                  Container(
                                    // alignment: Alignment.center,
                                    // margin: const EdgeInsets.only(
                                    //     left: 30, right: 30, bottom: 20, top: 80),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'You have ',
                                        style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey,),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '0 Notifications',
                                              style: TextStyle(fontSize: 12.sp,color: ColorConstants.themeBlue,fontWeight: FontWeight.w400)),
                                          TextSpan(text: ' today.',style: TextStyle(
                                            fontSize: 12.sp, color: Colors.grey, ),),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],),
            ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: [
                          Icon(Icons.notifications_on_outlined,color: ColorConstants.dividerGrey,size: 50.sp,),
                          Text('No notifications',style: TextStyle(fontSize: 20.sp,color: ColorConstants.dividerGrey),)
                        ],
                      ),
                    ),
                  ),

                  Visibility(
                    visible: btVisiblity,
                    child: AnimatedContainer(
                                        margin: EdgeInsets.all(20.0),
                                        duration: Duration(milliseconds: 5000),
                                        alignment: Alignment.bottomRight,
                                        child:  GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (controller.hasClients) {
                                                    final position = controller.position.minScrollExtent;
                                                    controller.animateTo(
                                                      position,
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.bounceIn,
                                                    );
                                                  }
                                                });
                                              },
                                              child: RotatedBox(
                                                quarterTurns: 1,
                                                child: Image.asset(
                                                  'assets/images/btback.png',
                                                  height: 40.h,
                                                  width: 40.w,
                                                ),
                                              )),
                                      ),
                  ),


                ],
              )
          ),

    );
  }}



