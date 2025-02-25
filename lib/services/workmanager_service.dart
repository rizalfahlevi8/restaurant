import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/services/local_notification_service.dart';
import 'package:restaurant/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      if (task == MyWorkmanager.periodic.taskName) {
        int notificationId = inputData?["notificationId"] ?? 0;

        final apiService = ApiService();
        final notificationService = LocalNotificationService();

        final restaurant = await apiService.fetchRandomRestaurant();
        await notificationService.showNotification(
          id: notificationId,
          title: "Rekomendasi Restoran Hari Ini",
          body:
              "Coba kunjungi Restaurant ${restaurant['name']} di kota ${restaurant['city']}",
          payload: "${restaurant['id']}",
        );
      }
      return Future.value(true);
    },
  );
}

class WorkmanagerService {
  final Workmanager _workmanager = Workmanager();

  WorkmanagerService();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runPeriodicTask({required int notificationId}) async {
    final now = DateTime.now();
    final DateTime scheduledTime =
        DateTime(now.year, now.month, now.day, 11);

    if (now.isAfter(scheduledTime)) {
      scheduledTime.add(const Duration(days: 1));
    }

    final Duration initialDelay = scheduledTime.difference(now);

    await _workmanager.registerOneOffTask(
      "oneTimeTask",
      MyWorkmanager.periodic.taskName,
      initialDelay: initialDelay,
      inputData: {"notificationId": notificationId},
    );

    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(days: 1), 
      initialDelay: initialDelay,
      inputData: {"notificationId": notificationId},
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
