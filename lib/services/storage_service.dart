import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _plannerKey = 'planner_tasks';
  static const String _calendarKey = 'calendar_events';

  // PLANNER
  static Future<void> savePlannerTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_plannerKey, jsonEncode(tasks));
  }

  static Future<List<Map<String, dynamic>>> getPlannerTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_plannerKey);
    if (json == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  // CALENDAR - FIXED DATE FORMAT
  static Future<void> saveCalendarEvents(Map<String, List<String>> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calendarKey, jsonEncode(events));
  }

  static Future<Map<String, List<String>>> getCalendarEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_calendarKey);
    if (json == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(json);
    return decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
  }
}
