import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterWithFacebookUseCase {
  final RegisterRepository repository;

  RegisterWithFacebookUseCase(this.repository);

  Future<void> call(OAuthCredential credential) {
    return repository.signInWithFacebookCredentials(credential);
  }
}
