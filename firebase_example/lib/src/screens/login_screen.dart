import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service_impl.dart';
import '../widgets/user_infor_view.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authService = AuthServiceImpl();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMgs = "";
  User? userSuccess;

  void loginByEmail(String email, String pass) async {
    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        var user = await authService.signInWithEmail(
          emailController.text,
          passwordController.text,
        );

        if (user != null && context.mounted) {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        setState(() {
          errorMgs = e.toString();
        });
      }
    }
  }

  void signUpByEmail(String email, String pass) async {
    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        var user = await authService.signUpWithEmail(
          emailController.text,
          passwordController.text,
        );

        if (user != null) {
          setState(() {
            userSuccess = user;
          });
        }
      } catch (e) {
        setState(() {
          errorMgs = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMgs,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginByEmail(emailController.text, passwordController.text);
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                signUpByEmail(emailController.text, passwordController.text);
              },
              child: const Text("Sign up"),
            ),
            const SizedBox(height: 20),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return UserData(user: snapshot.data!);
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
