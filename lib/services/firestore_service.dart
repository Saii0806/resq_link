// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resq_link/models/user_profile.dart'; // Ensure this exists
import 'package:resq_link/utils/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserProfile(String userId, UserProfile profile) async {
    try {
      await _db.collection('users').doc(userId).set(profile.toMap());
    } catch (e) {
    logger.e("Error saving profile: $e");
    }
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
    logger.e("Error retrieving profile: $e");
    }
    return null;
  }
}
