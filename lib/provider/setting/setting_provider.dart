import 'package:flutter/material.dart';
import 'package:restaurant/services/shared_preferences_service.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SettingProvider(this._service) {
    getThemeValue();
  }

  String _message = "";
  String get message => _message;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void getThemeValue() async {
    try {
      final savedTheme = await _service.getThemeValue();
      if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
      _message = "Data successfully retrieved";
    } catch (e) {
      _message = "Failed to get your data";
    }
    notifyListeners();
  }

  Future<void> saveThemeValue() async {
    try {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
      await _service.saveTheme(_themeMode == ThemeMode.dark ? 'dark' : 'light');
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }
}
