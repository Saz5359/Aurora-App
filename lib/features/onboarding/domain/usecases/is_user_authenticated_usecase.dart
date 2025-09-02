import 'package:aurora_v1/features/onboarding/domain/repository/onboarding_repository.dart';

class IsUserAuthenticatedUseCase {
  final OnboardingRepository _repository;

  IsUserAuthenticatedUseCase(this._repository);
  Future<bool> call() async {
    return await _repository.isUserAuthenticated();
  }
}
