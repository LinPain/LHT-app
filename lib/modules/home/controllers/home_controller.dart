import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductCatalog productRepository;

  HomeController({required this.productRepository});

  final products = <ProductModel>[].obs;
  final campaigns = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  List<ProductModel> get signatureProducts {
    return products.take(4).toList();
  }

  @override
  void onInit() {
    super.onInit();
    refreshHome();
  }

  Future<void> refreshHome() async {
    await Future.wait([loadProducts(), loadCampaigns()]);
  }

  Future<void> loadCampaigns() async {
    try {
      campaigns.assignAll(await productRepository.getCampaigns());
    } catch (_) {
      campaigns.clear();
    }
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
