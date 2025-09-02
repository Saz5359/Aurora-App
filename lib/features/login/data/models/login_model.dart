import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  final String uid;
  final String email;

  LoginModel({required this.uid, required this.email});

  factory LoginModel.fromFirebaseUser(User user) {
    return LoginModel(
      uid: user.uid,
      email: user.email ?? 'No Email Provided',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? 'No Email Provided',
    );
  }
}
