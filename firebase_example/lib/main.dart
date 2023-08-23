import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/configs/route_controller.dart';
import 'src/constant/route_name.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'src/utils/utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel _channel;

bool isFlutterLocalNotificationsInitalized = false;

Future setupFlutterNotification() async {
  if (isFlutterLocalNotificationsInitalized) {
    return;
  }

  _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  initLocalNotification();
  initPushNotification();
  isFlutterLocalNotificationsInitalized = true;
}

Future initPushNotification() async {
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future initLocalNotification() async {
  const iOS = DarwinInitializationSettings();
  const android = AndroidInitializationSettings('@drawable/message');
  const settings = InitializationSettings(android: android, iOS: iOS);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (details) {
      final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
      handleMessageOpenApp(message);
    },
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);
}

Future<NotificationDetails> setNotificationDetail() async {
  final largeIcon = await Utils.downLoadFile(
    "https://images.pexels.com/photos/2664417/pexels-photo-2664417.jpeg?auto=compress&cs=tinysrgb&w=600",
    "largeIcon",
  );
  final bigImage = await Utils.downLoadFile(
    "https://images.pexels.com/photos/4641833/pexels-photo-4641833.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "bigImage",
  );

  final styleInfor = BigPictureStyleInformation(
    FilePathAndroidBitmap(bigImage),
    largeIcon: FilePathAndroidBitmap(largeIcon),
  );

  return NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      styleInformation: styleInfor,
      icon: '@drawable/message',
    ),
    iOS: const DarwinNotificationDetails(),
  );
}

Future showFlutterNotification(RemoteMessage remoteMgs) async {
  final RemoteNotification? remoteNotification = remoteMgs.notification;
  AndroidNotification? android = remoteMgs.notification?.android;

  if (remoteNotification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        remoteNotification.hashCode,
        remoteNotification.title,
        remoteNotification.body,
        await setNotificationDetail(),
        payload: jsonEncode(remoteMgs.toMap()));
  }
}

Future<void> handleBackgroundMessage(RemoteMessage remoteMsg) async {
  log('Handling a background message ${remoteMsg.messageId}');
}

@pragma('vm:entry-point')
void handleForegroundMsg(RemoteMessage remoteMsg) async {
  // Setup push notification
  await setupFlutterNotification();
  await showFlutterNotification(remoteMsg);

  log('Handling a foreground message ${remoteMsg.messageId}');
}

void handleMessageOpenApp(
  RemoteMessage remoteMsg, {
  bool isForeground = false,
}) async {
  // Setup push notification
  await setupFlutterNotification();
  navigatorKey.currentState?.pushNamed("/chat", arguments: remoteMsg);

  log(isForeground
      ? 'Handling current notification'
      : 'Handling a notification to open app.');
}

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

  // Handle a notification on background
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Handle a notification on foreground(user in app)
  FirebaseMessaging.onMessage.listen(handleForegroundMsg);

  // Handle a notification when once user open start app
  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      handleMessageOpenApp(value);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((value) {
    handleMessageOpenApp(value, isForeground: true);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      initialRoute: RouteName.init,
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteController().pageRoute,
    );
  }
}
