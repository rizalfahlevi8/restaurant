import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/setting/setting_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      settingProvider.themeMode == ThemeMode.dark
                          ? "Tema Gelap"
                          : "Tema Terang",
                      style: TextStyle(fontSize: 20),
                    ),
                    Switch(
                      value: settingProvider.themeMode == ThemeMode.dark,
                      onChanged: (bool value) {
                        context.read<SettingProvider>().saveThemeValue();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      settingProvider.isReminderEnabled == true
                          ? "Reminder Aktif"
                          : "Reminder Tidak Aktif",
                      style: TextStyle(fontSize: 20),
                    ),
                    Switch(
                      value: settingProvider.isReminderEnabled == true,
                      onChanged: (bool value) {
                        context.read<SettingProvider>().saveReminderValue();
                      },
                    ),
                  ],
                ),
                Text(
                  settingProvider.permission == true
                      ? "Izin Notifikasi: Diberikan"
                      : "Izin Notifikasi: Ditolak",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
