import 'package:aurora_v1/features/login/domain/repository/login_repository.dart';

import '../entities/login_user.dart';

class SignInWithGoogleUseCase {
  final LoginRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<LoginUser?> call() => repository.signInWithGoogle();
}
