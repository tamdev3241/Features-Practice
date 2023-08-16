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
    // Trigger the sing-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return facebookAuthCredential;
  }

  @override
  Future<User?> signInWithPhoneNumber() async {
    User? user;
    try {
      await _authInstance.verifyPhoneNumber(
        phoneNumber: '',
        verificationCompleted: (phoneAuthCredential) async {
          //  This handler will only be called on Android devices
          //  which support automatic SMS code resolution.
          var credential =
              await _authInstance.signInWithCredential(phoneAuthCredential);

          if (credential.user != null) {
            user = credential.user!;
          } else {
            throw Exception("Occured an error: User has not present !");
          }
        },
        verificationFailed: (FirebaseException e) {
          throw Exception(e.message);
        },
        codeSent: (verificationId, forceResendingToken) {},
        codeAutoRetrievalTimeout: (verificationId) {},
      );

      return user;
    } catch (e) {
      throw Exception("Occured an error: ${e.toString()}");
    }
  }
}
