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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['token'] = token;
    data['masked_pan'] = maskedPan;
    data['status'] = status;
    data['card_type'] = cardType;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    return data;
  }
}
