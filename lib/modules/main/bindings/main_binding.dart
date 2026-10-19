import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/providers/api_client.dart';
import '../../account/controllers/account_controller.dart';
import '../../../data/repositories/product_repository.dart';

import '../../home/controllers/home_controller.dart';
import '../../menu/controllers/menu_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MainController>()) {
      Get.put<MainController>(MainController(), permanent: true);
    }

    // API
    Get.lazyPut<ApiClient>(
      () => ApiProvider(
        baseUrl: const String.fromEnvironment('API_BASE_URL').isNotEmpty
            ? const String.fromEnvironment('API_BASE_URL')
            : (kIsWeb
                ? 'http://localhost:5000'
                : (defaultTargetPlatform == TargetPlatform.iOS
                    ? 'http://127.0.0.1:5000'
                    : 'http://10.0.2.2:5000')),
      ),
    );

    if (!Get.isRegistered<AccountController>()) {
      Get.put<AccountController>(
        AccountController(apiProvider: Get.find<ApiClient>()),
        permanent: true,
      );
    }

    // Repository
    Get.lazyPut<ProductCatalog>(
      () => ProductRepository(apiProvider: Get.find<ApiClient>()),
    );

    // Home
    Get.lazyPut<HomeController>(
      () => HomeController(productRepository: Get.find<ProductCatalog>()),
    );

    // Menu
    Get.lazyPut<MenuController>(
      () => MenuController(productRepository: Get.find<ProductCatalog>()),
    );

    // Cart
    Get.put<CartController>(CartController(), permanent: true);

    Get.put<OrdersController>(
      OrdersController(apiProvider: Get.find<ApiClient>()),
      permanent: true,
    );

    Get.put<NotificationsController>(
      NotificationsController(apiProvider: Get.find<ApiClient>()),
      permanent: true,
    );
  }
}
