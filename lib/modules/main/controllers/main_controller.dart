import 'package:get/get.dart';

import '../../orders/controllers/orders_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  final isHistoryPage = false.obs;

  final isNotificationPage = false.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    isHistoryPage.value = false;
    isNotificationPage.value = false;
  }

  void openHistory() {
    if (Get.isRegistered<OrdersController>()) {
      Get.find<OrdersController>().loadMyOrders();
    }
    isHistoryPage.value = true;
    isNotificationPage.value = false;
  }

  void openNotifications() {
    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().loadNotifications();
    }
    isNotificationPage.value = true;
    isHistoryPage.value = false;
  }
}
