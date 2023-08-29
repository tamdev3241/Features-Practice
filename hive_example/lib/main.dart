import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'src/constant/string_constant.dart';
import 'src/models/todo.dart';
import 'src/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox(StringConfig.todoBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
