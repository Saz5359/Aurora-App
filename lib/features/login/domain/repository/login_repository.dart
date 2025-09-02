import '../entities/login_user.dart';

abstract class LoginRepository {
  Future<LoginUser?> signInWithEmailAndPassword(
      String phoneNumber, String password);
  Future<LoginUser?> signInWithGoogle();
  Future<LoginUser?> signInWithFacebook();
}
