class RegisterRequestEntity {
  final String phoneNumber;
  final String otp;
  final String password;
  final String fullName;
  final String email;
  final bool acceptedTerms;

  const RegisterRequestEntity({
    required this.phoneNumber,
    required this.otp,
    required this.password,
    required this.fullName,
    required this.email,
    required this.acceptedTerms,
  });
}
