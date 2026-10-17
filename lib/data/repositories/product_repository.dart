import '../models/product_model.dart';
import '../providers/api_client.dart';

abstract interface class ProductCatalog {
  Future<List<ProductModel>> getProducts();
  Future<List<String>> getCategories();
  Future<List<Map<String, dynamic>>> getCampaigns();
}

class ProductRepository implements ProductCatalog {
  final ApiClient apiProvider;

  const ProductRepository({required this.apiProvider});

  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await apiProvider.get('/api/products');
    if (data is! List) throw Exception('Danh sách sản phẩm không hợp lệ.');

    return data
        .whereType<Map>()
        .map((json) => ProductModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final data = await apiProvider.get('/api/products/categories');
    if (data is! List) throw Exception('Danh mục sản phẩm không hợp lệ.');

    return data
        .whereType<Map>()
        .map((item) => item['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getCampaigns() async {
    final data = await apiProvider.get('/api/customers/campaigns');
    if (data is! List) throw Exception('Danh sách khuyến mãi không hợp lệ.');

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
