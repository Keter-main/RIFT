import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  
Future<String?> getUsername() async {
  try {
    // 1️⃣ Get UID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid == null) {
      print('⚠️ UID not found in SharedPreferences');
      return null;
    }

    // 2️⃣ Fetch username from Realtime Database
    final ref = FirebaseDatabase.instance.ref('Users/$uid/username');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final username = snapshot.value.toString();
      print('✅ Username fetched successfully: $username');
      return username;
    } else {
      print('⚠️ No username found for UID: $uid');
      return null;
    }
  } catch (e) {
    print('❌ Error fetching username: $e');
    return null;
  }
}


}