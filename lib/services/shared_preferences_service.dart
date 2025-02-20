import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _themeKey = "themeKey";
  static const String _notificationKey = "notificationKey";

  Future<String?> getThemeValue() async {
    return _preferences.getString(_themeKey);
  }

  Future<String?> getNotificationValue() async {
    return _preferences.getString(_notificationKey);
  }

  Future<void> saveTheme(String theme) async {
    try {
      await _preferences.setString(_themeKey, theme);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Future<void> saveNotification(String theme) async {
    try {
      await _preferences.setString(_notificationKey, theme);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }
}
