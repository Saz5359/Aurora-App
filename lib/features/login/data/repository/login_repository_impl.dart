import 'package:aurora_v1/features/login/domain/repository/login_repository.dart';

import '../../domain/entities/login_user.dart';
import '../datasources/login_remote_datasource.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginUser?> signInWithEmailAndPassword(
      String phoneNumber, String password) async {
    final model = await remoteDataSource.signInWithEmail(phoneNumber, password);
    return model != null ? LoginUser(uid: model.uid, email: model.email) : null;
  }

  @override
  Future<LoginUser?> signInWithGoogle() async {
    final model = await remoteDataSource.signInWithGoogle();
    return model != null ? LoginUser(uid: model.uid, email: model.email) : null;
  }

  @override
  Future<LoginUser?> signInWithFacebook() async {
    final model = await remoteDataSource.signInWithFacebook();
    return model != null ? LoginUser(uid: model.uid, email: model.email) : null;
  }
}
