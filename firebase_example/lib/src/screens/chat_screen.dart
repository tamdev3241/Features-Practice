import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "dsada",
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
