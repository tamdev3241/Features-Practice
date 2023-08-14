import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(() {
      Navigator.popUntil(context, (route) => false);
      Navigator.pushNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  signOut();
                },
                child: const Text(
                  "Sign out",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
