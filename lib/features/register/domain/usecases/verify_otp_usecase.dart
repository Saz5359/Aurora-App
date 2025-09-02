import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';

class VerifyOtpUseCase {
  final RegisterRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<bool> call(String phoneNumber, String userOTP) {
    return repository.verifyOTP(phoneNumber, userOTP);
  }
}
