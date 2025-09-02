import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetFacebookRegisterCredentialsUseCase {
  final RegisterRepository repository;

  GetFacebookRegisterCredentialsUseCase(this.repository);

  Future<OAuthCredential?> call() {
    return repository.getFacebookSignInCredentials();
  }
}
