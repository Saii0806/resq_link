import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:resq_link/screens/home_screen.dart';
import 'package:resq_link/screens/profile_screen.dart';
import 'package:resq_link/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESQ_LINK',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: AuthWrapper(setTheme: _toggleTheme),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final Function(bool) setTheme;

  const AuthWrapper({super.key, required this.setTheme});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return SignInScreen(setTheme: setTheme);
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            return HomeScreen(setTheme: setTheme);
          } else {
            return ProfileScreen(setTheme: setTheme);
          }
        },
      );
    }
  }
}
