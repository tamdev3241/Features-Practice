import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../constant/route_name.dart';
import '../screens/forgot_pass_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/msg_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/scrashlytics_screen.dart';

class RouteController {
  CupertinoPageRoute pageRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: (context) {
      switch (settings.name) {
        case RouteName.init:
          bool isLogged = FirebaseAuth.instance.currentUser != null;
          return isLogged ? const HomeScreen() : const LoginScreen();
        case RouteName.home:
          return const HomeScreen();
        case RouteName.chat:
          return MsgScreen(
            message: (settings.arguments) as RemoteMessage,
          );
        case RouteName.crash:
          return const CrashlyticScreen();
        case RouteName.forgotPass:
          return const ForgotPassScreen();
        case RouteName.profile:
          return const ProfileScreen();
        case RouteName.otp:
          return const OTPScreen();
        case RouteName.login:
          return const LoginScreen();
        default:
          throw Exception("Not found route name: ${settings.name}");
      }
    });
  }
}
