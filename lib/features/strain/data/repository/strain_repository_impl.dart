import 'package:aurora_v1/features/strain/data/datasources/strain_remote_datasource.dart';
import 'package:aurora_v1/features/strain/domain/repository/strain_repository.dart';

class StrainRepositoryImpl implements StrainRepository {
  final StrainRemoteDataSource remoteDataSource;

  StrainRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> deletePlant(String plantId) {
    return remoteDataSource.deletePlant(plantId);
  }
}
