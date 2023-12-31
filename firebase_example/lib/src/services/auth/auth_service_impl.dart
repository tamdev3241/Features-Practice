import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constant/sign_in_social_type_enum.dart';
import 'auth_service.dart';

class AuthServiceImpl extends AuthService {
  final _authInstance = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive',
    ],
  );

  @override
  Future<User?> signInWithSocial(SignInSocialType typeProvider) async {
    User? user;
    try {
      OAuthCredential oAuthCredential;
      switch (typeProvider) {
        case SignInSocialType.google:
          oAuthCredential = await _signInWithGoogle();
          break;
        case SignInSocialType.facebook:
          oAuthCredential = await _signInWithFacebook();
          break;
      }

      final credential =
          await _authInstance.signInWithCredential(oAuthCredential);

      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception("Occured an error: ${e.toString()}");
    }
  }

  @override
  Future<User?> signInWithEmail(String email, String password) async {
    User? user;
    try {
      var credential = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Occured an error when sign in by Email!");
    }
  }

  @override
  Future<User?> signUpWithEmail(String email, String password) async {
    User? user;
    try {
      var credential = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Occured an error when sign in by Email!");
    }
  }

  Future<OAuthCredential> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    var googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return googleAuthCredential;
  }

  Future<OAuthCredential> _signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['public_profile'],
    );

    switch (loginResult.status) {
      case LoginStatus.success:
        log("Login with facebook successfully:");
        log("Token: ${loginResult.accessToken!.token}");
        break;
      case LoginStatus.cancelled:
        log("Login with facebook was cancelled");
        break;
      case LoginStatus.failed:
        log("Login with facebook was failed");
        break;
      default:
    }

    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return facebookAuthCredential;
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      bool isSent = false;
      await _authInstance
          .sendPasswordResetEmail(email: email.trim())
          .whenComplete(() => isSent = true);
      return isSent;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> signInAsGuess() async {
    User? user;
    try {
      var credential = await _authInstance.signInAnonymously();
      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Occured an error when sign in by Email!");
    }
  }
}
