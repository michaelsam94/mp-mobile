class ChargingTransactionResponseModel {
  String? cost;
  String? currency;
  String? createdAt;

  ChargingTransactionResponseModel({this.cost, this.currency, this.createdAt});

  ChargingTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    // Prefer cost; some APIs send amount for charging rows.
    cost = _jsonToDisplayString(json['cost'] ?? json['amount']);
    currency = _jsonToDisplayString(json['currency']);
    createdAt = _jsonToDisplayString(json['created_at']);
  }

  static String? _jsonToDisplayString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cost'] = cost;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    return data;
  }
}

