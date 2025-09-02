import 'package:aurora_v1/features/login/domain/repository/login_repository.dart';

import '../entities/login_user.dart';

class SignInWithFacebookUseCase {
  final LoginRepository repository;

  SignInWithFacebookUseCase(this.repository);

  Future<LoginUser?> call() => repository.signInWithFacebook();
}
