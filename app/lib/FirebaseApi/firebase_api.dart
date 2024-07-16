// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseApi{
//   //create instance firebase messaging
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   //function initialize notification
//   Future <void> initNotification() async{
//     //request permission from user
//     await _firebaseMessaging.requestPermission();
//     //fetch the fcm token for this device
//     final fCMToken = await _firebaseMessaging.getToken();
//     //print token
//     print(fCMToken);
//   }
// }

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.messageId}');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.data}');
      // Xử lý payload khi ứng dụng đang mở và nhận được tin nhắn
    });
  }
}
