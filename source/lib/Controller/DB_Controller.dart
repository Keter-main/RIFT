import 'package:shared_preferences/shared_preferences.dart';

class DbController {
  // --- Existing UID Method ---
  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid == null || uid.isEmpty) {
      print('❌ No UID found in SharedPreferences');
      return null;
    }

    print('✅ UID loaded from SharedPreferences: $uid');
    return uid;
  }
  
/// Clears auth-related data while preserving settings like theme
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid'); 
    print('✅ Auth data (UID) cleared from SharedPreferences');
  }

  // --- New Streak Methods ---

  /// Gets the current streak count. Defaults to 0 if not found.
  static Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_streak') ?? 0;
  }

  /// Gets the last activity date as an ISO 8601 String.
  static Future<String?> getLastActivityDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_activity_date');
  }

  /// Updates both the streak count and the activity timestamp.
  static Future<void> updateStreak(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_streak', count);
    
    // Also update the date to "Today" whenever the streak is updated
    await prefs.setString('last_activity_date', DateTime.now().toIso8601String());
    print('✅ Streak updated to $count on ${DateTime.now()}');
  }
}