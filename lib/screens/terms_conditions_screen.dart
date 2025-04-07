import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          "Here are the terms and conditions...\n\n"
          "1. You must agree to our terms to use this app.\n"
          "2. We do not collect any personal data.\n"
          "3. The app is designed for emergency response.\n"
          "4. Do not misuse the emergency reporting features.\n"
          "5. By using this app, you agree to abide by these terms.\n",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
