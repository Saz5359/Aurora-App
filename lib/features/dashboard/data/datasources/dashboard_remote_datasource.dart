import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/dashboard/data/model/plant_model.dart';
import 'package:aurora_v1/features/dashboard/data/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/task.dart';

/// Thrown when Remote DataSource encounters an error.
class DashboardRemoteDataSourceException implements Exception {
  final String message;
  DashboardRemoteDataSourceException(this.message);
}

class DashboardRemoteDataSource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DashboardRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Get the current user's ID
  String get userId {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      AppLogger.warning("DashboardRemoteDataSource: User not authenticated");
      throw DashboardRemoteDataSourceException("User not authenticated");
    }
    return uid;
  }

  Stream<List<Plant>> getPlants() {
    try {
      return _db
          .collection('plants')
          .doc(userId)
          .collection('userPlants')
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return PlantModel.fromFirestore(doc);
        }).toList();
      }).handleError((error) {
        AppLogger.error("getPlants stream error: $error");
        throw DashboardRemoteDataSourceException(
            "Failed to stream plants: $error");
      });
    } catch (e) {
      AppLogger.error("Error initializing getPlants: $e");
      throw DashboardRemoteDataSourceException("Initialization error: $e");
    }
  }

  Stream<Plant> getPlantById(String plantId) {
    try {
      return _db
          .collection('plants')
          .doc(userId)
          .collection('userPlants')
          .doc(plantId)
          .snapshots()
          .map((docSnap) {
        if (!docSnap.exists) {
          throw DashboardRemoteDataSourceException("Plant not found");
        }
        return PlantModel.fromFirestore(docSnap);
      }).handleError((error) {
        AppLogger.error("getPlantById stream error: $error");
        throw DashboardRemoteDataSourceException(
            "Failed to stream plant: $error");
      });
    } catch (e) {
      AppLogger.error("Error initializing getPlantById: $e");
      throw DashboardRemoteDataSourceException("Initialization error: $e");
    }
  }

  Future<void> addTask({
    required String plantId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String estimatedCompletion,
    required String taskType,
  }) async {
    try {
      await _db
          .collection('tasks')
          .doc(userId)
          .collection(plantId)
          .add(TaskModel(
            id: '',
            title: title,
            description: description,
            dueDate: dueDate,
            estimatedCompletion: estimatedCompletion,
            completed: false,
            assignedBy: 'admin',
            createdAt: DateTime.now(),
            taskType: taskType,
          ).toFirestore());
      AppLogger.info("Task added for plantId=$plantId");
    } catch (e, st) {
      AppLogger.error("Error in addTask: $e", error: e, stackTrace: st);
      throw DashboardRemoteDataSourceException("Failed to add task: $e");
    }
  }

  Stream<List<Task>> getTasks(String plantId) {
    try {
      return _db
          .collection('tasks')
          .doc(userId)
          .collection(plantId)
          .orderBy('dueDate', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TaskModel.fromFirestore(doc);
        }).toList();
      }).handleError((error) {
        AppLogger.error("getTasks stream error: $error");
        throw DashboardRemoteDataSourceException(
            "Failed to stream tasks: $error");
      });
    } catch (e) {
      AppLogger.error("Error initializing getTasks: $e");
      throw DashboardRemoteDataSourceException("Initialization error: $e");
    }
  }

  Future<void> markTaskAsCompleted({
    required String plantId,
    required String taskId,
  }) async {
    try {
      final taskRef =
          _db.collection('tasks').doc(userId).collection(plantId).doc(taskId);

      await taskRef.update({'completed': true});
      AppLogger.info("Task marked as completed: $taskId for plant $plantId");
    } catch (e, st) {
      AppLogger.error("Error in markTaskAsCompleted: $e",
          error: e, stackTrace: st);
      throw DashboardRemoteDataSourceException(
          "Failed to mark task as completed: $e");
    }
  }

  Future<int> getPlantCount() async {
    try {
      final snap = await _db
          .collection('plants')
          .doc(userId)
          .collection('userPlants')
          .get();
      final count = snap.docs.length;
      AppLogger.info("Fetched plant count: $count");
      return count;
    } catch (e, st) {
      AppLogger.error("Error in getPlantCount: $e", error: e, stackTrace: st);
      throw DashboardRemoteDataSourceException(
          "Failed to fetch plant count: $e");
    }
  }

  Future<List<Task>> getTasksOnce(String plantId) async {
    try {
      final snapshot =
          await _db.collection('tasks').doc(userId).collection(plantId).get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromFirestore(doc);
      }).toList();
    } catch (e, st) {
      AppLogger.error("Error in getTasksOnce: $e", error: e, stackTrace: st);
      throw DashboardRemoteDataSourceException("Failed to fetch tasks: $e");
    }
  }
}
