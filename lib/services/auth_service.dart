import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resq_link/models/user_profile.dart'; // ✅ Import UserProfile
import 'package:resq_link/services/firestore_service.dart'; // ✅ Import FirestoreService

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Sign Up Method
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save profile to Firestore after sign-up
        await _firestoreService.saveUserProfile(
          user.uid,
          UserProfile(
            name: user.displayName ?? 'User',
            email: user.email ?? '',
            profilePictureUrl: '', // ✅ Required parameter added
          ),
        );
      }

      return user;
    } catch (e) {
      debugPrint("Error during Sign Up: $e"); // ✅ Debug-friendly logging
      return null;
    }
  }

  // Sign In Method
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint("Error during Sign In: $e");
      return null;
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }
}
