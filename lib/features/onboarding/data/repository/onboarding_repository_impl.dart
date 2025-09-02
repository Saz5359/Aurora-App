import 'package:aurora_v1/features/onboarding/domain/repository/onboarding_repository.dart';

import '../datasources/onboarding_remote_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource _remoteDataSource;

  OnboardingRepositoryImpl(this._remoteDataSource);

  @override
  Future<bool> isFirstTimeUser() {
    return _remoteDataSource.isFirstTimeUser();
  }

  @override
  Future<bool> isUserAuthenticated() {
    return _remoteDataSource.isUserAuthenticated();
  }
}
