import 'package:flutter/material.dart';

class DeleteReportScreen extends StatelessWidget {
  const DeleteReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> reports = ['Report 1', 'Report 2', 'Report 3']; // Example list

    return Scaffold(
      appBar: AppBar(title: const Text('Delete Report')),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reports[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Here we can delete the report (later implement backend logic)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${reports[index]} deleted')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
