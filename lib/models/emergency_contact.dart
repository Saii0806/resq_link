class EmergencyContact {
  final int? id;
  final String name;
  final String phone;
  final String district;

  EmergencyContact({
    this.id,
    required this.name,
    required this.phone,
    required this.district,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? json['service'] ?? '',
      phone: json['phone'] ?? json['contact'] ?? '',
      district: json['district'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'district': district,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      district: map['district'],
    );
  }
}
