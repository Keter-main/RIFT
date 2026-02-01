// lib/controllers/auth_controller.dart

// Rookie-friendly AuthController
// - Uses Firebase Auth for signin/signup
// - Stores user data in Realtime Database under: /Users/<uid>/
// - Uploads profile images to Firebase Storage under: profile_images/<uid>

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Minimal AppUser model with clear toJson/fromJson examples
class AppUser {
  final String uid;
  final String username;
  final String email;
  final DateTime dateOfBirth;
  final String currentEducation;
  final bool isStudent;
  final String? academicYear;
  final String? profilePictureUrl;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.dateOfBirth,
    required this.currentEducation,
    required this.isStudent,
    this.academicYear,
    this.profilePictureUrl,
  });

  // Convert AppUser -> Map for Firebase (must be a Map, not a JSON string)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      // store date as ISO string for readability
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'currentEducation': currentEducation,
      'isStudent': isStudent,
      'academicYear': academicYear,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  // Convert Map -> AppUser
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      currentEducation: json['currentEducation'] as String,
      isStudent: json['isStudent'] as bool,
      academicYear: json['academicYear'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }
}

class AuthController {
  // Firebase singletons
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthController();

  // ----------------------------
  // Helper: upload profile image
  // ----------------------------
  Future<String?> _uploadProfileImage(String uid, File? file) async {
    if (file == null) return null;
    try {
      final ref = _storage.ref().child('profile_images').child(uid);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // If upload fails, return null and let caller decide what to do
      print('Image upload failed: $e');
      return null;
    }
  }

  // ----------------------------
  // SIGNUP: create auth user and save profile under /Users/<uid>/
  // ----------------------------
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required DateTime dateOfBirth,
    File? profileImage,
    required String currentEducation,
    required bool isStudent,
    String? academicYear,
  }) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty || username.isEmpty || currentEducation.isEmpty) {
      return 'Please fill all required fields.';
    }

    try {
      // 1) Create Firebase Auth user
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);

      // 2) Upload profile image (if provided)
      final profileUrl = await _uploadProfileImage(uid, profileImage);

      // 3) Build AppUser and write to Realtime DB under /Users/<uid>/
      final user = AppUser(
        uid: uid,
        username: username,
        email: email,
        dateOfBirth: dateOfBirth,
        currentEducation: currentEducation,
        isStudent: isStudent,
        academicYear: academicYear,
        profilePictureUrl: profileUrl,
      );

      // IMPORTANT: This writes a Map (not a string) at /Users/<uid>/
      await _db.ref().child('Users').child(uid).set(user.toJson());

      // Optional: set displayName and send email verification
      try {
        await cred.user!.updateDisplayName(username);
        await cred.user!.sendEmailVerification();
      } catch (e) {
        // ignore non-critical failures
      }

      return 'success';
    } on FirebaseAuthException catch (e) {
      // Friendly error messages for common cases
      if (e.code == 'weak-password') return 'Password is too weak.';
      if (e.code == 'email-already-in-use') return 'Email is already registered.';
      if (e.code == 'invalid-email') return 'Invalid email address.';
      return e.message ?? 'Authentication error.';
    } catch (e) {
      // Generic fallback
      print('signUpUser error: $e');
      return e.toString();
    }
  }

  // ----------------------------
  // SIGNIN
  // ----------------------------
  Future<String> signInUser({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) return 'Please provide email and password.';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') return 'Incorrect email or password.';
      return e.message ?? 'Sign in error.';
    } catch (e) {
      return e.toString();
    }
  }

  // ----------------------------
  // SIGNOUT
  // ----------------------------
  Future<void> signOut() async => await _auth.signOut();

  // ----------------------------
  // GET USER DETAILS (reads /Users/<uid>/)
  // ----------------------------
  Future<AppUser> getUserDetails() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('No user logged in.');

    final uid = currentUser.uid;
    final snap = await _db.ref().child('Users').child(uid).get();

    if (!snap.exists || snap.value == null) {
      throw Exception('User data not found.');
    }

    // Convert the snapshot value to Map<String,dynamic>
    final data = Map<String, dynamic>.from(snap.value as Map);
    return AppUser.fromJson(data);
  }
}

// ----------------------------
// Short notes for rookies
// ----------------------------
// - Realtime DB is a big JSON tree. Using /Users/<uid>/ puts each user directly
//   under their UID which is simple and secure.
// - .set(map) writes the map as object fields. Do NOT use jsonEncode() here.
// - .push() is for lists (messages), not for storing one user's profile.
// - Always ensure your AppUser.toJson() returns a Map<String,dynamic>.
// - Secure your DB with rules so users can only write/read their own data.
