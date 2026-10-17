import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../../data/providers/api_client.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(
        cartController: Get.find<CartController>(),
        apiProvider: Get.find<ApiClient>(),
      ),
    );
  }
}
