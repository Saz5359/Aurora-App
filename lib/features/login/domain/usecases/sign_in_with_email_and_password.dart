import 'package:aurora_v1/features/login/domain/repository/login_repository.dart';

import '../entities/login_user.dart';

class SignInWithEmailUseCase {
  final LoginRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<LoginUser?> call(String phoneNumber, String password) {
    return repository.signInWithEmailAndPassword(phoneNumber, password);
  }
}
