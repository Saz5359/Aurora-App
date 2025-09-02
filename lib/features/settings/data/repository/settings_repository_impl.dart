import 'package:aurora_v1/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final FirebaseAuth _firebaseAuth;

  SettingsRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      AppLogger.info('User signed out successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          'FirebaseAuthException during sign out: ${e.code} - ${e.message}');
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Authentication error during sign out',
      );
    } catch (e, st) {
      AppLogger.error('Unexpected error during sign out',
          error: e, stackTrace: st);
      throw Exception(
        'Failed to sign out: ${e.toString()}',
      );
    }
  }
}
