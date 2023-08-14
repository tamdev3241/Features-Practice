import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<User?> signUpWithEmail(String email, String password);
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
}
