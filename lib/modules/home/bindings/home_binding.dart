import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository productRepository;

  HomeController({
    required this.productRepository,
  });

  final products = <ProductModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await productRepository.getProducts();

      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}