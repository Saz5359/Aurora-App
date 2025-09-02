import 'package:aurora_v1/features/onboarding/domain/repository/onboarding_repository.dart';

class IsFirstTimeUseCase {
  final OnboardingRepository _repository;

  IsFirstTimeUseCase(this._repository);

  Future<bool> call() async {
    return await _repository.isFirstTimeUser();
  }
}
