import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class MenuController extends GetxController {
  final ProductCatalog productRepository;

  MenuController({required this.productRepository});

  List<ProductModel> get filteredProducts {
    var result = products.toList();

    // Filter by category
    if (selectedCategory.value != 'Tất cả') {
      result = result
          .where((product) => product.categoryId == selectedCategory.value)
          .toList();
    }

    // Filter by search query
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  final products = <ProductModel>[].obs;

  final categories = <String>['Tất cả', 'Trà', 'Trà sữa', 'Trà trái cây'].obs;

  final searchQuery = ''.obs;

  final selectedCategory = 'Tất cả'.obs;

  final searchController = TextEditingController();

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadProducts();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final result = await productRepository.getCategories();
      categories.assignAll(['Tất cả', ...result]);
      if (!categories.contains(selectedCategory.value)) {
        selectedCategory.value = 'Tất cả';
      }
    } catch (_) {
      // Keep the built-in categories if the category endpoint is unavailable.
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

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void searchProducts(String value) {
    searchQuery.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
