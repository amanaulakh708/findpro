

import 'package:firebase_messaging/firebase_messaging.dart';


Future<void>handleBackgroungmsg(RemoteMessage message)async{
print('Title: ${message.notification?.title}');
print('Body: ${message.notification?.body}');
print('Payload: ${message.data}');

}

class FirebaseApi{
  final firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
     print('jghjjg');
    firebaseMessaging.requestPermission();
    final FCMoken= await firebaseMessaging.getToken();
    print('Todfken: $FCMoken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroungmsg);
  }
  

}