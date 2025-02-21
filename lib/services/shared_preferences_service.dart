import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _themeKey = "themeKey";
  static const String _reminderKey = "rememberKey";

  Future<String?> getThemeValue() async {
    return _preferences.getString(_themeKey);
  }

  Future<bool?> getReminderValue() async {
    return _preferences.getBool(_reminderKey) ?? false;
  }

  Future<void> saveTheme(String theme) async {
    try {
      await _preferences.setString(_themeKey, theme);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Future<void> saveReminder(bool isEnabled) async {
    try {
      await _preferences.setBool(_reminderKey, isEnabled);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }
}
