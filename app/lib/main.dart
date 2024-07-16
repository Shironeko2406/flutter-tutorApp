// import 'package:app/Navigate/app_router.dart';
// import 'package:app/screen/home.dart';
// import 'package:app/screen/login_form.dart';
// import 'package:app/screen/profile.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const app());
// }

// class app extends StatelessWidget {
//   const app({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routerDelegate: route.routerDelegate,
//       routeInformationParser: route.routeInformationParser,
//       routeInformationProvider: route.routeInformationProvider,
//       debugShowCheckedModeBanner: false,
//       // home: HomePage(),
//     );
//     // return const MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   home: LoginPage(),
//     // );
//   }
// }

// import 'package:app/Navigate/app_router.dart';
// import 'package:app/screen/home.dart';
// import 'package:app/screen/login_form.dart';
// import 'package:app/screen/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final accessToken = prefs.getString('accessToken');
//   // Print accessToken
//   print('Access Token in SharedPreferences: $accessToken');
//   runApp(MyApp(hasToken: accessToken != null));
// }

// class MyApp extends StatelessWidget {
//   final bool hasToken;
//   const MyApp({Key? key, required this.hasToken}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       // Nếu bạn đang sử dụng router
//       routerDelegate: route.routerDelegate,
//       routeInformationParser: route.routeInformationParser,
//       routeInformationProvider: route.routeInformationProvider,
//     );
//   }
// }

import 'dart:io';
import 'package:app/FirebaseApi/firebase_api.dart';
import 'package:app/Navigate/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(); // Thêm dòng này để bỏ qua chứng chỉ SSL tự ký

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  await FirebaseApi().initNotification();

  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  // Print accessToken
  print('Access Token in SharedPreferences: $accessToken');
  runApp(MyApp(hasToken: accessToken != null));
}

class MyApp extends StatelessWidget {
  final bool hasToken;
  const MyApp({Key? key, required this.hasToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // Nếu bạn đang sử dụng router
      routerDelegate: route.routerDelegate,
      routeInformationParser: route.routeInformationParser,
      routeInformationProvider: route.routeInformationProvider,
    );
  }
}

// import 'dart:io';
// import 'package:app/FirebaseApi/firebase_api.dart';
// import 'package:app/Navigate/app_router.dart';
// import 'package:app/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   HttpOverrides.global =
//       MyHttpOverrides(); // Thêm dòng này để bỏ qua chứng chỉ SSL tự ký

//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   requestNotificationPermission();
//   await FirebaseMessaging.instance.setAutoInitEnabled(true);

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.notification}');
//     }
//   });

//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   print('token: $fcmToken');
//   // await FirebaseApi().initNotification();

//   final prefs = await SharedPreferences.getInstance();
//   final accessToken = prefs.getString('accessToken');
//   // Print accessToken
//   print('Access Token in SharedPreferences: $accessToken');
//   runApp(MyApp(hasToken: accessToken != null));
// }

// Future<void> requestNotificationPermission() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

//   print('User granted permission: ${settings.authorizationStatus}');
// }

// class MyApp extends StatelessWidget {
//   final bool hasToken;
//   const MyApp({Key? key, required this.hasToken}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       // Nếu bạn đang sử dụng router
//       routerDelegate: route.routerDelegate,
//       routeInformationParser: route.routeInformationParser,
//       routeInformationProvider: route.routeInformationProvider,
//     );
//   }
// }
