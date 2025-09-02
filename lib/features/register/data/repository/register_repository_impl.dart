import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/register/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/register_request_entity.dart';
import '../datasources/register_remote_datasource.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> requestOTP(String phoneNumber) {
    return remoteDataSource.requestOtp(phoneNumber);
  }

  @override
  Future<bool> verifyOTP(String phoneNumber, String userOTP) {
    return remoteDataSource.verifyOtp(phoneNumber, userOTP);
  }

  @override
  Future<void> registerUser(RegisterRequestEntity request) async {
    /* final model = RegisterRequestModel.fromEntity(request);

    UserCredential userCredential; */
    try {
      await remoteDataSource.registerUserWithEmail(
        request.phoneNumber,
        request.password,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in registerUser: ${e.code} - ${e.message}");
      rethrow;
    }
    // Saving user profile is not implemented yet
    /* await remoteDataSource.saveUserProfile(
      userCredential.user!.uid,
      model.toMap(),
    ); */
  }

  @override
  Future<OAuthCredential?> getGoogleSignInCredentials() {
    return remoteDataSource.getGoogleSignInCredentials();
  }

  @override
  Future<void> signInWithGoogleCredentials(OAuthCredential credential) async {
    try {
      final userCredential =
          await remoteDataSource.signInWithGoogleCredentials(credential);
      AppLogger.info(
          "Google register/sign-in succeeded: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in signInWithGoogleCredentials: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  @override
  Future<OAuthCredential?> getFacebookSignInCredentials() {
    return remoteDataSource.getFacebookSignInCredentials();
  }

  @override
  Future<void> signInWithFacebookCredentials(OAuthCredential credential) async {
    try {
      final userCredential =
          await remoteDataSource.signInWithFacebookCredentials(credential);
      AppLogger.info(
          "Facebook register/sign-in succeeded: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
          "FirebaseAuthException in signInWithFacebookCredentials: ${e.code} - ${e.message}");
      rethrow;
    }
  }
}
