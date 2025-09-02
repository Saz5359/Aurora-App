import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/logger.dart';

abstract class OnboardingRemoteDataSource {
  Future<bool> isFirstTimeUser();
  Future<bool> isUserAuthenticated();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final SharedPreferences _prefs;
  final FirebaseAuth _firebaseAuth;

  static const String _kFirstTimeKey = 'isFirstTime';

  OnboardingRemoteDataSourceImpl({
    required SharedPreferences prefs,
    required FirebaseAuth firebaseAuth,
  })  : _prefs = prefs,
        _firebaseAuth = firebaseAuth;

  @override
  Future<bool> isFirstTimeUser() async {
    try {
      final bool isFirstTime = _prefs.getBool(_kFirstTimeKey) ?? true;
      if (isFirstTime) {
        await _prefs.setBool(_kFirstTimeKey, false);
        AppLogger.info('OnboardingRemoteDataSource: Detected first‐time user.');
      } else {
        AppLogger.info('OnboardingRemoteDataSource: Returning user.');
      }
      return isFirstTime;
    } on Exception catch (e) {
      AppLogger.error('SharedPreferences error in isFirstTimeUser: $e');
      return false;
    }
  }

  @override
  Future<bool> isUserAuthenticated() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final User? user = _firebaseAuth.currentUser;
      final bool isAuthenticated = user != null;

      AppLogger.info(isAuthenticated
          ? 'OnboardingRemoteDataSource: User is authenticated (UID=${user.uid}).'
          : 'OnboardingRemoteDataSource: No user signed in.');

      return isAuthenticated;
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          'FirebaseAuthException in isUserAuthenticated: ${e.message}');
      return false;
    } catch (e) {
      AppLogger.error('Unknown error in isUserAuthenticated: $e');
      return false;
    }
  }
}
