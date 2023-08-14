import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class AuthServiceImpl extends AuthService {
  final _authInstance = FirebaseAuth.instance;

  @override
  Future<User> signInWithGoogle() {
    throw UnimplementedError();
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
}
