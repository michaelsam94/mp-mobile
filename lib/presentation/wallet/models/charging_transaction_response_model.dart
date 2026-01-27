class ChargingTransactionResponseModel {
  String? cost;
  String? currency;
  String? createdAt;

  ChargingTransactionResponseModel({this.cost, this.currency, this.createdAt});

  ChargingTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    currency = json['currency'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cost'] = cost;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    return data;
  }
}

