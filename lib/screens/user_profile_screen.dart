import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resq_link/services/firestore_service.dart';
import 'package:resq_link/models/user_profile.dart'; // Import the UserProfile model

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<UserProfile?> _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile from Firestore
  void _loadUserProfile() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userProfile = _firestoreService.getUserProfile(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<UserProfile?>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No Profile Found'));
          }

          UserProfile userProfile = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${userProfile.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Email: ${userProfile.email}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for updating profile if needed
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
