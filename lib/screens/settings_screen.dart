import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resq_link/screens/terms_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool)? setTheme;

  const SettingsScreen({super.key, required this.setTheme});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 🔔 Notifications Toggle
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),

          // 📍 Location Services Toggle (with permission handling)
          SwitchListTile(
            title: const Text('Enable Location Services'),
            value: locationEnabled,
            onChanged: (value) {
              _handleLocationPermission(value);
            },
          ),

          // 🌐 Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showLanguageSelection();
            },
          ),

          // 💾 Backup & Restore
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Restore Data'),
            onTap: () {
              // Add backup functionality here
            },
          ),

          // ℹ️ About App
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            onTap: () {
              _showAboutDialog();
            },
          ),

          // 📜 Terms & Conditions
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // 📍 Handle Location Permission
  Future<void> _handleLocationPermission(bool enable) async {
    if (enable) {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        if (mounted) {
          setState(() {
            locationEnabled = true;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied.")),
          );
        }
      }
    } else {
      if (mounted) {
        setState(() {
          locationEnabled = false;
        });
      }
    }
  }

  // 🌐 Show Language Selection Dialog
  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption('English'),
              _languageOption('Tamil'),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  // ℹ️ Show About App Dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About RESQ_LINK'),
          content: const Text(
            'RESQ_LINK is a disaster management response app designed to help users during emergencies '
            'by providing easy access to alerts, emergency contacts, and location services.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
