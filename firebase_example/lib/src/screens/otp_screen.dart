import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/otp_input_field.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authInstance = FirebaseAuth.instance;
  final phoneController = TextEditingController();

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();

  String code = "";
  String verifyId = "";
  bool? correctCode;
  bool otpVisible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    phoneController.dispose();
    c1.dispose();
    c2.dispose();
    c3.dispose();
    c4.dispose();
    c5.dispose();
    c6.dispose();
  }

  void phoneAuth() async {
    await _authInstance.verifyPhoneNumber(
      phoneNumber: "+84${phoneController.text}",
      codeSent: (String verificationId, int? resendToken) {
        verifyId = verificationId;
        otpVisible = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (credential.smsCode != null && credential.smsCode!.isNotEmpty) {
          setState(() {
            c1.text = credential.smsCode![0];
            c2.text = credential.smsCode![1];
            c3.text = credential.smsCode![2];
            c4.text = credential.smsCode![3];
            c5.text = credential.smsCode![4];
            c6.text = credential.smsCode![5];
          });
        }
        await _authInstance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            log("Done !!");
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              (route) => false,
            );
          } else {
            log("Failed !!");
          }
        }).catchError((e) {
          log(e);
        });
      },
      verificationFailed: (FirebaseException e) {
        log(e.message.toString());
      },
    );
  }

  void sendCode() async {
    try {
      code = c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;
      var credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: code,
      );
      await _authInstance.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/home",
            (route) => false,
          );
        }
      });
    } catch (e) {
      setState(() {
        correctCode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    phoneController.text.isEmpty
                        ? "Enter your phone"
                        : "Enter the code sent to the number \n+84 ${phoneController.text}",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: otpVisible
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OtpInputField(controller: c1, isFirst: true),
                            OtpInputField(controller: c2),
                            OtpInputField(controller: c3),
                            OtpInputField(controller: c4),
                            OtpInputField(controller: c5),
                            OtpInputField(controller: c6, isLast: true),
                          ],
                        )
                      : TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: "Enter your phone",
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Don't receive any code.",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      children: [
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {},
                            child: const Text(
                              " Resend again. ",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    otpVisible ? sendCode() : phoneAuth();
                  },
                  child: Text(otpVisible ? "Verify OTP" : "Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
