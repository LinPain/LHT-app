import 'package:get/get.dart';

import '../controllers/order_tracking_controller.dart';
import '../controllers/orders_controller.dart';

class OrderTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderTrackingController>(
          () => OrderTrackingController(
        ordersController: Get.find<OrdersController>(),
      ),
    );
  }
}