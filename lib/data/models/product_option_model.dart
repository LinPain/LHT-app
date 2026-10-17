class ProductOptionModel {
  final String id;
  final String name;
  final double extraPrice;
  final bool isAvailable;

  const ProductOptionModel({
    required this.id,
    required this.name,
    required this.extraPrice,
    required this.isAvailable,
  });

  factory ProductOptionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductOptionModel(
      id: json['id']?.toString() ??
          json['_id']?.toString() ??
          json['name']?.toString() ??
          '',
      name: json['name']?.toString() ?? '',
      extraPrice:
      (json['extraPrice'] as num?)?.toDouble() ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'extraPrice': extraPrice,
      'isAvailable': isAvailable,
    };
  }
}