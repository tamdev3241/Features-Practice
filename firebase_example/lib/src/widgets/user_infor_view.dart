import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final User user;
  const UserData({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Infor",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Text(
              "uuId: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.uid,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "Email: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email ?? "Not found",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "isVerified: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.emailVerified.toString(),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
