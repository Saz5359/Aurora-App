import 'package:aurora_v1/features/login/domain/entities/login_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginModel extends LoginUser {
  LoginModel({required super.uid, required super.email});

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
