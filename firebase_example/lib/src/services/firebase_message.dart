import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageService {
  final FirebaseMessaging _fcmInstance = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _fcmInstance
        .requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    )
        .then((notifySettings) {
      if (notifySettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        log('User granted permission');
      } else if (notifySettings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('User granted provisional permission');
      } else {
        log('User declined or has not accepted permission');
      }
    });

    var token = await _fcmInstance.getToken();
    log("Fcm token in app: $token");
  }
}
