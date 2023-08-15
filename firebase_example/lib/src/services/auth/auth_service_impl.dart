import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class AuthServiceImpl extends AuthService {
  final _authInstance = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive',
    ],
  );
  @override
  Future<User?> signInWithGoogle() async {
    User? user;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      var googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var credential =
          await _authInstance.signInWithCredential(googleAuthCredential);

      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Occured an error: ${e.toString()}");
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    User? user;
    try {
      // Trigger the sing-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // TODO: Handle Error: ERROR_INVALID_CREDENTIAL
      final credential =
          await _authInstance.signInWithCredential(facebookAuthCredential);

      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
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
}
