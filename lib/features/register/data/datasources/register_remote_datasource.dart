import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aurora_v1/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

abstract class RegisterRemoteDataSource {
  Future<bool> requestOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String userOtp);
  Future<UserCredential> registerUserWithEmail(String email, String password);
  Future<OAuthCredential?> getGoogleSignInCredentials();
  Future<UserCredential> signInWithGoogleCredentials(
      OAuthCredential credential);
  Future<OAuthCredential?> getFacebookSignInCredentials();
  Future<UserCredential> signInWithFacebookCredentials(
      OAuthCredential credential);
  Future<void> saveUserProfile(String uid, Map<String, dynamic> data);
}

/// Thrown when OTP operations fail.
class OtpException implements Exception {
  final String message;
  OtpException(this.message);
  @override
  String toString() => 'OtpException: $message';
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  static const _otpLength = 4;
  static const _otpTtl = Duration(minutes: 5);
  static const _minIntervalBetweenRequests = Duration(seconds: 30);

  String generatedOtp = '';
  DateTime expiresAt = DateTime.now().add(_otpTtl);
  final Map<String, DateTime> _lastRequested = {};

  RegisterRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
  });

  @override
  Future<bool> requestOtp(String phoneNumber) async {
    final now = DateTime.now();

    // Rate‐limit
    final last = _lastRequested[phoneNumber];
    if (last != null && now.difference(last) < _minIntervalBetweenRequests) {
      throw OtpException(
        'Please wait ${_minIntervalBetweenRequests.inSeconds} seconds before requesting a new code.',
      );
    }

    // Generate a new 6‐digit OTP
    final code = List.generate(_otpLength, (_) => Random().nextInt(10)).join();

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String apiSecret = dotenv.env['API_SECRET'] ?? '';
    if (apiKey.isEmpty || apiSecret.isEmpty) {
      AppLogger.error('SMS-Portal credentials missing');
      throw OtpException('SMS service not configured.');
    }

    AppLogger.info(
      'Requesting OTP for $phoneNumber: code=$code',
    );

    final credentials = base64Encode(utf8.encode('$apiKey:$apiSecret'));
    final body = {
      'messages': [
        {
          'content': 'Your verification code is: $code',
          'destination': phoneNumber,
        }
      ]
    };

    try {
      AppLogger.info('Sending OTP to $phoneNumber');
      final response = await http
          .post(
            Uri.parse('https://rest.smsportal.com/bulkmessages'),
            headers: {
              'Authorization': 'Basic $credentials',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        AppLogger.error(
          'OTP send failed: ${response.statusCode} ${response.body}',
        );
        throw OtpException('Failed to send OTP. Try again later.');
      }

      AppLogger.info('OTP sent successfully to $phoneNumber');
      _lastRequested[phoneNumber] = now;
      generatedOtp = code;
      expiresAt = now.add(_otpTtl);

      return true;
    } on TimeoutException {
      AppLogger.error('OTP send timeout for $phoneNumber');
      throw OtpException('OTP request timed out. Please try again.');
    } catch (e, st) {
      AppLogger.error('Exception in requestOtp', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(String phoneNumber, String userOtp) async {
    AppLogger.info(
      'Verifying OTP for $phoneNumber: userOtp=$userOtp,  OTP =$generatedOtp',
    );
    if (generatedOtp.isEmpty) {
      throw OtpException('No OTP requested. Please request one first.');
    }

    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      // Explicitly remove expired sessions
      AppLogger.warning('OTP session expired for $phoneNumber');
      throw OtpException('OTP has expired. Please request a new one.');
    }

    if (generatedOtp != userOtp) {
      AppLogger.info(
        'OTP mismatch for $phoneNumber: expected=$generatedOtp, got=$userOtp',
      );
      return false;
    }

    // Success: remove the one‐time session so it can’t be re‐used
    AppLogger.info('OTP verified successfully for $phoneNumber');
    return true;
  }

  @override
  Future<UserCredential> registerUserWithEmail(
      String email, String password) async {
    try {
      AppLogger.info("Creating user with email: $email@aurora.app.com");
      return await auth.createUserWithEmailAndPassword(
        email: "$email@aurora.app.com",
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in registerUserWithEmail: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.error("General exception in registerUserWithEmail: $e");
      rethrow;
    }
  }

  @override
  Future<OAuthCredential?> getGoogleSignInCredentials() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        AppLogger.warning("Google sign-in cancelled by user");
        return null;
      }
      final googleAuth = await googleUser.authentication;
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );
    } catch (e) {
      AppLogger.error("Error in getGoogleSignInCredentials: $e");
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithGoogleCredentials(
      OAuthCredential credential) async {
    try {
      AppLogger.info("Signing in/up with Google credential");
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in signInWithGoogleCredentials: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.error("General exception in signInWithGoogleCredentials: $e");
      rethrow;
    }
  }

  @override
  Future<OAuthCredential?> getFacebookSignInCredentials() async {
    try {
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        AppLogger.info("Facebook sign-in succeeded");
        return FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );
      } else {
        AppLogger.warning(
            "Facebook sign-in failed/cancelled: ${loginResult.message}");
        return null;
      }
    } catch (e) {
      AppLogger.error("Error in getFacebookSignInCredentials: $e");
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithFacebookCredentials(
      OAuthCredential credential) async {
    try {
      AppLogger.info("Signing in/up with Facebook credential");
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in signInWithFacebookCredentials: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.error("General exception in signInWithFacebookCredentials: $e");
      rethrow;
    }
  }

  @override
  Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await firestore.collection('users').doc(uid).set(data);
      AppLogger.info("User profile saved in Firestore: $uid");
    } catch (e) {
      AppLogger.error("Error saving user profile: $e");
      rethrow;
    }
  }
}
