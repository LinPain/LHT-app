import 'package:get/get.dart';

import '../../../data/repositories/product_repository.dart';

import '../controllers/menu_controller.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenuController>(
          () => MenuController(
        productRepository: Get.find<ProductRepository>(),
      ),
    );
  }
}