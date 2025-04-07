import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:resq_link/models/district_contacts.dart';


class EmergencyContactService {
  Future<List<DistrictContacts>> loadContacts() async {
    final String jsonString = await rootBundle.loadString('assets/emergency_contacts.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => DistrictContacts.fromMap(item)).toList();
  }
}
