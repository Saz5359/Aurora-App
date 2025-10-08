import 'package:aurora_v1/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginModel?> signInWithEmail(String phoneNumber, String password);
  Future<LoginModel?> signInWithGoogle();
  Future<LoginModel?> signInWithFacebook();
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;

  LoginRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.facebookAuth,
  });

  @override
  Future<LoginModel?> signInWithEmail(
      String phoneNumber, String password) async {
    try {
      final email =
          '+${phoneNumber.replaceAll(RegExp(r'[^\w]'), '')}@aurora.app.com';
      AppLogger.info('Signing in with: $email');
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return LoginModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Auth failed: ${e.message} / ${e.code}');
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Authentication failed',
      );
    }
  }

  @override
  Future<LoginModel?> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = (await firebaseAuth.signInWithCredential(credential)).user;
      return user != null ? LoginModel.fromFirebaseUser(user) : null;
    } catch (e) {
      AppLogger.error('Google Sign-In error: $e');
      throw Exception("Google sign-in failed");
    }
  }

  @override
  Future<LoginModel?> signInWithFacebook() async {
    try {
      final loginResult = await facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
            loginResult.accessToken!.tokenString);
        final user = (await firebaseAuth.signInWithCredential(credential)).user;
        return user != null ? LoginModel.fromFirebaseUser(user) : null;
      }
      return null;
    } catch (e) {
      AppLogger.error('Facebook Sign-In error: $e');
      throw Exception("Facebook sign-in failed");
    }
  }
}
