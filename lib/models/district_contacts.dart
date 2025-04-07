import 'emergency_contact.dart';

class DistrictContacts {
  final String district;
  final List<EmergencyContact> contacts;

  DistrictContacts({
    required this.district,
    required this.contacts,
  });

  // ✅ Define fromMap factory method
  factory DistrictContacts.fromMap(Map<String, dynamic> map) {
    return DistrictContacts(
      district: map['district'] ?? '',
      contacts: List<EmergencyContact>.from(
        (map['contacts'] ?? []).map((contact) => EmergencyContact.fromMap(contact)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'district': district,
      'contacts': contacts.map((contact) => contact.toMap()).toList(),
    };
  }
}
