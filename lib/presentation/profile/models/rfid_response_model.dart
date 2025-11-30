class RFIDResponseModel {
  int? id;
  int? customerId;
  String? code;
  int? status;

  RFIDResponseModel({this.id, this.customerId, this.code, this.status});

  RFIDResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['code'] = this.code;
    data['status'] = this.status;
    return data;
  }
}
