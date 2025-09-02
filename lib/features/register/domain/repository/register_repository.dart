import '../entities/register_request_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterRepository {
  Future<bool> requestOTP(String phoneNumber);
  Future<bool> verifyOTP(String phoneNumber, String userOTP);
  Future<void> registerUser(RegisterRequestEntity request);
  Future<OAuthCredential?> getGoogleSignInCredentials();
  Future<void> signInWithGoogleCredentials(OAuthCredential credential);
  Future<OAuthCredential?> getFacebookSignInCredentials();
  Future<void> signInWithFacebookCredentials(OAuthCredential credential);
}
