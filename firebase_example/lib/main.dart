import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/src/screens/account_screen.dart';
import 'package:firebase_example/src/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// Add a listener for tracking user as login, logout, change infor,...
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        log("User has not present!!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLogged = FirebaseAuth.instance.currentUser != null;

    return MaterialApp(
      title: 'Firebase pratice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isLogged ? "/home" : "/login",
      onGenerateRoute: (settings) {
        return CupertinoPageRoute(
          builder: (context) {
            switch (settings.name) {
              case "/home":
                return const HomeScreen();
              case "/login":
                return const LoginScreen();
              case "/account":
                return const AccountScreen();
              default:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
