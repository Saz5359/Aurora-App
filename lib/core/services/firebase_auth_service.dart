import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthService {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithFacebook();

  // Register methods
  Future<UserCredential> registerWithEmail(String email, String password);

  // OTP - simulated (these can be replaced with real SMS API later)
  Future<bool> sendOtp(String phoneNumber, String otp);
  bool verifyOtp(String userOtp, String actualOtp);
  Future<UserCredential> signInWithGoogleCredentials(
      OAuthCredential credential);
  Future<UserCredential> signInWithFacebookCredentials(
      OAuthCredential credential);
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthServiceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'cancelled',
        message: 'User cancelled Google Sign-In',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithGoogleCredentials(
      OAuthCredential credential) async {
    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(
        code: 'facebook-failure',
        message: result.message ?? 'Unknown Facebook login error',
      );
    }

    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);
    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithFacebookCredentials(
      OAuthCredential credential) async {
    return _firebaseAuth.signInWithCredential(credential);
  }

  //  Register with Email
  @override
  Future<UserCredential> registerWithEmail(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  //  Simulated OTP (to be replaced with real SMS backend)
  @override
  Future<bool> sendOtp(String phoneNumber, String otp) async {
    // You can simulate sending OTP here. In real use, integrate Twilio or Firebase phone auth.
    print('Sending OTP $otp to $phoneNumber');
    await Future.delayed(Duration(seconds: 1)); // simulate delay
    return true;
  }

  @override
  bool verifyOtp(String userOtp, String actualOtp) {
    return userOtp == actualOtp;
  }
}
