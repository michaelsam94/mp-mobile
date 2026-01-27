class RFIDResponseModel {
  int? id;
  int? customerId;
  String? code;
  int? status;
  int? isDefault;

  RFIDResponseModel({this.id, this.customerId, this.code, this.status, this.isDefault});

  RFIDResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    code = json['code'];
    status = json['status'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['code'] = code;
    data['status'] = status;
    data['is_default'] = isDefault;
    return data;
  }
}
