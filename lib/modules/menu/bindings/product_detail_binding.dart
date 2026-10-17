import 'package:get/get.dart';

import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    final product = Get.arguments;

    if (product == null) {
      return;
    }

    Get.lazyPut<ProductDetailController>(
          () => ProductDetailController(
        product: product,
      ),
    );
  }
}