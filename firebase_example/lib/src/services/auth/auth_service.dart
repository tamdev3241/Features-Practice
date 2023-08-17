import 'package:firebase_auth/firebase_auth.dart';

import '../../constant/sign_in_social_type_enum.dart';

abstract class AuthService {
  Future<User?> signUpWithEmail(String email, String password);
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signInWithSocial(SignInSocialType typeProvider);
  Future<bool> resetPassword(String email);
}
