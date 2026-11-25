import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _unlockedLevelKey = 'unlocked_level';
  static const String _starsKey = 'total_stars';

  Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unlockedLevelKey) ?? 1;
  }

  Future<int> getTotalStars() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_starsKey) ?? 0;
  }

  Future<void> completeLevel(int levelCompleted, int starsEarned) async {
    final prefs = await SharedPreferences.getInstance();
    int currentUnlocked = prefs.getInt(_unlockedLevelKey) ?? 1;
    int currentStars = prefs.getInt(_starsKey) ?? 0;

    if (levelCompleted >= currentUnlocked && levelCompleted < 12) {
      await prefs.setInt(_unlockedLevelKey, levelCompleted + 1);
    }
    await prefs.setInt(_starsKey, currentStars + starsEarned);
  }
}
