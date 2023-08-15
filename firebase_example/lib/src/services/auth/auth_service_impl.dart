import 'package:firebase_auth/firebase_auth.dart';
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

      var oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var credential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

      if (credential.user != null) {
        user = credential.user!;
      } else {
        throw Exception("Occured an error: User has not present !");
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      // throw Exception("Occured an error when sign in by Google !");
      throw (e);
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
