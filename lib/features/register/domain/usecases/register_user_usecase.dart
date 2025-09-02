import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';

import '../entities/register_request_entity.dart';

class RegisterUserUseCase {
  final RegisterRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> call(RegisterRequestEntity request) {
    return repository.registerUser(request);
  }
}
