import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _keyName = 'name';
  static const _keyCollege = 'college';
  static const _keyUid = 'uid';
  static const _keyLoggedIn = 'logged_in';

  static Future<void> saveUser({
    required String name,
    required String college,
    required String uid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyCollege, college);
    await prefs.setString(_keyUid, uid);
    await prefs.setBool(_keyLoggedIn, true);
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'college': prefs.getString(_keyCollege),
      'uid': prefs.getString(_keyUid),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
