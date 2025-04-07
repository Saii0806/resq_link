import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:resq_link/models/emergency_contact.dart';
import 'package:resq_link/database/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  EmergencyContactsScreenState createState() => EmergencyContactsScreenState();
}

class EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  late Future<Map<String, List<EmergencyContact>>> districtWiseContacts;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final contactsInDb = await DatabaseHelper.instance.getAllContacts();
    if (contactsInDb.isEmpty) {
      await _loadContactsFromJson();
    }

    if (mounted) {
      setState(() {
        districtWiseContacts = getDistrictWiseContacts();
      });
    }
  }

  Future<void> _loadContactsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/emergency_contacts_tn.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    for (var item in jsonData) {
      EmergencyContact contact = EmergencyContact.fromJson(item);
      await DatabaseHelper.instance.insertContact(contact);
    }
  }

  Future<Map<String, List<EmergencyContact>>> getDistrictWiseContacts() async {
    List<EmergencyContact> contacts = await DatabaseHelper.instance.getAllContacts();
    Map<String, List<EmergencyContact>> categorizedContacts = {};

    for (var contact in contacts) {
      String district = contact.district;
      categorizedContacts.putIfAbsent(district, () => []).add(contact);
    }
    return categorizedContacts;
  }

  void _refreshContacts() {
    setState(() {
      districtWiseContacts = getDistrictWiseContacts();
    });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch dialer for $phoneNumber")),
      );
    }
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final districtController = TextEditingController();

    showDialog(
      context: context, // Use dialog's local context
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: districtController, decoration: const InputDecoration(labelText: 'District')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final district = districtController.text.trim();
              if (name.isNotEmpty && phone.isNotEmpty && district.isNotEmpty) {
                final newContact = EmergencyContact(name: name, phone: phone, district: district);
                await DatabaseHelper.instance.insertContact(newContact);
                if (mounted) {
                  _refreshContacts();
                  Navigator.of(dialogContext).pop();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddContactDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await DatabaseHelper.instance.clearContacts();
              await _loadContactsFromJson();
              if (mounted) _refreshContacts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name, phone, or district',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, List<EmergencyContact>>>( // Use FutureBuilder here
              future: districtWiseContacts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No emergency contacts available.'));
                }

                final filteredData = <String, List<EmergencyContact>>{};
                snapshot.data!.forEach((district, contacts) {
                  final filtered = contacts.where((c) {
                    return c.name.toLowerCase().contains(_searchQuery) ||
                        c.phone.toLowerCase().contains(_searchQuery) ||
                        district.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (filtered.isNotEmpty) {
                    filteredData[district] = filtered;
                  }
                });

                final districts = filteredData.keys.toList()..sort();

                return ListView.builder(
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    String district = districts[index];
                    List<EmergencyContact> contacts = filteredData[district]!;
                    return ExpansionTile(
                      title: Text(district, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      children: contacts.map((contact) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: ListTile(
                            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(contact.phone),
                            trailing: IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () => _makePhoneCall(contact.phone),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
