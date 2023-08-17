import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/assets_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;

  void signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(() {
      Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
    });
  }

  void update() {
    //TODO: To be handle later
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: user != null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: user!.photoURL != null
                            ? Image.network(
                                user!.photoURL!,
                                height: 100,
                                width: 100,
                              )
                            : SvgPicture.asset(
                                AssetsManager.avatar,
                                height: 100,
                                width: 100,
                              ),
                      ),
                      const SizedBox(height: 30.0),
                      RichText(
                        text: TextSpan(
                            text: "Email: ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            children: [
                              TextSpan(
                                text: user!.email,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              WidgetSpan(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: user!.emailVerified
                                          ? Colors.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Text(
                                    user!.emailVerified
                                        ? "verified"
                                        : "Not verified",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 5.0),
                      RichText(
                        text: TextSpan(
                          text: "Phone: ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: user!.phoneNumber ?? "To be updated",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Row(
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
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "Update",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(child: Text("User not found")),
        ),
      ),
    );
  }
}
