import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String keyScore = 'guest_score';
  static const String keyLastWordIndex = 'guest_last_word_index';

  Future<void> saveGuestProgress(int score, int lastWordIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyScore, score);
    await prefs.setInt(keyLastWordIndex, lastWordIndex);
  }

  Future<Map<String, int>> getGuestProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'score': prefs.getInt(keyScore) ?? 0,
      'lastWordIndex': prefs.getInt(keyLastWordIndex) ?? 0,
    };
  }

  Future<void> clearGuestProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyScore);
    await prefs.remove(keyLastWordIndex);
  }
}
