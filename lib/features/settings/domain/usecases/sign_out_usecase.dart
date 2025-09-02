import '../../domain/repository/settings_repository.dart';

class SignOutUseCase {
  final SettingsRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}
