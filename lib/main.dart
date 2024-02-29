import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:findpro/apis/notification_api.dart';

import 'package:findpro/screens/dashboard.dart';
import 'package:findpro/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connectivity_message/internet_connectivity_message.dart';



// Future<void>handleBackgroungmsg(RemoteMessage message)async {
//   print('Payload: ${message.data}');
//   print('Title: ${message.notification!.title}');
//  }

  Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  // PushNotificationService();
  // await FirebaseApi().initNotifications();



  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(
       MyAppm());
}

class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    print('Token: $token');
    return token;
    }
    // Get the token
    await getToken();
  }
}


class MyAppm extends StatelessWidget {
  final PushNotificationService _notificationService = PushNotificationService();

  @override
  Widget build(BuildContext context){
    _notificationService.initialize();

    return const MaterialApp(
      title: 'My App',
      home: MyDashboard(),
      // onGenerateRoute: Router.generateRoute,
      // initialRoute: '/',
      // onLaunch: (Map<String, dynamic> message) async {
      //   print('onLaunch: $message');
      //   // Handle the notification
      // },
      // onResume: (Map<String, dynamic> message) async {
      //   print('onResume: $message');
      //   // Handle the notification
      // },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? connection;
  bool showFullMsg = false;


  @override
  void initState() {
    checkInternet();
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('dfgvsfvg');
      if (result == ConnectivityResult.none) {
        //connection is mobile data network
        setState(() {
          showFullMsg = true;
        });
      }
      if (result == ConnectivityResult.mobile) {
        //there is no any connection
        setState(() {
          showFullMsg = false;
        });
      }

      // if (result == ConnectionState.active)

      if (result == ConnectivityResult.wifi){
        //there is no any connection
        setState(() {
          showFullMsg = false;
        });
      }
    });
    // FirebaseMessaging.instance.getInitialMessage().then((message){
    //   print('FirebaseMessaging.instance.getInitialMessage');
    //   if(message!=null){
    //     print('new notification');
    //
    //   }
    // });
    super.initState();
    // FirebaseMessaging.onMessage.listen((message) {
    //   print(' FirebaseMessaging.onMessage.listen');
    //   if(message.notification!=null){
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //     print('message.data11 ${message.data}');
    //
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print(' FirebaseMessaging.onMessageOpenedApp.listen');
    //   if(message.notification!=null){
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //     print('message.data22 ${message.data['id']}');
    //
    //   }
    // });
    //

  }

  checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none){
      setState(() {
        showFullMsg = true;
        }
       );
    }
  }

  @override
  Widget build(BuildContext context){
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: Colors.transparent,
    // statusBarIconBrightness: Brightness.dark, //top bar icons
    // systemNavigationBarColor: ColorConstants.backgroundColor, //bottom bar color
    // systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    // ));

    Size size = WidgetsBinding.instance.window.physicalSize;
    double width = size.width / 2;
    double height = size.height / 2;
    if (width < 650) {
      width = 390;
      print(size.width);
      height = 800;
      print(size.height);
    } else {
      width = size.width / 2.95;
      print(size.width);
      height = size.height / 2.65;
      print(size.height);
    }
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (BuildContext context, child) => GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
          scrollBehavior: _ScrollBehaviourWithoutGlowEffect(),
          theme: ThemeData(
            // canvasColor: ColorConstants.themeBlue,
            useMaterial3: false,
            // androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
            fontFamily: 'DmSans',
            scaffoldBackgroundColor: ColorConstants.backgroundColor,
            unselectedWidgetColor: Color.fromARGB(255, 227, 227, 227),
          ),
          debugShowCheckedModeBanner: false,
          // builder: (context, child) => BaseWidget(child: Container(color: Colors.transparent,)),
          home: (showFullMsg)?internetWidget(context):SplashScreen(),

        ),
      ),
    );
  }

  Widget internetWidget(BuildContext context) {
    return Scaffold(
      body: InternetMessage(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fullScreenMsg: showFullMsg,
        titleStyle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            wordSpacing: -5),
        fullScreenTitle1: Text(
          'No internet connection',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        widget: Image.asset(
          'assets/images/findpro.png',
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}



class _ScrollBehaviourWithoutGlowEffect extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
