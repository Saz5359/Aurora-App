import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';

class RequestOtpUseCase {
  final RegisterRepository repository;

  RequestOtpUseCase(this.repository);

  Future<bool> call(String phoneNumber) {
    return repository.requestOTP(phoneNumber);
  }
  /* Future<bool> call(String phoneNumber, String generatedOTP) {
    return repository.requestOTP(phoneNumber, generatedOTP);
  } */
}
