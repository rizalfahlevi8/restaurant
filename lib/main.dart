import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/provider/detail/favorite_list_provider.dart';
import 'package:restaurant/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant/provider/home/restaurant_list_provider.dart';
import 'package:restaurant/provider/setting/payload_provider.dart';
import 'package:restaurant/provider/setting/setting_provider.dart';
import 'package:restaurant/provider/main/index_nav_provider.dart';
import 'package:restaurant/screen/detail/detail_screen.dart';
import 'package:restaurant/screen/main/main_screen.dart';
import 'package:restaurant/services/local_notification_service.dart';
import 'package:restaurant/services/shared_preferences_service.dart';
import 'package:restaurant/services/sqlite_service.dart';
import 'package:restaurant/services/workmanager_service.dart';
import 'package:restaurant/static/navigation_route.dart';
import 'package:restaurant/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localNotificationService = LocalNotificationService();
  await localNotificationService.init();
  await localNotificationService.configureLocalTimeZone();

  final workmanagerService = WorkmanagerService();
  await workmanagerService.init();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String route = NavigationRoute.mainRoute.name;
  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails?.notificationResponse;
    if (notificationResponse != null) {
      payload = notificationResponse.payload;
      route = NavigationRoute.detailRoute.name;
    }
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => localNotificationService),
        Provider(create: (context) => workmanagerService),
        Provider(create: (context) => SqliteService()),
        Provider(create: (context) => SharedPreferencesService(prefs)),
        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
          create: (context) => PayloadProvider(
            payload: payload,
          ),
        ),
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              FavoriteListProvider(context.read<SqliteService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(
            context.read<SharedPreferencesService>(),
            localNotificationService,
          )..requestPermissions(),
        ),
      ],
      child: MainApp(initialRoute: route),
    ),
  );
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  final String? payload;
  const MainApp({super.key, required this.initialRoute, this.payload});

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
          initialRoute: initialRoute,
          onGenerateRoute: (settings) {
            if (settings.name == NavigationRoute.detailRoute.name) {
              final payloadProvider = context.read<PayloadProvider>();
              final payload = payloadProvider.payload;
              final restaurantId = payload ?? settings.arguments as String;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                payloadProvider.clearPayload();
              });

              return MaterialPageRoute(
                builder: (context) => DetailScreen(restaurantId: restaurantId),
              );
            }

            return MaterialPageRoute(
              builder: (context) => const MainScreen(),
            );
          },
        );
      },
    );
  }
}
