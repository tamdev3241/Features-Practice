import 'package:flutter/material.dart';

import '../widgets/class_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Classes List"),
      ),
      body: ListView.builder(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ClassItem();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
