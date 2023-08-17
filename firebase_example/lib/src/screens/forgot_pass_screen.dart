import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/src/services/auth/auth_service_impl.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final emailController = TextEditingController();
  final authService = AuthServiceImpl();
  String errorMgs = "";
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void sendEmail() async {
    try {
      if (emailController.text.isNotEmpty) {
        bool isSent = await authService.resetPassword(emailController.text);
        if (isSent && context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  "A reset password link sent!. Check your email",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              );
            },
          );
        }
      }
    } catch (e) {
      setState(() {
        errorMgs = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width / 2) + 100,
              child: const Text(
                "Please enter your email address to receive a verification code.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorMgs,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                sendEmail();
              },
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
