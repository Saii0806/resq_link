class UserProfile {
  final String name;
  final String email;
  final String profilePictureUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
  });

  // Convert a UserProfile into a Map. This will allow us to save it in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Convert a Map into a UserProfile object.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      email: map['email'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}
