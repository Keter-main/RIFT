// lib/models/user_model.dart

class AppUser {
  final String uid;
  final String username;
  final String email;
  final DateTime dateOfBirth;
  final String? profilePictureUrl;
  final String currentEducation;
  final bool isStudent;
  final String? academicYear;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.dateOfBirth,
    this.profilePictureUrl,
    required this.currentEducation,
    required this.isStudent,
    this.academicYear,
  });

  // Method to convert AppUser object to a Map (for sending to a database)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(), // Convert DateTime to a string
      'profilePictureUrl': profilePictureUrl,
      'currentEducation': currentEducation,
      'isStudent': isStudent,
      'academicYear': academicYear,
    };
  }

  // NEW: Factory constructor to create an AppUser from a Map (for receiving from a database)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']), // Parse string back to DateTime
      profilePictureUrl: json['profilePictureUrl'],
      currentEducation: json['currentEducation'],
      isStudent: json['isStudent'],
      academicYear: json['academicYear'],
    );
  }

  // NEW: Method to create a copy of the user object with some fields updated
  AppUser copyWith({
    String? uid,
    String? username,
    String? email,
    DateTime? dateOfBirth,
    String? profilePictureUrl,
    String? currentEducation,
    bool? isStudent,
    String? academicYear,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      currentEducation: currentEducation ?? this.currentEducation,
      isStudent: isStudent ?? this.isStudent,
      academicYear: academicYear ?? this.academicYear,
    );
  }
}