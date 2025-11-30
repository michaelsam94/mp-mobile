import 'package:mega_plus/presentation/vehicles/models/model_response_model.dart';

class VehicleResponseModel {
  int? id;
  int? customerId;
  int? brandModelId;
  String? connectorType;
  String? createdAt;
  ModelResponseModel? brandModel;

  VehicleResponseModel({
    this.id,
    this.customerId,
    this.brandModelId,
    this.connectorType,
    this.createdAt,
    this.brandModel,
  });

  VehicleResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    brandModelId = json['brand_model_id'];
    connectorType = json['connector_type'];
    createdAt = json['created_at'];
    brandModel = json['brand_model'] != null
        ? new ModelResponseModel.fromJson(json['brand_model'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['brand_model_id'] = this.brandModelId;
    data['connector_type'] = this.connectorType;
    data['created_at'] = this.createdAt;
    if (this.brandModel != null) {
      data['brand_model'] = this.brandModel!.toJson();
    }
    return data;
  }
}
