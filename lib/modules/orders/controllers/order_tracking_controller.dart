import 'package:get/get.dart';

import '../../../data/models/order_model.dart';
import '../../../data/models/order_status.dart';
import 'orders_controller.dart';

class OrderTrackingController extends GetxController {
  final OrdersController ordersController;

  OrderTrackingController({
    required this.ordersController,
  });

  OrderModel? get order => ordersController.currentOrder.value;

  bool get hasOrder => order != null;

  bool isStatusCompleted(int statusIndex) {
    final currentOrder = order;

    if (currentOrder == null) {
      return false;
    }

    return currentOrder.status.index >= statusIndex;
  }

  void updateStatus(int statusIndex) {
    final currentOrder = order;

    if (currentOrder == null) {
      return;
    }

    final statuses = OrderStatus.values;

    if (statusIndex < 0 || statusIndex >= statuses.length) {
      return;
    }

    ordersController.updateCurrentOrderStatus(
      statuses[statusIndex],
    );
  }
}