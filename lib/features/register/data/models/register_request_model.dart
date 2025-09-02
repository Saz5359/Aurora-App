import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/register_request_entity.dart';

class RegisterRequestModel extends RegisterRequestEntity {
  const RegisterRequestModel({
    required super.phoneNumber,
    required super.otp,
    required super.password,
    required super.fullName,
    required super.email,
    required super.acceptedTerms,
  });

  factory RegisterRequestModel.fromEntity(RegisterRequestEntity entity) {
    return RegisterRequestModel(
      phoneNumber: entity.phoneNumber,
      otp: entity.otp,
      password: entity.password,
      fullName: entity.fullName,
      email: entity.email,
      acceptedTerms: entity.acceptedTerms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'email': email,
      'acceptedTerms': acceptedTerms,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
