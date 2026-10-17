import 'package:get/get.dart';

import '../../../data/providers/api_client.dart';

class NotificationsController extends GetxController {
  NotificationsController({required this.apiProvider});
  final ApiClient apiProvider;
  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> loadNotifications() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await apiProvider.get('/api/notifications');
      if (data is List) {
        notifications.assignAll(
          data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)),
        );
      }
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead(Map<String, dynamic> notification) async {
    final id = notification['id']?.toString() ?? '';
    if (id.isEmpty || notification['isRead'] == true) return;
    try {
      await apiProvider.patch('/api/notifications/$id/read');
      notification['isRead'] = true;
      notifications.refresh();
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> markAllRead() async {
    try {
      await apiProvider.patch('/api/notifications/read-all');
      for (final item in notifications) {
        item['isRead'] = true;
      }
      notifications.refresh();
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    }
  }
}
