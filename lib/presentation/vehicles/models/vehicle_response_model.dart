import 'package:mega_plus/presentation/vehicles/models/model_response_model.dart';

class VehicleResponseModel {
  int? id;
  int? customerId;
  int? brandModelId;
  String? connectorType;
  String? plateNumber;
  int? year;
  String? color;
  String? createdAt;
  ModelResponseModel? brandModel;

  VehicleResponseModel({
    this.id,
    this.customerId,
    this.brandModelId,
    this.connectorType,
    this.plateNumber,
    this.year,
    this.color,
    this.createdAt,
    this.brandModel,
  });

  VehicleResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    brandModelId = json['brand_model_id'];
    connectorType = json['connector_type'];
    plateNumber = json['plate_number'];
    year = json['year'];
    color = json['color'];
    createdAt = json['created_at'];
    brandModel = json['brand_model'] != null
        ? ModelResponseModel.fromJson(json['brand_model'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['brand_model_id'] = brandModelId;
    data['connector_type'] = connectorType;
    data['plate_number'] = plateNumber;
    data['year'] = year;
    data['color'] = color;
    data['created_at'] = createdAt;
    if (brandModel != null) {
      data['brand_model'] = brandModel!.toJson();
    }
    return data;
  }
}
