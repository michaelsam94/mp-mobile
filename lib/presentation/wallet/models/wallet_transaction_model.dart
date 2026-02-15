import 'package:mega_plus/presentation/wallet/models/charging_transaction_response_model.dart';
import 'package:mega_plus/presentation/wallet/models/top_up_response_model.dart';

enum TransactionType { topup, charging }

class WalletTransactionModel {
  TransactionType type;
  String? amount;
  String? currency;
  String? createdAt;

  WalletTransactionModel({
    required this.type,
    this.amount,
    this.currency,
    this.createdAt,
  });

  factory WalletTransactionModel.fromTopUp(TopUpTransactionResponseModel topup) {
    return WalletTransactionModel(
      type: TransactionType.topup,
      amount: topup.amount,
      currency: topup.currency,
      createdAt: topup.createdAt,
    );
  }

  factory WalletTransactionModel.fromCharging(ChargingTransactionResponseModel charging) {
    return WalletTransactionModel(
      type: TransactionType.charging,
      amount: charging.cost,
      currency: charging.currency,
      createdAt: charging.createdAt,
    );
  }
}

