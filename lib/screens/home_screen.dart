import 'package:flutter/material.dart';
import 'package:resq_link/screens/settings_screen.dart';
import 'package:resq_link/screens/profile_screen.dart';
import 'package:resq_link/screens/emergency_contacts_screen.dart';
import 'package:resq_link/screens/alerts_screen.dart';
import 'package:resq_link/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool) setTheme;

  const HomeScreen({super.key, required this.setTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RESQ_LINK'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(setTheme: setTheme)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Welcome to RESQ_LINK",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              buildNavigationButton(
                context,
                "Settings",
                Icons.settings,
                Colors.orange,
                () => SettingsScreen(setTheme: setTheme),
              ),
              buildNavigationButton(
                context,
                "Emergency Contacts (District-wise)",
                Icons.contacts,
                Colors.red,
                () => const EmergencyContactsScreen(),
              ),
              buildNavigationButton(
                context,
                "Alerts",
                Icons.notification_important,
                Colors.purple,
                () => const AlertsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget Function() screen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen()),
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(title,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
