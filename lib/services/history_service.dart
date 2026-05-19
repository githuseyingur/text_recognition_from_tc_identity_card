import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_record.dart';

class HistoryService {
  static const _key = 'scan_history';
  static const _maxRecords = 50;

  static Future<List<ScanRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((s) => ScanRecord.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> add(ScanRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.insert(0, jsonEncode(record.toJson()));
    final trimmed = existing.take(_maxRecords).toList();
    await prefs.setStringList(_key, trimmed);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
