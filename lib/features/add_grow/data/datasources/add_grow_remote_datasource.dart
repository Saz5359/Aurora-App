import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/grow.dart';

abstract class AddGrowRemoteDataSource {
  Future<void> addGrow(Grow grow, String userId);
}

class AddGrowRemoteDataSourceImpl implements AddGrowRemoteDataSource {
  final FirebaseFirestore firestore;

  AddGrowRemoteDataSourceImpl({required this.firestore});

  @override
  // Adds a new grow to the Firestore database
  Future<void> addGrow(Grow grow, String userId) async {
    final docRef =
        firestore.collection('plants').doc(userId).collection('userPlants');
    await docRef.add((grow as dynamic).toMap());
  }
}
