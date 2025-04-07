import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resq_link/screens/home_screen.dart'; // Make sure HomeScreen is imported from the right path

class ProfileScreen extends StatefulWidget {
  final Function(bool)? setTheme;
  const ProfileScreen({super.key, this.setTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  String selectedState = '';
  String selectedDistrict = '';

  final Map<String, List<String>> stateDistrictMap = {
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode'],
    'Karnataka': ['Bangalore', 'Mysore', 'Mangalore'],
  };

  // Save profile data to Firestore
  Future<void> saveProfileData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'state': selectedState,
        'district': selectedDistrict,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate to HomeScreen after saving
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(setTheme: widget.setTheme!),
          ),
        );
      }
    } catch (e) {
      // Show error message if profile saving fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Input Field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),

            // State Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select State'),
              value: selectedState.isNotEmpty ? selectedState : null,
              items: stateDistrictMap.keys
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                  selectedDistrict = ''; // Reset district when state changes
                });
              },
            ),
            const SizedBox(height: 16),

            // District Dropdown (only visible when a state is selected)
            if (selectedState.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select District'),
                value: selectedDistrict.isNotEmpty ? selectedDistrict : null,
                items: stateDistrictMap[selectedState]!
                    .map((district) => DropdownMenuItem(
                          value: district,
                          child: Text(district),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value!;
                  });
                },
              ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    selectedState.isNotEmpty &&
                    selectedDistrict.isNotEmpty) {
                  saveProfileData(); // Call the save function
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete all fields')),
                  );
                }
              },
              child: const Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
