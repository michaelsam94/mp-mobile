import 'package:mega_plus/presentation/vehicles/models/brand_response_model.dart';

class ModelResponseModel {
  int? id;
  int? brandId;
  String? name;
  String? createdAt;
  BrandResponseModel? brand;

  ModelResponseModel({
    this.id,
    this.brandId,
    this.name,
    this.createdAt,
    this.brand,
  });

  ModelResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    name = json['name'];
    createdAt = json['created_at'];
    brand = json['brand'] != null
        ? BrandResponseModel.fromJson(json['brand'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand_id'] = brandId;
    data['name'] = name;
    data['created_at'] = createdAt;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    return data;
  }
}
