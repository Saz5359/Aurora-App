import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetGoogleRegisterCredentialsUseCase {
  final RegisterRepository repository;

  GetGoogleRegisterCredentialsUseCase(this.repository);

  Future<OAuthCredential?> call() {
    return repository.getGoogleSignInCredentials();
  }
}
