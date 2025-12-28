class RFIDResponseModel {
  int? id;
  int? customerId;
  String? code;
  int? status;
  int? isDefault;
  String? createdAt;

  RFIDResponseModel({
    this.id,
    this.customerId,
    this.code,
    this.status,
    this.isDefault,
    this.createdAt,
  });

  RFIDResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    code = json['code'];
    status = json['status'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['code'] = this.code;
    data['status'] = this.status;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    return data;
  }
}
