import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/assets_manager.dart';
import '../constant/sign_in_social_type_enum.dart';
import '../services/auth/auth_service_impl.dart';
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

  @override
  void initState() {
    super.initState();

    errorMgs = "";
    userSuccess = null;
  }

  void loginByEmail(String email, String pass) async {
    if (email.isNotEmpty && pass.isNotEmpty) {
      try {
        var user = await authService.signInWithEmail(
          emailController.text,
          passwordController.text,
        );

        if (user != null && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/home",
            (route) => false,
          );
        }
      } catch (e) {
        setState(() {
          errorMgs = e.toString();
        });
      }
    }
  }

  void loginAsGuess() async {
    try {
      var user = await authService.signInAsGuess();

      if (user != null && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/home",
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        errorMgs = e.toString();
      });
    }
  }

  void loginBySocial(SignInSocialType type) async {
    User? user;
    try {
      switch (type) {
        case SignInSocialType.facebook:
          user = await authService.signInWithSocial(SignInSocialType.facebook);
          break;
        case SignInSocialType.google:
          user = await authService.signInWithSocial(SignInSocialType.google);
          break;
        default:
          throw Exception("Not found social type: $type");
      }
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
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
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
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/forgotPass");
                  },
                  child: const Text(
                    "Forgot password",
                    style: TextStyle(
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        loginByEmail(
                            emailController.text, passwordController.text);
                      },
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: loginAsGuess,
                      child: const Text("Login as Guess"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  signUpByEmail(emailController.text, passwordController.text);
                },
                child: const Text("Sign up"),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Login with social app",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      loginBySocial(SignInSocialType.google);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.google,
                      height: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      loginBySocial(SignInSocialType.facebook);
                    },
                    child: SvgPicture.asset(
                      AssetsManager.facebook,
                      height: 30,
                    ),
                  )
                ],
              ),
              const Divider(),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/otp");
                  },
                  child: const Text(
                    "Sign in with Phone number",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
