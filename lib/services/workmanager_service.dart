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

        DateTime now = DateTime.now();

        if (now.hour == 11 && now.minute >= 0 && now.minute <= 15) {
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
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 15),
      initialDelay: Duration.zero,
      inputData: {"notificationId": notificationId},
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
