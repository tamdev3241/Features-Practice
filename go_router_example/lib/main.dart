import 'package:flutter/material.dart';

import 'src/screens/route/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // routeInformationProvider: AppRouter.router.routeInformationProvider,
      // routeInformationParser: AppRouter.router.routeInformationParser,
      // routerDelegate: AppRouter.router.routerDelegate,
      routerConfig: AppRouter.router,
      title: 'Go Router',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
