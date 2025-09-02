abstract class OnboardingRepository {
  Future<bool> isFirstTimeUser();
  Future<bool> isUserAuthenticated();
}
