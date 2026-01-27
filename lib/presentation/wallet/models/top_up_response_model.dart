class TopUpTransactionResponseModel {
  String? amount;
  String? currency;
  String? createdAt;

  TopUpTransactionResponseModel({this.amount, this.currency, this.createdAt});

  TopUpTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    return data;
  }
}
