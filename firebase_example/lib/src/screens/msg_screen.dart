import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/data_chat.dart';

class MsgScreen extends StatefulWidget {
  final RemoteMessage? message;
  const MsgScreen({
    super.key,
    this.message,
  });

  @override
  State<MsgScreen> createState() => _MsgScreenState();
}

class _MsgScreenState extends State<MsgScreen> {
  RemoteMessage? _msg;
  @override
  void initState() {
    super.initState();
    _msg = widget.message;

    FirebaseMessaging.onMessage.listen((remmoteMsg) {
      if (_msg != remmoteMsg) {
        setState(() {
          _msg = remmoteMsg;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Message",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _msg?.notification?.title ?? "Not title",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              _msg?.notification?.body ?? "Not Body",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            DataChat(
              data: _msg?.data,
            ),
          ],
        ),
      ),
    );
  }
}
