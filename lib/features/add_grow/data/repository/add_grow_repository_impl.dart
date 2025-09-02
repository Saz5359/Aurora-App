import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/add_grow/domain/repository/add_grow_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/grow.dart';
import '../datasources/add_grow_remote_datasource.dart';

class AddGrowRepositoryImpl implements AddGrowRepository {
  final FirebaseAuth auth;
  final AddGrowRemoteDataSource remoteDataSource;

  AddGrowRepositoryImpl({
    required this.auth,
    required this.remoteDataSource,
  });

  // Gets the current user's ID from Firebase Auth.
  String get _userId {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      AppLogger.error('User not authenticated');
      throw Exception('User not authenticated');
    }
    return uid;
  }

  @override
  Future<void> addGrow(Grow grow) async {
    if (grow.plantName.isEmpty) {
      AppLogger.warning('Plant name is required');
      throw Exception('Plant name is required');
    }

    try {
      await remoteDataSource.addGrow(grow, _userId);
      AppLogger.info('Grow added: ${grow.plantName}');
    } catch (e, st) {
      AppLogger.error('Failed to add grow', error: e, stackTrace: st);
      rethrow;
    }
  }
}
