import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/provider/detail/favorite_list_provider.dart';
import 'package:restaurant/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant/provider/home/restaurant_list_provider.dart';
import 'package:restaurant/provider/setting/setting_provider.dart';
import 'package:restaurant/provider/main/index_nav_provider.dart';
import 'package:restaurant/screen/detail/detail_screen.dart';
import 'package:restaurant/screen/main/main_screen.dart';
import 'package:restaurant/services/local_notification_service.dart';
import 'package:restaurant/services/shared_preferences_service.dart';
import 'package:restaurant/services/sqlite_service.dart';
import 'package:restaurant/static/navigation_route.dart';
import 'package:restaurant/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localNotificationService = LocalNotificationService();
  await localNotificationService.init();
  await localNotificationService.configureLocalTimeZone();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => localNotificationService),
        Provider(create: (context) => SqliteService()),
        Provider(create: (context) => SharedPreferencesService(prefs)),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                FavoriteListProvider(context.read<SqliteService>())),
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantListProvider(context.read<ApiService>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantDetailProvider(context.read<ApiService>())),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(
            context.read<SharedPreferencesService>(),
            localNotificationService, 
          )..requestPermissions(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurant',
          debugShowCheckedModeBanner: false,
          theme: RestaurantTheme.lightTheme,
          darkTheme: RestaurantTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
          },
        );
      },
    );
  }
}

