class ProductCustomizationModel {
  final String sizeId;
  final String sugarLevelId;
  final String iceLevelId;
  final List<String> toppingIds;
  final String note;

  const ProductCustomizationModel({
    required this.sizeId,
    required this.sugarLevelId,
    required this.iceLevelId,
    required this.toppingIds,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'sizeId': sizeId,
      'sugarLevelId': sugarLevelId,
      'iceLevelId': iceLevelId,
      'toppingIds': toppingIds,
      'note': note,
    };
  }
  factory ProductCustomizationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductCustomizationModel(
      sizeId: json['sizeId']?.toString() ?? '',
      sugarLevelId:
      json['sugarLevelId']?.toString() ?? '',
      iceLevelId:
      json['iceLevelId']?.toString() ?? '',
      toppingIds: (json['toppingIds'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      note: json['note']?.toString() ?? '',
    );
  }
}