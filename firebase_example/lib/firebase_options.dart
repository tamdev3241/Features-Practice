import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBuGNPPD9QGGZGS-zS8SmR5bclCkAERzM4',
    appId: '1:618634774010:web:5dfb23ea9536778d0a9043',
    messagingSenderId: '618634774010',
    projectId: 'fir-example-564e1',
    authDomain: 'fir-example-564e1.firebaseapp.com',
    storageBucket: 'fir-example-564e1.appspot.com',
    measurementId: 'G-1SLYV8BBB2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCQXHQZei84XQMihTnhVSbUo12ZJA_H9U',
    appId: '1:618634774010:android:fa82bdd86580b3ef0a9043',
    messagingSenderId: '618634774010',
    projectId: 'fir-example-564e1',
    storageBucket: 'fir-example-564e1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzzU6JMIObem1lH2bB6JdShVywn1L_fqg',
    appId: '1:618634774010:ios:e27e9deacd10e0bf0a9043',
    messagingSenderId: '618634774010',
    projectId: 'fir-example-564e1',
    storageBucket: 'fir-example-564e1.appspot.com',
    iosClientId:
        '618634774010-v2j4mpncql6r46ha6dbkv23o5qb5q92s.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseExample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzzU6JMIObem1lH2bB6JdShVywn1L_fqg',
    appId: '1:618634774010:ios:e27e9deacd10e0bf0a9043',
    messagingSenderId: '618634774010',
    projectId: 'fir-example-564e1',
    storageBucket: 'fir-example-564e1.appspot.com',
    iosClientId:
        '618634774010-v2j4mpncql6r46ha6dbkv23o5qb5q92s.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseExample',
  );
}
