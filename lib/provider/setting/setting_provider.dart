import 'package:flutter/material.dart';
import 'package:restaurant/services/local_notification_service.dart';
import 'package:restaurant/services/shared_preferences_service.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferencesService _service;
  final LocalNotificationService flutterNotificationService;

  SettingProvider(this._service, this.flutterNotificationService) {
    getThemeValue();
    getReminderValue();
    requestPermissions();
  }

  String _message = "";
  String get message => _message;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool _isReminderEnabled = false;
  bool get isReminderEnabled => _isReminderEnabled;

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

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

  Future<void> getReminderValue() async {
    _isReminderEnabled = (await _service.getReminderValue()) ?? false;

    if (_isReminderEnabled) {
      _notificationId += 1;
      flutterNotificationService.scheduleDailyElevenAMNotification(id: _notificationId);
    }

    notifyListeners();
  }

  Future<void> saveReminderValue() async {
    if (_permission == false || _permission == null) {
      await requestPermissions();
    }

    _isReminderEnabled = !_isReminderEnabled;
    await _service.saveReminder(_isReminderEnabled);

    if (_isReminderEnabled) {
      _notificationId += 1;
      flutterNotificationService.scheduleDailyElevenAMNotification(
        id: _notificationId,
      );
    } else {
      await flutterNotificationService.cancelReminder();
    }

    notifyListeners();
  }

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }
}
