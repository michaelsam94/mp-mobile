class SavedCardResponseModel {
  int? id;
  int? customerId;
  String? token;
  String? maskedPan;
  String? status;
  String? cardType;
  int? isDefault;
  String? createdAt;

  SavedCardResponseModel(
      {this.id,
      this.customerId,
      this.token,
      this.maskedPan,
      this.status,
      this.cardType,
      this.isDefault,
      this.createdAt});

  SavedCardResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    token = json['token'];
    maskedPan = json['masked_pan'];
    status = json['status'];
    cardType = json['card_type'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['token'] = this.token;
    data['masked_pan'] = this.maskedPan;
    data['status'] = this.status;
    data['card_type'] = this.cardType;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    return data;
  }
}
