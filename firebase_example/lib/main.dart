import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'src/screens/account_screen.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/forgot_pass_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/otp_screen.dart';
import 'src/services/firebase_message.dart';

// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel _channel;

bool _isFlutterLocalNotificationsInitalized = false;

Future<void> setupFlutterNotification() async {
  if (_isFlutterLocalNotificationsInitalized) {
    return;
  }

  _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  _isFlutterLocalNotificationsInitalized = true;
}

void showFlutterNotification(RemoteMessage remoteMgs) {
  final RemoteNotification? remoteNotification = remoteMgs.notification;
  AndroidNotification? android = remoteMgs.notification?.android;

  if (remoteNotification != null && android != null && !kIsWeb) {
    _flutterLocalNotificationsPlugin.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage remoteMsg) async {
  log('Handling a background message ${remoteMsg.messageId}');
}

@pragma('vm:entry-point')
void handleForegroundMsg(RemoteMessage remoteMsg) async {
  // Setup push notification
  await setupFlutterNotification();
  showFlutterNotification(remoteMsg);

  log('Handling a foreground message ${remoteMsg.messageId}');
}

void handleMessageOpenApp(RemoteMessage remoteMsg) async {
  // Setup push notification
  await setupFlutterNotification();

  navigatorKey.currentState?.pushNamed('/chat', arguments: remoteMsg);
}

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// ======= Setup firebase authentication listener ========
  // Add a listener for tracking user as login, logout, change infor,...
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      log("User has not present!!");
    }
  });

  /// ======== Setup firebase messaging =========

  // Setup firebase messaging
  await FirebaseMessageService().initNotifications();

  // Handle a notification on background
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Handle a notification on foreground(user in app)
  FirebaseMessaging.onMessage.listen(handleForegroundMsg);

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOpenApp);

  /// ======== Setup firebase debug mode  =========
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator("localhost", 9090);
  //     await FirebaseAuth.instance.useAuthEmulator("localhost", 9090);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLogged = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      title: 'Firebase pratice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: isLogged ? "/home" : "/login",
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          builder: (context) {
            switch (settings.name) {
              case "/home":
                return const HomeScreen();
              case "/chat":
                return const ChatScreen();
              case "/login":
                return const LoginScreen();
              case "/account":
                return const AccountScreen();
              case "/otp":
                return const OTPScreen();
              case "/forgotPass":
                return const ForgotPassScreen();
              default:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
