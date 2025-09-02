import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterWithGoogleUseCase {
  final RegisterRepository repository;

  RegisterWithGoogleUseCase(this.repository);

  Future<void> call(OAuthCredential credential) {
    return repository.signInWithGoogleCredentials(credential);
  }
}
