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
        builder: (context, themeProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Text(
                      themeProvider.themeMode == ThemeMode.dark 
                          ? "Tema Gelap" 
                          : "Tema Terang",
                      style: TextStyle(fontSize: 20),
                    ),
                    Switch(
                      value: themeProvider.themeMode == ThemeMode.dark,
                      onChanged: (bool value) {
                        context.read<SettingProvider>().saveThemeValue();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
              ],
            ),
          );
        },
      ),
    );
  }
}
