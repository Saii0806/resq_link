import 'package:flutter/material.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  AddReportScreenState createState() => AddReportScreenState();
}

class AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String location = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Location", style: TextStyle(fontSize: 18)),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text("Description", style: TextStyle(fontSize: 18)),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Here we can add the report (later implement backend logic)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report Added')),
                    );
                  }
                },
                child: const Text('Add Report'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);  // Return to the previous screen
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
