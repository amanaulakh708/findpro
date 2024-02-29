import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/login.dart';
import 'package:findpro/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        endDrawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.people_alt_rounded,
                ),
                title: const Text('How it works'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add_circle_rounded,
                ),
                title: const Text('JOIN AS PRO'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyRegistration(title: 'FindPro')),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: const Text('Login'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyLogin(title: 'FindPro')),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                child: IconButton(
                    onPressed: () {
                      _key.currentState!.openEndDrawer();
                    },
                    icon: Icon(Icons.menu_rounded)),
              ),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Container(
                // alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 20, top: 80),
                child: RichText(
                  text: const TextSpan(
                    text: 'There Are ',
                    style: TextStyle(
                        fontSize: 40, color: Colors.black54, letterSpacing: 0.3),
                    children: <TextSpan>[
                      TextSpan(
                          text: '1K',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' Professional Here For You!'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                child: const Text(
                  "Find High Quality Professionals At Your Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                padding:
                    EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 5),
                // color: Colors.white54,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        // padding: EdgeInsets.all(15),
                        child: const TextField(
                          // obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by name & professions',
                            prefixIcon: Icon(Icons.search_sharp),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.blueGrey,
                      ),
                      Container(
                        width: double.infinity,
                        // padding: EdgeInsets.all(15),
                        child: const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Location',
                            prefixIcon: Icon(Icons.location_pin),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        child: TextButton(
                          child: Text("Find", style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => MyDashboard()),
                            // );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: Colors.blue, // T
                            // padding: const EdgeInsets.only(top: 10, bottom: 10),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => BottomNav(
                      //                 )),
                      //           );
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(top: 10),
                      //     padding: EdgeInsets.only(top: 10,bottom: 10),
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //
                      //       borderRadius: BorderRadius.circular(3),
                      //     ),
                      //       child: Text(
                      //         "Find",
                      //         textAlign: TextAlign.center,
                      //         style: new TextStyle(color: Colors.white,
                      //           fontSize: 20.0,
                      //         ),
                      //       ),
                      //     ),
                      // ),
                    ]),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
